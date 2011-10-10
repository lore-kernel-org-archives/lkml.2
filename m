Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab1JJS6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:58:50 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:41646 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752509Ab1JJS6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:58:48 -0400
Message-ID: <4E934066.80109@xenotime.net>
Date: Mon, 10 Oct 2011 11:58:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Johann Felix Soden <johfel@gmx.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix file references in the whole tree
References: <1317683499.5990.2.camel@LAPJFS>
In-Reply-To: <1317683499.5990.2.camel@LAPJFS>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>
Subject: [PATCH] Fix file references in the whole tree

There are a lot of file references to now moved or deleted files in the
whole tree, especially in documentation and Kconfig files. This patch
fixes many of them.

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---

Jiri, please merge.  I'll go thru the other changes separately.

 Documentation/filesystems/locks.txt                 |   11 +++++----
 Documentation/filesystems/nfs/idmapper.txt          |    2 -
 Documentation/filesystems/pohmelfs/design_notes.txt |    5 ++--
 Documentation/input/input.txt                       |    2 -
 Documentation/kernel-parameters.txt                 |    8 +++---
 Documentation/laptops/00-INDEX                      |    2 -
 Documentation/laptops/thinkpad-acpi.txt             |    6 ++---
 Documentation/timers/highres.txt                    |    2 -
 arch/arm/Kconfig                                    |    2 -
 arch/cris/Kconfig                                   |    4 +--
 arch/cris/arch-v10/Kconfig                          |   12 +++++-----
 arch/m68k/q40/README                                |    2 -
 arch/mn10300/Kconfig                                |    2 -
 arch/powerpc/include/asm/qe.h                       |    2 -
 arch/powerpc/sysdev/qe_lib/qe.c                     |    2 -
 arch/x86/Kconfig                                    |    2 -
 arch/x86/Kconfig.debug                              |    2 -
 arch/x86/boot/header.S                              |    2 -
 arch/x86/kernel/pci-dma.c                           |    4 +--
 drivers/leds/Kconfig                                |    2 -
 drivers/net/Kconfig                                 |    5 +---
 drivers/net/irda/Kconfig                            |    2 -
 drivers/platform/x86/Kconfig                        |    3 --
 drivers/staging/cxt1e1/Kconfig                      |    2 -
 fs/squashfs/Kconfig                                 |    6 ++---
 net/netfilter/Kconfig                               |    2 -
 sound/oss/Kconfig                                   |    4 ---
 27 files changed, 47 insertions(+), 53 deletions(-)
---

--- lnx-31-rc9.orig/Documentation/filesystems/locks.txt
+++ lnx-31-rc9/Documentation/filesystems/locks.txt
@@ -53,11 +53,12 @@ fcntl(), with all the problems that impl
 1.3 Mandatory Locking As A Mount Option
 ---------------------------------------
 
-Mandatory locking, as described in 'Documentation/filesystems/mandatory.txt'
-was prior to this release a general configuration option that was valid for
-all mounted filesystems.  This had a number of inherent dangers, not the
-least of which was the ability to freeze an NFS server by asking it to read
-a file for which a mandatory lock existed.
+Mandatory locking, as described in
+'Documentation/filesystems/mandatory-locking.txt' was prior to this release a
+general configuration option that was valid for all mounted filesystems.  This
+had a number of inherent dangers, not the least of which was the ability to
+freeze an NFS server by asking it to read a file for which a mandatory lock
+existed.
 
 From this release of the kernel, mandatory locking can be turned on and off
 on a per-filesystem basis, using the mount options 'mand' and 'nomand'.
--- lnx-31-rc9.orig/Documentation/filesystems/nfs/idmapper.txt
+++ lnx-31-rc9/Documentation/filesystems/nfs/idmapper.txt
@@ -47,7 +47,7 @@ request-key will find the first matching
 this case, /some/other/program will handle all uid lookups and
 /usr/sbin/nfs.idmap will handle gid, user, and group lookups.
 
-See <file:Documentation/security/keys-request-keys.txt> for more information
+See <file:Documentation/security/keys-request-key.txt> for more information
 about the request-key function.
 
 
--- lnx-31-rc9.orig/Documentation/filesystems/pohmelfs/design_notes.txt
+++ lnx-31-rc9/Documentation/filesystems/pohmelfs/design_notes.txt
@@ -58,8 +58,9 @@ data transfers.
 POHMELFS clients operate with a working set of servers and are capable of balancing read-only
 operations (like lookups or directory listings) between them according to IO priorities.
 Administrators can add or remove servers from the set at run-time via special commands (described
-in Documentation/pohmelfs/info.txt file). Writes are replicated to all servers, which are connected
-with write permission turned on. IO priority and permissions can be changed in run-time.
+in Documentation/filesystems/pohmelfs/info.txt file). Writes are replicated to all servers, which
+are connected with write permission turned on. IO priority and permissions can be changed in
+run-time.
 
 POHMELFS is capable of full data channel encryption and/or strong crypto hashing.
 One can select any kernel supported cipher, encryption mode, hash type and operation mode
--- lnx-31-rc9.orig/Documentation/input/input.txt
+++ lnx-31-rc9/Documentation/input/input.txt
@@ -111,7 +111,7 @@ LCDs and many other purposes.
 
  The monitor and speaker controls should be easy to add to the hid/input
 interface, but for the UPSs and LCDs it doesn't make much sense. For this,
-the hiddev interface was designed. See Documentation/usb/hiddev.txt
+the hiddev interface was designed. See Documentation/hid/hiddev.txt
 for more information about it.
 
   The usage of the usbhid module is very simple, it takes no parameters,
--- lnx-31-rc9.orig/Documentation/kernel-parameters.txt
+++ lnx-31-rc9/Documentation/kernel-parameters.txt
@@ -163,7 +163,7 @@ bytes respectively. Such letter suffixes
 			rsdt -- prefer RSDT over (default) XSDT
 			copy_dsdt -- copy DSDT to memory
 
-			See also Documentation/power/pm.txt, pci=noacpi
+			See also Documentation/power/apm-acpi.txt, pci=noacpi
 
 	acpi_rsdp=	[ACPI,EFI,KEXEC]
 			Pass the RSDP address to the kernel, mostly used
@@ -319,7 +319,7 @@ bytes respectively. Such letter suffixes
 	amijoy.map=	[HW,JOY] Amiga joystick support
 			Map of devices attached to JOY0DAT and JOY1DAT
 			Format: <a>,<b>
-			See also Documentation/kernel/input/joystick.txt
+			See also Documentation/input/joystick.txt
 
 	analog.map=	[HW,JOY] Analog joystick and gamepad support
 			Specifies type or capabilities of an analog joystick
@@ -724,8 +724,8 @@ bytes respectively. Such letter suffixes
 
 	elevator=	[IOSCHED]
 			Format: {"cfq" | "deadline" | "noop"}
-			See Documentation/block/as-iosched.txt and
-			Documentation/block/deadline-iosched.txt for details.
+			See Documentation/block/deadline-iosched.txt for
+			details.
 
 	elfcorehdr=	[IA-64,PPC,SH,X86]
 			Specifies physical address of start of kernel core
--- lnx-31-rc9.orig/Documentation/laptops/00-INDEX
+++ lnx-31-rc9/Documentation/laptops/00-INDEX
@@ -1,7 +1,5 @@
 00-INDEX
 	- This file
-acer-wmi.txt
-	- information on the Acer Laptop WMI Extras driver.
 asus-laptop.txt
 	- information on the Asus Laptop Extras driver.
 disk-shock-protection.txt
--- lnx-31-rc9.orig/Documentation/laptops/thinkpad-acpi.txt
+++ lnx-31-rc9/Documentation/laptops/thinkpad-acpi.txt
@@ -736,8 +736,8 @@ status as "unknown". The available comma
 sysfs notes:
 
 The ThinkLight sysfs interface is documented by the LED class
-documentation, in Documentation/leds-class.txt.  The ThinkLight LED name
-is "tpacpi::thinklight".
+documentation, in Documentation/leds/leds-class.txt.  The ThinkLight LED
+name is "tpacpi::thinklight".
 
 Due to limitations in the sysfs LED class, if the status of the ThinkLight
 cannot be read or if it is unknown, thinkpad-acpi will report it as "off".
@@ -833,7 +833,7 @@ All of the above can be turned on and of
 sysfs notes:
 
 The ThinkPad LED sysfs interface is described in detail by the LED class
-documentation, in Documentation/leds-class.txt.
+documentation, in Documentation/leds/leds-class.txt.
 
 The LEDs are named (in LED ID order, from 0 to 12):
 "tpacpi::power", "tpacpi:orange:batt", "tpacpi:green:batt",
--- lnx-31-rc9.orig/Documentation/timers/highres.txt
+++ lnx-31-rc9/Documentation/timers/highres.txt
@@ -30,7 +30,7 @@ hrtimer base infrastructure
 ---------------------------
 
 The hrtimer base infrastructure was merged into the 2.6.16 kernel. Details of
-the base implementation are covered in Documentation/hrtimers/hrtimer.txt. See
+the base implementation are covered in Documentation/timers/hrtimers.txt. See
 also figure #2 (OLS slides p. 15)
 
 The main differences to the timer wheel, which holds the armed timer_list type
--- lnx-31-rc9.orig/arch/arm/Kconfig
+++ lnx-31-rc9/arch/arm/Kconfig
@@ -1388,7 +1388,7 @@ config SMP
 	  processor machines. On a single processor machine, the kernel will
 	  run faster if you say N here.
 
-	  See also <file:Documentation/i386/IO-APIC.txt>,
+	  See also <file:Documentation/x86/i386/IO-APIC.txt>,
 	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
 	  <http://tldp.org/HOWTO/SMP-HOWTO.html>.
 
--- lnx-31-rc9.orig/arch/cris/Kconfig
+++ lnx-31-rc9/arch/cris/Kconfig
@@ -282,8 +282,8 @@ config ETRAX_RTC
 	  Enables drivers for the Real-Time Clock battery-backed chips on
 	  some products. The kernel reads the time when booting, and
 	  the date can be set using ioctl(fd, RTC_SET_TIME, &rt) with rt a
-	  rtc_time struct (see <file:include/asm-cris/rtc.h>) on the /dev/rtc
-	  device.  You can check the time with cat /proc/rtc, but
+	  rtc_time struct (see <file:arch/cris/include/asm/rtc.h>) on the
+	  /dev/rtc device.  You can check the time with cat /proc/rtc, but
 	  normal time reading should be done using libc function time and
 	  friends.
 
--- lnx-31-rc9.orig/arch/cris/arch-v10/Kconfig
+++ lnx-31-rc9/arch/cris/arch-v10/Kconfig
@@ -24,8 +24,8 @@ config ETRAX_PA_LEDS
 	help
 	  The ETRAX network driver is responsible for flashing LED's when
 	  packets arrive and are sent.  It uses macros defined in
-	  <file:include/asm-cris/io.h>, and those macros are defined after what
-	  YOU choose in this option.  The actual bits used are configured
+	  <file:arch/cris/include/asm/io.h>, and those macros are defined after
+	  what YOU choose in this option.  The actual bits used are configured
 	  separately.  Select this if the LEDs are on port PA.  Some products
 	  put the leds on PB or a memory-mapped latch (CSP0) instead.
 
@@ -34,8 +34,8 @@ config ETRAX_PB_LEDS
 	help
 	  The ETRAX network driver is responsible for flashing LED's when
 	  packets arrive and are sent.  It uses macros defined in
-	  <file:include/asm-cris/io.h>, and those macros are defined after what
-	  YOU choose in this option.  The actual bits used are configured
+	  <file:arch/cris/include/asm/io.h>, and those macros are defined after
+	  what YOU choose in this option.  The actual bits used are configured
 	  separately.  Select this if the LEDs are on port PB.  Some products
 	  put the leds on PA or a memory-mapped latch (CSP0) instead.
 
@@ -44,8 +44,8 @@ config ETRAX_CSP0_LEDS
 	help
 	  The ETRAX network driver is responsible for flashing LED's when
 	  packets arrive and are sent. It uses macros defined in
-	  <file:include/asm-cris/io.h>, and those macros are defined after what
-	  YOU choose in this option.  The actual bits used are configured
+	  <file:arch/cris/include/asm/io.h>, and those macros are defined after
+	  what YOU choose in this option.  The actual bits used are configured
 	  separately.  Select this if the LEDs are on a memory-mapped latch
 	  using chip select CSP0, this is mapped at 0x90000000.
 	  Some products put the leds on PA or PB instead.
--- lnx-31-rc9.orig/arch/m68k/q40/README
+++ lnx-31-rc9/arch/m68k/q40/README
@@ -31,7 +31,7 @@ drivers used by the Q40, apart from the
 		char/joystick/*		# most of this should work, not
 				        # in default config.in
 	        block/q40ide.c		# startup for ide
-		      ide*		# see Documentation/ide.txt
+		      ide*		# see Documentation/ide/ide.txt
 		      floppy.c		# normal PC driver, DMA emu in asm/floppy.h
 					# and arch/m68k/kernel/entry.S
 					# see drivers/block/README.fd
--- lnx-31-rc9.orig/arch/mn10300/Kconfig
+++ lnx-31-rc9/arch/mn10300/Kconfig
@@ -195,7 +195,7 @@ config SMP
 	  singleprocessor machines. On a singleprocessor machine, the kernel
 	  will run faster if you say N here.
 
-	  See also <file:Documentation/i386/IO-APIC.txt>,
+	  See also <file:Documentation/x86/i386/IO-APIC.txt>,
 	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
 	  <http://www.tldp.org/docs.html#howto>.
 
--- lnx-31-rc9.orig/arch/powerpc/include/asm/qe.h
+++ lnx-31-rc9/arch/powerpc/include/asm/qe.h
@@ -196,7 +196,7 @@ static inline int qe_alive_during_sleep(
 
 /* Structure that defines QE firmware binary files.
  *
- * See Documentation/powerpc/qe-firmware.txt for a description of these
+ * See Documentation/powerpc/qe_firmware.txt for a description of these
  * fields.
  */
 struct qe_firmware {
--- lnx-31-rc9.orig/arch/powerpc/sysdev/qe_lib/qe.c
+++ lnx-31-rc9/arch/powerpc/sysdev/qe_lib/qe.c
@@ -382,7 +382,7 @@ static void qe_upload_microcode(const vo
 /*
  * Upload a microcode to the I-RAM at a specific address.
  *
- * See Documentation/powerpc/qe-firmware.txt for information on QE microcode
+ * See Documentation/powerpc/qe_firmware.txt for information on QE microcode
  * uploading.
  *
  * Currently, only version 1 is supported, so the 'version' field must be
--- lnx-31-rc9.orig/arch/x86/Kconfig
+++ lnx-31-rc9/arch/x86/Kconfig
@@ -279,7 +279,7 @@ config SMP
 	  Y to "Enhanced Real Time Clock Support", below. The "Advanced Power
 	  Management" code will be disabled if you say Y here.
 
-	  See also <file:Documentation/i386/IO-APIC.txt>,
+	  See also <file:Documentation/x86/i386/IO-APIC.txt>,
 	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
 	  <http://www.tldp.org/docs.html#howto>.
 
--- lnx-31-rc9.orig/arch/x86/Kconfig.debug
+++ lnx-31-rc9/arch/x86/Kconfig.debug
@@ -139,7 +139,7 @@ config IOMMU_DEBUG
 	  code. When you use it make sure you have a big enough
 	  IOMMU/AGP aperture.  Most of the options enabled by this can
 	  be set more finegrained using the iommu= command line
-	  options. See Documentation/x86_64/boot-options.txt for more
+	  options. See Documentation/x86/x86_64/boot-options.txt for more
 	  details.
 
 config IOMMU_STRESS
--- lnx-31-rc9.orig/arch/x86/boot/header.S
+++ lnx-31-rc9/arch/x86/boot/header.S
@@ -129,7 +129,7 @@ start_sys_seg:	.word	SYSSEG		# obsolete
 
 type_of_loader:	.byte	0		# 0 means ancient bootloader, newer
 					# bootloaders know to change this.
-					# See Documentation/i386/boot.txt for
+					# See Documentation/x86/boot.txt for
 					# assigned ids
 
 # flags, unused bits must be zero (RFU) bit within loadflags
--- lnx-31-rc9.orig/arch/x86/kernel/pci-dma.c
+++ lnx-31-rc9/arch/x86/kernel/pci-dma.c
@@ -117,8 +117,8 @@ again:
 }
 
 /*
- * See <Documentation/x86_64/boot-options.txt> for the iommu kernel parameter
- * documentation.
+ * See <Documentation/x86/x86_64/boot-options.txt> for the iommu kernel
+ * parameter documentation.
  */
 static __init int iommu_setup(char *p)
 {
--- lnx-31-rc9.orig/drivers/leds/Kconfig
+++ lnx-31-rc9/drivers/leds/Kconfig
@@ -400,7 +400,7 @@ config LEDS_TRIGGER_TIMER
 	  This allows LEDs to be controlled by a programmable timer
 	  via sysfs. Some LED hardware can be programmed to start
 	  blinking the LED without any further software interaction.
-	  For more details read Documentation/leds-class.txt.
+	  For more details read Documentation/leds/leds-class.txt.
 
 	  If unsure, say Y.
 
--- lnx-31-rc9.orig/drivers/net/Kconfig
+++ lnx-31-rc9/drivers/net/Kconfig
@@ -1063,9 +1063,8 @@ config SMSC911X
 	  Say Y here if you want support for SMSC LAN911x and LAN921x families
 	  of ethernet controllers.
 
-	  To compile this driver as a module, choose M here and read
-	  <file:Documentation/networking/net-modules.txt>. The module
-	  will be called smsc911x.
+	  To compile this driver as a module, choose M here.
+	  The module will be called smsc911x.
 
 config SMSC911X_ARCH_HOOKS
 	def_bool n
--- lnx-31-rc9.orig/drivers/net/irda/Kconfig
+++ lnx-31-rc9/drivers/net/irda/Kconfig
@@ -183,7 +183,7 @@ config OLD_BELKIN_DONGLE
 	  Say Y here if you want to build support for the Adaptec Airport 1000
 	  and 2000 dongles.  If you want to compile it as a module, choose
 	  M here. Some information is contained in the comments
-	  at the top of <file:drivers/net/irda/old_belkin.c>.
+	  at the top of <file:drivers/net/irda/old_belkin-sir.c>.
 
 config ACT200L_DONGLE
 	tristate "ACTiSYS IR-200L dongle"
--- lnx-31-rc9.orig/drivers/platform/x86/Kconfig
+++ lnx-31-rc9/drivers/platform/x86/Kconfig
@@ -31,9 +31,6 @@ config ACER_WMI
 	  wireless radio and bluetooth control, and on some laptops,
 	  exposes the mail LED and LCD backlight.
 
-	  For more information about this driver see
-	  <file:Documentation/laptops/acer-wmi.txt>
-
 	  If you have an ACPI-WMI compatible Acer/ Wistron laptop, say Y or M
 	  here.
 
--- lnx-31-rc9.orig/drivers/staging/cxt1e1/Kconfig
+++ lnx-31-rc9/drivers/staging/cxt1e1/Kconfig
@@ -7,7 +7,7 @@ config CXT1E1
       mode controller.
 
       If you want to compile this driver as a module
-      say M here and read <file:Documentation/modules.txt>.
+      say M here and read <file:Documentation/kbuild/modules.txt>.
       The module will be called 'cxt1e1'.
 
       If unsure, say N.
--- lnx-31-rc9.orig/fs/squashfs/Kconfig
+++ lnx-31-rc9/fs/squashfs/Kconfig
@@ -19,9 +19,9 @@ config SQUASHFS
 
 	  If you want to compile this as a module ( = code which can be
 	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/modules.txt>.  The module
-	  will be called squashfs.  Note that the root file system (the one
-	  containing the directory /) cannot be compiled as a module.
+	  say M here and read <file:Documentation/kbuild/modules.txt>.  The
+	  module will be called squashfs.  Note that the root file system (the
+	  one containing the directory /) cannot be compiled as a module.
 
 	  If unsure, say N.
 
--- lnx-31-rc9.orig/net/netfilter/Kconfig
+++ lnx-31-rc9/net/netfilter/Kconfig
@@ -505,7 +505,7 @@ config NETFILTER_XT_TARGET_LED
 	    echo netfilter-ssh > /sys/class/leds/<ledname>/trigger
 
 	  For more information on the LEDs available on your system, see
-	  Documentation/leds-class.txt
+	  Documentation/leds/leds-class.txt
 
 config NETFILTER_XT_TARGET_MARK
 	tristate '"MARK" target support'
--- lnx-31-rc9.orig/sound/oss/Kconfig
+++ lnx-31-rc9/sound/oss/Kconfig
@@ -432,9 +432,7 @@ config SOUND_SB
 	  ALS-007 and ALS-1X0 chips (read <file:Documentation/sound/oss/ALS>) and
 	  for cards based on ESS chips (read
 	  <file:Documentation/sound/oss/ESS1868> and
-	  <file:Documentation/sound/oss/ESS>). If you have an SB AWE 32 or SB AWE
-	  64, say Y here and also to "AWE32 synth" below and read
-	  <file:Documentation/sound/oss/INSTALL.awe>. If you have an IBM Mwave
+	  <file:Documentation/sound/oss/ESS>). If you have an IBM Mwave
 	  card, say Y here and read <file:Documentation/sound/oss/mwave>.
 
 	  If you compile the driver into the kernel and don't want to use
