ARCHS = arm64
TARGET := iphone:clang:14.5:14.0
INSTALL_TARGET_PROCESSES = Twitter
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BHTwitter
FLEX_FILES = $(shell find Classes \( -name '*.c' -o -name '*.m' -o -name '*.mm' \))
FLEX_INCLUDE_DIRS = $(shell find Classes -type d)
XCODE_IOS_SDK_PATH = $(shell xcrun --sdk iphoneos --show-sdk-path)
LIBCXX_INCLUDE_PATH = $(XCODE_IOS_SDK_PATH)/usr/include/c++/v1

BHTwitter_FILES = Tweak.x $(wildcard *.m BHDownload/*.m BHTBundle/*.m Colours/*.m JGProgressHUD/*.m SAMKeychain/*.m AppIcon/*.m CustomTabBar/*.m ThemeColor/*.m) $(FLEX_FILES)
BHTwitter_FRAMEWORKS = UIKit Foundation AVFoundation AVKit CoreMotion GameController VideoToolbox Accelerate CoreMedia CoreImage CoreGraphics ImageIO Photos CoreServices SystemConfiguration SafariServices Security QuartzCore WebKit SceneKit UserNotifications
BHTwitter_PRIVATE_FRAMEWORKS = Preferences
BHTwitter_EXTRA_FRAMEWORKS = Cephei CepheiPrefs CepheiUI
BHTwitter_OBJ_FILES = $(shell find lib -name '*.a')
BHTwitter_LIBRARIES = sqlite3 bz2 c++ iconv z
BHTwitter_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-nullability-completeness -Wno-unused-function -Wno-unused-property-ivar -Wno-error $(foreach dir,$(FLEX_INCLUDE_DIRS),-I$(dir))
BHTwitter_OBJCCFLAGS = $(if $(wildcard $(LIBCXX_INCLUDE_PATH)),-isystem $(LIBCXX_INCLUDE_PATH))

include $(THEOS_MAKE_PATH)/tweak.mk

ifdef SIDELOADED
SUBPROJECTS += keychainfix
endif

include $(THEOS_MAKE_PATH)/aggregate.mk
