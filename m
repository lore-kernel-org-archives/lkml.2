Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0IMKHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:07:47 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:35423 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab0IMKHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:07:45 -0400
Date: Mon, 13 Sep 2010 12:07:19 +0200
From: =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andres Salomon <dilinger@queued.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Thibault <Samuel.Thibault@ens-lyon.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100913100719.GA3903@pema>
References: <20100825094925.GA3632@pema>
 <alpine.LFD.2.00.1008261406480.2062@localhost.localdomain>
 <20100826210815.GA18131@pema>
 <4C76D9A0.2010907@zytor.com>
 <20100829205929.GA3309@pema>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100829205929.GA3309@pema>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

This thread has been sleeping for a few days now so I'm trying to wake
it up.

Brief summary: the included patch provides an iris module with a power
off function for a machine that, as has already been seen, has no APM,
no ACPI and no DMI.

The output of lspci -vv -n is included again.

Thanks for your attention,
Shérab.

00:00.0 0600: 1078:0001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:02.0 0200: 1282:9102 (rev 40)
	Subsystem: 0291:8212
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 165 (5000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 1000 [size=256]
	Region 1: Memory at fedfe000 (32-bit, non-prefetchable) [size=256]
	[virtual] Expansion ROM at 08000000 [disabled] [size=256K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=160mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: dmfe

00:12.0 0601: 1078:0100 (rev 30)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 16 bytes

00:12.1 0680: 1078:0101
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at 40012000 (32-bit, non-prefetchable) [size=256]

00:12.2 0101: 1078:0102 (prog-if 80 [Master])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at 1400 [size=16]
	Kernel driver in use: CS5530 IDE

00:12.3 0401: 1078:0103
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at 40011000 (32-bit, non-prefetchable) [size=128]
	Kernel driver in use: CS5530_Audio

00:12.4 0300: 1078:0104 (prog-if 00 [VGA controller])
	Subsystem: 1078:0001
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Region 0: Memory at 40800000 (32-bit, non-prefetchable) [size=8M]
	Expansion ROM at <unassigned> [disabled]

00:13.0 0c03: 0e11:a0f8 (rev 06) (prog-if 10 [OHCI])
	Subsystem: 0e11:a0f8
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (20000ns max)
	Interrupt: pin A routed to IRQ 9
	Region 0: Memory at fedff000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

>From 197e523553a791f97536143001f22abd36f7992c Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Sh=C3=A9rab?= <Sebastien.Hinderer@ens-lyon.org>
Date: Wed, 25 Aug 2010 23:00:14 +0200
Subject: [PATCH] Eurobraille/Iris power off.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"

The Iris machines from EuroBraille do not have APM or ACPI support
to shut themselves down properly.  A special I/O sequence is
needed to do so.  This modle runs this I/O sequence at
kernel shutdown.

This is only for Iris machines from EuroBraille.
Signed-off-by: Shérab <Sebastien.Hinderer@ens-lyon.org>
---
 arch/x86/Kconfig         |   13 +++++++
 arch/x86/kernel/Makefile |    1 +
 arch/x86/kernel/iris.c   |   80 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kernel/iris.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ac7827f..88bf897 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -493,6 +493,19 @@ config X86_ES7000
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
 
+config X86_32_IRIS
+	tristate "Eurobraille/Iris poweroff module"
+	depends on X86_32
+	---help---
+	  The Iris machines from EuroBraille do not have APM or ACPI support
+	  to shut themselves down properly.  A special I/O sequence is
+	  needed to do so, which is what this module does at
+	  kernel shutdown.
+
+	  This is only for Iris machines from EuroBraille.
+
+	  If unused, say N.
+
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..98dd1c8 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -115,6 +115,7 @@ obj-$(CONFIG_MICROCODE)			+= microcode.o
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
 
 obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb.o
+obj-$(CONFIG_X86_32_IRIS)		+= iris.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/iris.c b/arch/x86/kernel/iris.c
new file mode 100644
index 0000000..8856ef3
--- /dev/null
+++ b/arch/x86/kernel/iris.c
@@ -0,0 +1,80 @@
+/*
+ * Eurobraille/Iris power off support.
+ *
+ * Eurobraille's Iris machine is a PC with no APM or ACPI support.
+ * It is shutdown by a special I/O sequence which this module provides.
+ *
+ *  Copyright (C) Shérab <Sebastien.Hinderer@ens-lyon.org>
+ *
+ * This program is free software ; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation ; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY ; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with the program ; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/pm.h>
+#include <linux/delay.h>
+#include <asm/io.h>
+
+#define IRIS_GIO_BASE 0x340
+#define IRIS_GIO_INPUT IRIS_GIO_BASE
+#define IRIS_GIO_OUTPUT (IRIS_GIO_BASE + 1)
+#define IRIS_GIO_PULSE 0x80 /* First byte to send */
+#define IRIS_GIO_REST 0x0 /* Second byte to send */
+#define IRIS_GIO_NODEV 0xff /* Likely not an Iris */
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sébastien Hinderer <Sebastien.Hinderer@ens-lyon.org>");
+MODULE_DESCRIPTION("A power_off handler for Iris devices from EuroBraille");
+MODULE_SUPPORTED_DEVICE("Eurobraille/Iris");
+
+static void (*old_pm_power_off)(void);
+
+static void iris_power_off(void)
+{
+	outb(IRIS_GIO_PULSE, IRIS_GIO_OUTPUT);
+	msleep(850);
+	outb(IRIS_GIO_REST, IRIS_GIO_OUTPUT);
+}
+
+/*
+ * Before installing the power_off handler, try to make sure the OS is
+ * running on an Iris.  Since Iris does not support DMI, this is done
+ * by reading its input port and seeing whether the read value is
+ * meaningful.
+ */
+static int iris_init(void)
+{
+	unsigned char status = inb(IRIS_GIO_INPUT);
+	if (status == IRIS_GIO_NODEV) {
+		printk(KERN_ERR "This machine does not seem to be an Iris. Power_off handler not installed.\n");
+		return -ENODEV;
+	}
+	old_pm_power_off = pm_power_off;
+	pm_power_off = &iris_power_off;
+	printk(KERN_INFO "Iris power_off handler installed.\n");
+	return 0;
+}
+
+static void iris_exit(void)
+{
+	pm_power_off = old_pm_power_off;
+	printk(KERN_INFO "Iris power_off handler uninstalled.\n");
+}
+
+module_init(iris_init);
+module_exit(iris_exit);
+
-- 
1.7.1

