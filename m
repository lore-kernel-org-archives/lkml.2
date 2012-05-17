Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967399Ab2EQQlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:41:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:40129 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967339Ab2EQQlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:41:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: JBottomley@parallels.com, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Subject: [PATCH 3/5] serial: delete the MCA specific 8250 support.
Date: Thu, 17 May 2012 12:40:39 -0400
Message-Id: <1337272841-25931-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The support for CONFIG_MCA is being removed, since the 20
year old hardware simply isn't capable of meeting today's
software demands on CPU and memory resources.

This commit removes the MCA specific 8250 UART code.

Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/serial/stallion.txt  |   22 ++++++------
 drivers/tty/serial/8250/8250_mca.c |   61 ------------------------------------
 drivers/tty/serial/8250/Kconfig    |    9 -----
 drivers/tty/serial/8250/Makefile   |    1 -
 include/linux/serial.h             |    2 -
 include/linux/serial_8250.h        |    1 -
 6 files changed, 11 insertions(+), 85 deletions(-)
 delete mode 100644 drivers/tty/serial/8250/8250_mca.c

diff --git a/Documentation/serial/stallion.txt b/Documentation/serial/stallion.txt
index 5509091..4d798c0 100644
--- a/Documentation/serial/stallion.txt
+++ b/Documentation/serial/stallion.txt
@@ -20,10 +20,10 @@ There are two drivers that work with the different families of Stallion
 multiport serial boards. One is for the Stallion smart boards - that is
 EasyIO, EasyConnection 8/32 and EasyConnection 8/64-PCI, the other for
 the true Stallion intelligent multiport boards - EasyConnection 8/64
-(ISA, EISA, MCA), EasyConnection/RA-PCI, ONboard and Brumby.
+(ISA, EISA), EasyConnection/RA-PCI, ONboard and Brumby.
 
 If you are using any of the Stallion intelligent multiport boards (Brumby,
-ONboard, EasyConnection 8/64 (ISA, EISA, MCA), EasyConnection/RA-PCI) with
+ONboard, EasyConnection 8/64 (ISA, EISA), EasyConnection/RA-PCI) with
 Linux you will need to get the driver utility package.  This contains a
 firmware loader and the firmware images necessary to make the devices operate.
 
@@ -40,7 +40,7 @@ If you are using the EasyIO, EasyConnection 8/32 or EasyConnection 8/64-PCI
 boards then you don't need this package, although it does have a serial stats
 display program.
 
-If you require DIP switch settings, EISA or MCA configuration files, or any
+If you require DIP switch settings, or EISA configuration files, or any
 other information related to Stallion boards then have a look at Stallion's
 web pages at http://www.stallion.com.
 
@@ -51,13 +51,13 @@ web pages at http://www.stallion.com.
 The drivers can be used as loadable modules or compiled into the kernel.
 You can choose which when doing a "config" on the kernel.
 
-All ISA, EISA and MCA boards that you want to use need to be configured into
+All ISA, and EISA boards that you want to use need to be configured into
 the driver(s). All PCI boards will be automatically detected when you load
 the driver - so they do not need to be entered into the driver(s)
 configuration structure. Note that kernel PCI support is required to use PCI
 boards.
 
-There are two methods of configuring ISA, EISA and MCA boards into the drivers.
+There are two methods of configuring ISA and EISA boards into the drivers.
 If using the driver as a loadable module then the simplest method is to pass
 the driver configuration as module arguments. The other method is to modify
 the driver source to add configuration lines for each board in use.
@@ -71,12 +71,12 @@ That makes things pretty simple to get going.
 2.1 MODULE DRIVER CONFIGURATION:
 
 The simplest configuration for modules is to use the module load arguments
-to configure any ISA, EISA or MCA boards. PCI boards are automatically
+to configure any ISA or EISA boards. PCI boards are automatically
 detected, so do not need any additional configuration at all.
 
-If using EasyIO, EasyConnection 8/32 ISA or MCA, or EasyConnection 8/63-PCI
+If using EasyIO, EasyConnection 8/32 ISA, or EasyConnection 8/63-PCI
 boards then use the "stallion" driver module, Otherwise if you are using
-an EasyConnection 8/64 ISA, EISA or MCA, EasyConnection/RA-PCI, ONboard,
+an EasyConnection 8/64 ISA or EISA, EasyConnection/RA-PCI, ONboard,
 Brumby or original Stallion board then use the "istallion" driver module.
 
 Typically to load up the smart board driver use:
@@ -146,7 +146,7 @@ on each system boot. Typically configuration files are put in the
 2.2 STATIC DRIVER CONFIGURATION:
 
 For static driver configuration you need to modify the driver source code.
-Entering ISA, EISA and MCA boards into the driver(s) configuration structure
+Entering ISA and EISA boards into the driver(s) configuration structure
 involves editing the driver(s) source file. It's pretty easy if you follow
 the instructions below. Both drivers can support up to 4 boards. The smart
 card driver (the stallion.c driver) supports any combination of EasyIO and
@@ -157,7 +157,7 @@ supports any combination of ONboards, Brumbys, Stallions and EasyConnection
 To set up the driver(s) for the boards that you want to use you need to
 edit the appropriate driver file and add configuration entries.
 
-If using EasyIO or EasyConnection 8/32 ISA or MCA boards,
+If using EasyIO or EasyConnection 8/32 ISA boards,
    In drivers/char/stallion.c:
       - find the definition of the stl_brdconf array (of structures)
         near the top of the file
@@ -243,7 +243,7 @@ change it on the board.
 On EasyIO and EasyConnection 8/32 boards the IRQ is software programmable, so
 if there is a conflict you may need to change the IRQ used for a board. There
 are no interrupts to worry about for ONboard, Brumby or EasyConnection 8/64
-(ISA, EISA and MCA) boards. The memory region on EasyConnection 8/64 and
+(ISA and EISA) boards. The memory region on EasyConnection 8/64 and
 ONboard boards is software programmable, but not on the Brumby boards.
 
 
diff --git a/drivers/tty/serial/8250/8250_mca.c b/drivers/tty/serial/8250/8250_mca.c
deleted file mode 100644
index d20abf0..0000000
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 591f801..175c204 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -241,15 +241,6 @@ config SERIAL_8250_RSA
 	help
 	  ::: To be written :::
 
-config SERIAL_8250_MCA
-	tristate "Support 8250-type ports on MCA buses"
-	depends on SERIAL_8250 != n && MCA
-	help
-	  Say Y here if you have a MCA serial ports.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called 8250_mca.
-
 config SERIAL_8250_ACORN
 	tristate "Acorn expansion card serial port support"
 	depends on ARCH_ACORN && SERIAL_8250
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
index 867bba7..464320f 100644
--- a/drivers/tty/serial/8250/Makefile
+++ b/drivers/tty/serial/8250/Makefile
@@ -15,6 +15,5 @@ obj-$(CONFIG_SERIAL_8250_ACCENT)	+= 8250_accent.o
 obj-$(CONFIG_SERIAL_8250_BOCA)		+= 8250_boca.o
 obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554)	+= 8250_exar_st16c554.o
 obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
-obj-$(CONFIG_SERIAL_8250_MCA)		+= 8250_mca.o
 obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
 obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
diff --git a/include/linux/serial.h b/include/linux/serial.h
index 441980e..90e9f98 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -130,7 +130,6 @@ struct serial_uart_config {
 #define ASYNCB_CHECK_CD		25 /* i.e., CLOCAL */
 #define ASYNCB_SHARE_IRQ	24 /* for multifunction cards, no longer used */
 #define ASYNCB_CONS_FLOW	23 /* flow control for console  */
-#define ASYNCB_BOOT_ONLYMCA	22 /* Probe only if MCA bus */
 #define ASYNCB_FIRST_KERNEL	22
 
 #define ASYNC_HUP_NOTIFY	(1U << ASYNCB_HUP_NOTIFY)
@@ -166,7 +165,6 @@ struct serial_uart_config {
 #define ASYNC_CHECK_CD		(1U << ASYNCB_CHECK_CD)
 #define ASYNC_SHARE_IRQ		(1U << ASYNCB_SHARE_IRQ)
 #define ASYNC_CONS_FLOW		(1U << ASYNCB_CONS_FLOW)
-#define ASYNC_BOOT_ONLYMCA	(1U << ASYNCB_BOOT_ONLYMCA)
 #define ASYNC_INTERNAL_FLAGS	(~((1U << ASYNCB_FIRST_KERNEL) - 1))
 
 /*
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 8f012f8..6c5047d 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -54,7 +54,6 @@ enum {
 	PLAT8250_DEV_BOCA,
 	PLAT8250_DEV_EXAR_ST16C554,
 	PLAT8250_DEV_HUB6,
-	PLAT8250_DEV_MCA,
 	PLAT8250_DEV_AU1X00,
 	PLAT8250_DEV_SM501,
 };
-- 
1.7.9.1

