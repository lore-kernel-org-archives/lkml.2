Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab0L3EC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 23:02:59 -0500
Received: from smtp-out.google.com ([74.125.121.67]:9734 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0L3ECq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 23:02:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=mgqz29hu22kzX34NNsx8eMrAq/s7VDK78bueRAAn7Tv+kUefDeyLFXzkMCuJXIfc+y
         6klEEM/oaPJ+aubq2lWA==
Date: Wed, 29 Dec 2010 20:02:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/8] drivers: rename CONFIG_EMBEDDED to CONFIG_EXPERT
In-Reply-To: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1012292000250.27241@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_EMBEDDED has been renamed to CONFIG_EXPERT, so fix it in the
drivers/ directory.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/acpi/Kconfig                 |    2 +-
 drivers/ata/Kconfig                  |    2 +-
 drivers/base/Kconfig                 |    2 +-
 drivers/char/Kconfig                 |   10 +++---
 drivers/cpufreq/Kconfig              |    2 +-
 drivers/firmware/Kconfig             |    2 +-
 drivers/gpu/drm/Kconfig              |    2 +-
 drivers/gpu/drm/nouveau/Kconfig      |    2 +-
 drivers/gpu/vga/Kconfig              |    2 +-
 drivers/hid/Kconfig                  |   64 +++++++++++++++++-----------------
 drivers/hid/usbhid/Kconfig           |    2 +-
 drivers/ide/Kconfig                  |    2 +-
 drivers/infiniband/hw/mthca/Kconfig  |    2 +-
 drivers/infiniband/ulp/ipoib/Kconfig |    2 +-
 drivers/input/Kconfig                |    6 ++--
 drivers/input/keyboard/Kconfig       |    4 +-
 drivers/input/mouse/Kconfig          |   10 +++---
 drivers/input/serio/Kconfig          |    6 ++--
 drivers/input/touchscreen/Kconfig    |   30 ++++++++--------
 drivers/media/common/tuners/Kconfig  |    2 +-
 drivers/media/dvb/frontends/Kconfig  |    2 +-
 drivers/media/video/Kconfig          |    2 +-
 drivers/net/Kconfig                  |    2 +-
 drivers/pci/pcie/Kconfig             |    2 +-
 drivers/pcmcia/Kconfig               |   12 +++---
 drivers/serial/Kconfig               |    4 +-
 drivers/ssb/Kconfig                  |    2 +-
 drivers/usb/core/Kconfig             |    6 ++--
 drivers/video/Kconfig                |    2 +-
 drivers/video/console/Kconfig        |    2 +-
 30 files changed, 96 insertions(+), 96 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -310,7 +310,7 @@ config ACPI_PCI_SLOT
 	  the module will be called pci_slot.
 
 config X86_PM_TIMER
-	bool "Power Management Timer Support" if EMBEDDED
+	bool "Power Management Timer Support" if EXPERT
 	depends on X86
 	default y
 	help
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -775,7 +775,7 @@ config HAVE_PATA_PLATFORM
 
 config PATA_PLATFORM
 	tristate "Generic platform device PATA support"
-	depends on EMBEDDED || PPC || HAVE_PATA_PLATFORM
+	depends on EXPERT || PPC || HAVE_PATA_PLATFORM
 	help
 	  This option enables support for generic directly connected ATA
 	  devices commonly found on embedded systems.
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -70,7 +70,7 @@ config PREVENT_FIRMWARE_BUILD
 	  If unsure say Y here.
 
 config FW_LOADER
-	tristate "Userspace firmware loading support" if EMBEDDED
+	tristate "Userspace firmware loading support" if EXPERT
 	default y
 	---help---
 	  This option is provided for the case where no in-kernel-tree modules
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -5,7 +5,7 @@
 menu "Character devices"
 
 config VT
-	bool "Virtual terminal" if EMBEDDED
+	bool "Virtual terminal" if EXPERT
 	depends on !S390
 	select INPUT
 	default y
@@ -39,13 +39,13 @@ config VT
 config CONSOLE_TRANSLATIONS
 	depends on VT
 	default y
-	bool "Enable character translations in console" if EMBEDDED
+	bool "Enable character translations in console" if EXPERT
 	---help---
 	  This enables support for font mapping and Unicode translation
 	  on virtual consoles.
 
 config VT_CONSOLE
-	bool "Support for console on virtual terminal" if EMBEDDED
+	bool "Support for console on virtual terminal" if EXPERT
 	depends on VT
 	default y
 	---help---
@@ -429,7 +429,7 @@ config SGI_MBCS
 source "drivers/serial/Kconfig"
 
 config UNIX98_PTYS
-	bool "Unix98 PTY support" if EMBEDDED
+	bool "Unix98 PTY support" if EXPERT
 	default y
 	---help---
 	  A pseudo terminal (PTY) is a software device consisting of two
@@ -495,7 +495,7 @@ config LEGACY_PTY_COUNT
 
 config TTY_PRINTK
 	bool "TTY driver to output user messages via printk"
-	depends on EMBEDDED
+	depends on EXPERT
 	default n
 	---help---
 	  If you say Y here, the support for writing user messages (i.e.
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -71,7 +71,7 @@ config CPU_FREQ_DEFAULT_GOV_PERFORMANCE
 
 config CPU_FREQ_DEFAULT_GOV_POWERSAVE
 	bool "powersave"
-	depends on EMBEDDED
+	depends on EXPERT
 	select CPU_FREQ_GOV_POWERSAVE
 	help
 	  Use the CPUFreq governor 'powersave' as default. This sets
diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -27,7 +27,7 @@ config EDD_OFF
 	  using the kernel parameter 'edd={on|skipmbr|off}'.
 
 config FIRMWARE_MEMMAP
-    bool "Add firmware-provided memory map to sysfs" if EMBEDDED
+    bool "Add firmware-provided memory map to sysfs" if EXPERT
     default X86
     help
       Add the firmware-provided (unmodified) memory map to /sys/firmware/memmap.
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -23,7 +23,7 @@ config DRM_KMS_HELPER
 	tristate
 	depends on DRM
 	select FB
-	select FRAMEBUFFER_CONSOLE if !EMBEDDED
+	select FRAMEBUFFER_CONSOLE if !EXPERT
 	help
 	  FB and CRTC helpers for KMS drivers.
 
diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -8,7 +8,7 @@ config DRM_NOUVEAU
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select FB
-	select FRAMEBUFFER_CONSOLE if !EMBEDDED
+	select FRAMEBUFFER_CONSOLE if !EXPERT
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
 	select ACPI_VIDEO if ACPI
 	help
diff --git a/drivers/gpu/vga/Kconfig b/drivers/gpu/vga/Kconfig
--- a/drivers/gpu/vga/Kconfig
+++ b/drivers/gpu/vga/Kconfig
@@ -1,5 +1,5 @@
 config VGA_ARB
-	bool "VGA Arbitration" if EMBEDDED
+	bool "VGA Arbitration" if EXPERT
 	default y
 	depends on PCI
 	help
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -62,9 +62,9 @@ config HID_3M_PCT
 	Support for 3M PCT touch screens.
 
 config HID_A4TECH
-	tristate "A4 tech mice" if EMBEDDED
+	tristate "A4 tech mice" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for A4 tech X5 and WOP-35 / Trust 450L mice.
 
@@ -77,9 +77,9 @@ config HID_ACRUX_FF
 	game controllers.
 
 config HID_APPLE
-	tristate "Apple {i,Power,Mac}Books" if EMBEDDED
+	tristate "Apple {i,Power,Mac}Books" if EXPERT
 	depends on (USB_HID || BT_HIDP)
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for some Apple devices which less or more break
 	HID specification.
@@ -88,9 +88,9 @@ config HID_APPLE
 	MacBooks, MacBook Pros and Apple Aluminum.
 
 config HID_BELKIN
-	tristate "Belkin Flip KVM and Wireless keyboard" if EMBEDDED
+	tristate "Belkin Flip KVM and Wireless keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Belkin Flip KVM and Wireless keyboard.
 
@@ -101,16 +101,16 @@ config HID_CANDO
 	Support for Cando dual touch panel.
 
 config HID_CHERRY
-	tristate "Cherry Cymotion keyboard" if EMBEDDED
+	tristate "Cherry Cymotion keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Cherry Cymotion keyboard.
 
 config HID_CHICONY
-	tristate "Chicony Tactical pad" if EMBEDDED
+	tristate "Chicony Tactical pad" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Chicony Tactical pad.
 
@@ -130,9 +130,9 @@ config HID_PRODIKEYS
 	  and some additional multimedia keys.
 
 config HID_CYPRESS
-	tristate "Cypress mouse and barcode readers" if EMBEDDED
+	tristate "Cypress mouse and barcode readers" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for cypress mouse and barcode readers.
 
@@ -163,16 +163,16 @@ config HID_ELECOM
 	Support for the ELECOM BM084 (bluetooth mouse).
 
 config HID_EZKEY
-	tristate "Ezkey BTC 8193 keyboard" if EMBEDDED
+	tristate "Ezkey BTC 8193 keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Ezkey BTC 8193 keyboard.
 
 config HID_KYE
-	tristate "Kye/Genius Ergo Mouse" if EMBEDDED
+	tristate "Kye/Genius Ergo Mouse" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Kye/Genius Ergo Mouse.
 
@@ -201,16 +201,16 @@ config HID_TWINHAN
 	Support for Twinhan IR remote control.
 
 config HID_KENSINGTON
-	tristate "Kensington Slimblade Trackball" if EMBEDDED
+	tristate "Kensington Slimblade Trackball" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Kensington Slimblade Trackball.
 
 config HID_LOGITECH
-	tristate "Logitech devices" if EMBEDDED
+	tristate "Logitech devices" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Logitech devices that are not fully compliant with HID standard.
 
@@ -265,9 +265,9 @@ config HID_MAGICMOUSE
 	Apple Wireless "Magic" Mouse.
 
 config HID_MICROSOFT
-	tristate "Microsoft non-fully HID-compliant devices" if EMBEDDED
+	tristate "Microsoft non-fully HID-compliant devices" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Microsoft devices that are not fully compliant with HID standard.
 
@@ -278,9 +278,9 @@ config HID_MOSART
 	Support for MosArt dual-touch panels.
 
 config HID_MONTEREY
-	tristate "Monterey Genius KB29E keyboard" if EMBEDDED
+	tristate "Monterey Genius KB29E keyboard" if EXPERT
 	depends on USB_HID
-	default !EMBEDDED
+	default !EXPERT
 	---help---
 	Support for Monterey Genius KB29E.
 
@@ -337,8 +337,8 @@ config HID_PICOLCD
 	  - IR
 
 config HID_PICOLCD_FB
-	bool "Framebuffer support" if EMBEDDED
-	default !EMBEDDED
+	bool "Framebuffer support" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=FB || FB=y
 	select FB_DEFERRED_IO
@@ -351,8 +351,8 @@ config HID_PICOLCD_FB
 	  frambuffer device.
 
 config HID_PICOLCD_BACKLIGHT
-	bool "Backlight control" if EMBEDDED
-	default !EMBEDDED
+	bool "Backlight control" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=y
 	---help---
@@ -360,16 +360,16 @@ config HID_PICOLCD_BACKLIGHT
 	  class.
 
 config HID_PICOLCD_LCD
-	bool "Contrast control" if EMBEDDED
-	default !EMBEDDED
+	bool "Contrast control" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=LCD_CLASS_DEVICE || LCD_CLASS_DEVICE=y
 	---help---
 	  Provide access to PicoLCD's LCD contrast via lcd class.
 
 config HID_PICOLCD_LEDS
-	bool "GPO via leds class" if EMBEDDED
-	default !EMBEDDED
+	bool "GPO via leds class" if EXPERT
+	default !EXPERT
 	depends on HID_PICOLCD
 	depends on HID_PICOLCD=LEDS_CLASS || LEDS_CLASS=y
 	---help---
diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
--- a/drivers/hid/usbhid/Kconfig
+++ b/drivers/hid/usbhid/Kconfig
@@ -45,7 +45,7 @@ config USB_HIDDEV
 	  If unsure, say Y.
 
 menu "USB HID Boot Protocol drivers"
-	depends on USB!=n && USB_HID!=y && EMBEDDED
+	depends on USB!=n && USB_HID!=y && EXPERT
 
 config USB_KBD
 	tristate "USB HIDBP Keyboard (simple Boot) support"
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -134,7 +134,7 @@ config BLK_DEV_IDECD
 	  module will be called ide-cd.
 
 config BLK_DEV_IDECD_VERBOSE_ERRORS
-	bool "Verbose error logging for IDE/ATAPI CDROM driver" if EMBEDDED
+	bool "Verbose error logging for IDE/ATAPI CDROM driver" if EXPERT
 	depends on BLK_DEV_IDECD
 	default y
 	help
diff --git a/drivers/infiniband/hw/mthca/Kconfig b/drivers/infiniband/hw/mthca/Kconfig
--- a/drivers/infiniband/hw/mthca/Kconfig
+++ b/drivers/infiniband/hw/mthca/Kconfig
@@ -7,7 +7,7 @@ config INFINIBAND_MTHCA
 	  ("Tavor") and the MT25208 PCI Express HCA ("Arbel").
 
 config INFINIBAND_MTHCA_DEBUG
-	bool "Verbose debugging output" if EMBEDDED
+	bool "Verbose debugging output" if EXPERT
 	depends on INFINIBAND_MTHCA
 	default y
 	---help---
diff --git a/drivers/infiniband/ulp/ipoib/Kconfig b/drivers/infiniband/ulp/ipoib/Kconfig
--- a/drivers/infiniband/ulp/ipoib/Kconfig
+++ b/drivers/infiniband/ulp/ipoib/Kconfig
@@ -25,7 +25,7 @@ config INFINIBAND_IPOIB_CM
 	  unless you limit mtu for these destinations to 2044.
 
 config INFINIBAND_IPOIB_DEBUG
-	bool "IP-over-InfiniBand debugging" if EMBEDDED
+	bool "IP-over-InfiniBand debugging" if EXPERT
 	depends on INFINIBAND_IPOIB
 	default y
 	---help---
diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -6,7 +6,7 @@ menu "Input device support"
 	depends on !S390
 
 config INPUT
-	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EMBEDDED
+	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EXPERT
 	default y
 	help
 	  Say Y here if you have any input device (mouse, keyboard, tablet,
@@ -67,7 +67,7 @@ config INPUT_SPARSEKMAP
 comment "Userland interfaces"
 
 config INPUT_MOUSEDEV
-	tristate "Mouse interface" if EMBEDDED
+	tristate "Mouse interface" if EXPERT
 	default y
 	help
 	  Say Y here if you want your mouse to be accessible as char devices
@@ -150,7 +150,7 @@ config INPUT_EVBUG
 	  module will be called evbug.
 
 config INPUT_APMPOWER
-	tristate "Input Power Event -> APM Bridge" if EMBEDDED
+	tristate "Input Power Event -> APM Bridge" if EXPERT
 	depends on INPUT && APM_EMULATION
 	help
 	  Say Y here if you want suspend key events to trigger a user
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -2,7 +2,7 @@
 # Input core configuration
 #
 menuconfig INPUT_KEYBOARD
-	bool "Keyboards" if EMBEDDED || !X86
+	bool "Keyboards" if EXPERT || !X86
 	default y
 	help
 	  Say Y here, and a list of supported keyboards will be displayed.
@@ -69,7 +69,7 @@ config KEYBOARD_ATARI
 	  module will be called atakbd.
 
 config KEYBOARD_ATKBD
-	tristate "AT keyboard" if EMBEDDED || !X86
+	tristate "AT keyboard" if EXPERT || !X86
 	default y
 	select SERIO
 	select SERIO_LIBPS2
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -39,7 +39,7 @@ config MOUSE_PS2
 	  module will be called psmouse.
 
 config MOUSE_PS2_ALPS
-	bool "ALPS PS/2 mouse protocol extension" if EMBEDDED
+	bool "ALPS PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
@@ -49,7 +49,7 @@ config MOUSE_PS2_ALPS
 	  If unsure, say Y.
 
 config MOUSE_PS2_LOGIPS2PP
-	bool "Logitech PS/2++ mouse protocol extension" if EMBEDDED
+	bool "Logitech PS/2++ mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
@@ -59,7 +59,7 @@ config MOUSE_PS2_LOGIPS2PP
 	  If unsure, say Y.
 
 config MOUSE_PS2_SYNAPTICS
-	bool "Synaptics PS/2 mouse protocol extension" if EMBEDDED
+	bool "Synaptics PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
@@ -69,7 +69,7 @@ config MOUSE_PS2_SYNAPTICS
 	  If unsure, say Y.
 
 config MOUSE_PS2_LIFEBOOK
-	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EMBEDDED
+	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2 && X86 && DMI
 	help
@@ -79,7 +79,7 @@ config MOUSE_PS2_LIFEBOOK
 	  If unsure, say Y.
 
 config MOUSE_PS2_TRACKPOINT
-	bool "IBM Trackpoint PS/2 mouse protocol extension" if EMBEDDED
+	bool "IBM Trackpoint PS/2 mouse protocol extension" if EXPERT
 	default y
 	depends on MOUSE_PS2
 	help
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -2,7 +2,7 @@
 # Input core configuration
 #
 config SERIO
-	tristate "Serial I/O support" if EMBEDDED || !X86
+	tristate "Serial I/O support" if EXPERT || !X86
 	default y
 	help
 	  Say Yes here if you have any input device that uses serial I/O to
@@ -19,7 +19,7 @@ config SERIO
 if SERIO
 
 config SERIO_I8042
-	tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
+	tristate "i8042 PC Keyboard controller" if EXPERT || !X86
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
 		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
@@ -168,7 +168,7 @@ config SERIO_MACEPS2
 	  module will be called maceps2.
 
 config SERIO_LIBPS2
-	tristate "PS/2 driver library" if EMBEDDED
+	tristate "PS/2 driver library" if EXPERT
 	depends on SERIO_I8042 || SERIO_I8042=n
 	help
 	  Say Y here if you are using a driver for device connected
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -540,62 +540,62 @@ config TOUCHSCREEN_MC13783
 
 config TOUCHSCREEN_USB_EGALAX
 	default y
-	bool "eGalax, eTurboTouch CT-410/510/700 device support" if EMBEDDED
+	bool "eGalax, eTurboTouch CT-410/510/700 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_PANJIT
 	default y
-	bool "PanJit device support" if EMBEDDED
+	bool "PanJit device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_3M
 	default y
-	bool "3M/Microtouch EX II series device support" if EMBEDDED
+	bool "3M/Microtouch EX II series device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_ITM
 	default y
-	bool "ITM device support" if EMBEDDED
+	bool "ITM device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_ETURBO
 	default y
-	bool "eTurboTouch (non-eGalax compatible) device support" if EMBEDDED
+	bool "eTurboTouch (non-eGalax compatible) device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_GUNZE
 	default y
-	bool "Gunze AHL61 device support" if EMBEDDED
+	bool "Gunze AHL61 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_DMC_TSC10
 	default y
-	bool "DMC TSC-10/25 device support" if EMBEDDED
+	bool "DMC TSC-10/25 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_IRTOUCH
 	default y
-	bool "IRTOUCHSYSTEMS/UNITOP device support" if EMBEDDED
+	bool "IRTOUCHSYSTEMS/UNITOP device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_IDEALTEK
 	default y
-	bool "IdealTEK URTC1000 device support" if EMBEDDED
+	bool "IdealTEK URTC1000 device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_GENERAL_TOUCH
 	default y
-	bool "GeneralTouch Touchscreen device support" if EMBEDDED
+	bool "GeneralTouch Touchscreen device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_GOTOP
 	default y
-	bool "GoTop Super_Q2/GogoPen/PenPower tablet device support" if EMBEDDED
+	bool "GoTop Super_Q2/GogoPen/PenPower tablet device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_JASTEC
 	default y
-	bool "JASTEC/DigiTech DTR-02U USB touch controller device support" if EMBEDDED
+	bool "JASTEC/DigiTech DTR-02U USB touch controller device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_E2I
@@ -605,17 +605,17 @@ config TOUCHSCREEN_USB_E2I
 
 config TOUCHSCREEN_USB_ZYTRONIC
 	default y
-	bool "Zytronic controller" if EMBEDDED
+	bool "Zytronic controller" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_ETT_TC45USB
 	default y
-	bool "ET&T USB series TC4UM/TC5UH touchscreen controler support" if EMBEDDED
+	bool "ET&T USB series TC4UM/TC5UH touchscreen controler support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_NEXIO
 	default y
-	bool "NEXIO/iNexio device support" if EMBEDDED
+	bool "NEXIO/iNexio device support" if EXPERT
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_TOUCHIT213
diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -34,7 +34,7 @@ config MEDIA_TUNER
 config MEDIA_TUNER_CUSTOMISE
 	bool "Customize analog and hybrid tuner modules to build"
 	depends on MEDIA_TUNER
-	default y if EMBEDDED
+	default y if EXPERT
 	help
 	  This allows the user to deselect tuner drivers unnecessary
 	  for their hardware from the build. Use this option with care
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -1,7 +1,7 @@
 config DVB_FE_CUSTOMISE
 	bool "Customise the frontend modules to build"
 	depends on DVB_CORE
-	default y if EMBEDDED
+	default y if EXPERT
 	help
 	  This allows the user to select/deselect frontend drivers for their
 	  hardware from the build.
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -83,7 +83,7 @@ config VIDEO_FIXED_MINOR_RANGES
 
 config VIDEO_HELPER_CHIPS_AUTO
 	bool "Autoselect pertinent encoders/decoders and other helper chips"
-	default y if !EMBEDDED
+	default y if !EXPERT
 	---help---
 	  Most video cards may require additional modules to encode or
 	  decode audio/video standards. This option will autoselect
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2861,7 +2861,7 @@ config MLX4_CORE
 	default n
 
 config MLX4_DEBUG
-	bool "Verbose debugging output" if (MLX4_CORE && EMBEDDED)
+	bool "Verbose debugging output" if (MLX4_CORE && EXPERT)
 	depends on MLX4_CORE
 	default y
 	---help---
diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -31,7 +31,7 @@ source "drivers/pci/pcie/aer/Kconfig"
 # PCI Express ASPM
 #
 config PCIEASPM
-	bool "PCI Express ASPM control" if EMBEDDED
+	bool "PCI Express ASPM control" if EXPERT
 	depends on PCI && PCIEPORTBUS
 	default y
 	help
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -69,7 +69,7 @@ comment "PC-card bridges"
 config YENTA
 	tristate "CardBus yenta-compatible bridge support"
 	depends on PCI
-	select CARDBUS if !EMBEDDED
+	select CARDBUS if !EXPERT
 	select PCCARD_NONSTATIC if PCMCIA != n
 	---help---
 	  This option enables support for CardBus host bridges.  Virtually
@@ -84,27 +84,27 @@ config YENTA
 
 config YENTA_O2
 	default y
-	bool "Special initialization for O2Micro bridges" if EMBEDDED
+	bool "Special initialization for O2Micro bridges" if EXPERT
 	depends on YENTA
 
 config YENTA_RICOH
 	default y
-	bool "Special initialization for Ricoh bridges" if EMBEDDED
+	bool "Special initialization for Ricoh bridges" if EXPERT
 	depends on YENTA
 
 config YENTA_TI
 	default y
-	bool "Special initialization for TI and EnE bridges" if EMBEDDED
+	bool "Special initialization for TI and EnE bridges" if EXPERT
 	depends on YENTA
 
 config YENTA_ENE_TUNE
 	default y
-	bool "Auto-tune EnE bridges for CB cards" if EMBEDDED
+	bool "Auto-tune EnE bridges for CB cards" if EXPERT
 	depends on YENTA_TI && CARDBUS
 
 config YENTA_TOSHIBA
 	default y
-	bool "Special initialization for Toshiba ToPIC bridges" if EMBEDDED
+	bool "Special initialization for Toshiba ToPIC bridges" if EXPERT
 	depends on YENTA
 
 config PD6729
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -81,7 +81,7 @@ config SERIAL_8250_GSC
 	default SERIAL_8250
 
 config SERIAL_8250_PCI
-	tristate "8250/16550 PCI device support" if EMBEDDED
+	tristate "8250/16550 PCI device support" if EXPERT
 	depends on SERIAL_8250 && PCI
 	default SERIAL_8250
 	help
@@ -90,7 +90,7 @@ config SERIAL_8250_PCI
 	  Saves about 9K.
 
 config SERIAL_8250_PNP
-	tristate "8250/16550 PNP device support" if EMBEDDED
+	tristate "8250/16550 PNP device support" if EXPERT
 	depends on SERIAL_8250 && PNP
 	default SERIAL_8250
 	help
diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -82,7 +82,7 @@ config SSB_SDIOHOST
 
 config SSB_SILENT
 	bool "No SSB kernel messages"
-	depends on SSB && EMBEDDED
+	depends on SSB && EXPERT
 	help
 	  This option turns off all Sonics Silicon Backplane printks.
 	  Note that you won't be able to identify problems, once
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -123,9 +123,9 @@ config USB_OTG
 
 config USB_OTG_WHITELIST
 	bool "Rely on OTG Targeted Peripherals List"
-	depends on USB_OTG || EMBEDDED
+	depends on USB_OTG || EXPERT
 	default y if USB_OTG
-	default n if EMBEDDED
+	default n if EXPERT
 	help
 	  If you say Y here, the "otg_whitelist.h" file will be used as a
 	  product whitelist, so USB peripherals not listed there will be
@@ -141,7 +141,7 @@ config USB_OTG_WHITELIST
 
 config USB_OTG_BLACKLIST_HUB
 	bool "Disable external hubs"
-	depends on USB_OTG || EMBEDDED
+	depends on USB_OTG || EXPERT
 	help
 	  If you say Y here, then Linux will refuse to enumerate
 	  external hubs.  OTG hosts are allowed to reduce hardware
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -1156,7 +1156,7 @@ config FB_CARILLO_RANCH
 
 config FB_INTEL
 	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EMBEDDED
+	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EXPERT
 	select FB_MODE_HELPERS
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -5,7 +5,7 @@
 menu "Console display driver support"
 
 config VGA_CONSOLE
-	bool "VGA text console" if EMBEDDED || !X86
+	bool "VGA text console" if EXPERT || !X86
 	depends on !4xx && !8xx && !SPARC && !M68K && !PARISC && !FRV && !SUPERH && !BLACKFIN && !AVR32 && !MN10300 && (!ARM || ARCH_FOOTBRIDGE || ARCH_INTEGRATOR || ARCH_NETWINDER)
 	default y
 	help
