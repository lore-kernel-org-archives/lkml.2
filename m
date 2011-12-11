Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1LKLUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 06:20:43 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:34275 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1LKLUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 06:20:40 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] m68k/serial: Remove references to obsolete serial config options
Date: Sun, 11 Dec 2011 12:20:32 +0100
Message-Id: <1323602432-20393-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - ATARI_MFPSER, ATARI_MIDI, MULTIFACE_III_TTY, and DN_SERIAL
    have no corresponding drivers (anymore),
  - Clean up SERIAL_CONSOLE dependencies and help text.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Bolle <pebolle@tiscali.nl>
---
 arch/m68k/Kconfig.devices           |   42 +++-------------------------------
 arch/m68k/configs/amiga_defconfig   |    1 -
 arch/m68k/configs/apollo_defconfig  |    2 -
 arch/m68k/configs/atari_defconfig   |    3 --
 arch/m68k/configs/multi_defconfig   |    4 ---
 arch/m68k/configs/mvme16x_defconfig |    1 -
 6 files changed, 4 insertions(+), 49 deletions(-)

diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index e01eeb2..052cb64 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -59,27 +59,6 @@ endmenu
 
 menu "Character devices"
 
-config ATARI_MFPSER
-	tristate "Atari MFP serial support"
-	depends on ATARI
-	---help---
-	  If you like to use the MFP serial ports ("Modem1", "Serial1") under
-	  Linux, say Y. The driver equally supports all kinds of MFP serial
-	  ports and automatically detects whether Serial1 is available.
-
-	  To compile this driver as a module, choose M here.
-
-	  Note for Falcon users: You also have an MFP port, it's just not
-	  wired to the outside... But you could use the port under Linux.
-
-config ATARI_MIDI
-	tristate "Atari MIDI serial support"
-	depends on ATARI
-	help
-	  If you want to use your Atari's MIDI port in Linux, say Y.
-
-	  To compile this driver as a module, choose M here.
-
 config ATARI_DSP56K
 	tristate "Atari DSP56k support (EXPERIMENTAL)"
 	depends on ATARI && EXPERIMENTAL
@@ -99,15 +78,6 @@ config AMIGA_BUILTIN_SERIAL
 
 	  To compile this driver as a module, choose M here.
 
-config MULTIFACE_III_TTY
-	tristate "Multiface Card III serial support"
-	depends on AMIGA
-	help
-	  If you want to use a Multiface III card's serial port in Linux,
-	  answer Y.
-
-	  To compile this driver as a module, choose M here.
-
 config HPDCA
 	tristate "HP DCA serial support"
 	depends on DIO && SERIAL_8250
@@ -122,13 +92,9 @@ config HPAPCI
 	  If you want to use the internal "APCI" serial ports on an HP400
 	  machine, say Y here.
 
-config DN_SERIAL
-	bool "Support for DN serial port (dummy)"
-	depends on APOLLO
-
 config SERIAL_CONSOLE
 	bool "Support for serial port console"
-	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || MULTIFACE_III_TTY=y || SERIAL=y || DN_SERIAL)
+	depends on AMIGA_BUILTIN_SERIAL=y
 	---help---
 	  If you say Y here, it will be possible to use a serial port as the
 	  system console (the system console is the device which receives all
@@ -140,10 +106,10 @@ config SERIAL_CONSOLE
 	  (/dev/tty0) will still be used as the system console by default, but
 	  you can alter that using a kernel command line option such as
 	  "console=ttyS1". (Try "man bootparam" or see the documentation of
-	  your boot loader (lilo or loadlin) about how to pass options to the
-	  kernel at boot time.)
+	  your boot loader about how to pass options to the kernel at boot
+	  time.)
 
-	  If you don't have a VGA card installed and you say Y here, the
+	  If you don't have a graphical console and you say Y here, the
 	  kernel will automatically use the first serial line, /dev/ttyS0, as
 	  system console.
 
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index dbb49fc..e93fdae 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -255,7 +255,6 @@ CONFIG_HID=m
 CONFIG_HIDRAW=y
 # CONFIG_USB_SUPPORT is not set
 CONFIG_AMIGA_BUILTIN_SERIAL=y
-CONFIG_MULTIFACE_III_TTY=m
 CONFIG_SERIAL_CONSOLE=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 562b221..66b26c1 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -223,8 +223,6 @@ CONFIG_LOGO=y
 CONFIG_HID=m
 CONFIG_HIDRAW=y
 # CONFIG_USB_SUPPORT is not set
-CONFIG_DN_SERIAL=y
-CONFIG_SERIAL_CONSOLE=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index cc8a08a..6e86de1 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -242,10 +242,7 @@ CONFIG_DMASOUND_ATARI=m
 CONFIG_HID=m
 CONFIG_HIDRAW=y
 # CONFIG_USB_SUPPORT is not set
-CONFIG_ATARI_MFPSER=y
-CONFIG_ATARI_MIDI=y
 CONFIG_ATARI_DSP56K=m
-CONFIG_SERIAL_CONSOLE=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index 116e2ec..46185b7 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -325,12 +325,8 @@ CONFIG_DMASOUND_Q40=m
 CONFIG_HID=m
 CONFIG_HIDRAW=y
 # CONFIG_USB_SUPPORT is not set
-CONFIG_ATARI_MFPSER=y
-CONFIG_ATARI_MIDI=y
 CONFIG_ATARI_DSP56K=m
 CONFIG_AMIGA_BUILTIN_SERIAL=y
-CONFIG_MULTIFACE_III_TTY=m
-CONFIG_DN_SERIAL=y
 CONFIG_SERIAL_CONSOLE=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 6dd12e6..cdb70d6 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -218,7 +218,6 @@ CONFIG_GEN_RTC_X=y
 CONFIG_HID=m
 CONFIG_HIDRAW=y
 # CONFIG_USB_SUPPORT is not set
-CONFIG_SERIAL_CONSOLE=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
-- 
1.7.0.4

