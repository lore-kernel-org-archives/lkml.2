Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab1D2W2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:28:18 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:49368 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1D2W2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:28:15 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Apr 2011 18:28:14 EDT
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "To"
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Cc: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        platform-driver-x86@vger.kernel.org, linux-serial@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: [RFC 1/5] platform-drivers-x86: add support for Technologic Systems TS-5xxx detection
Date: Fri, 29 Apr 2011 18:21:48 -0400
Message-Id: <1304115712-5299-2-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>


Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 Documentation/ts5xxx-sbcinfo.txt      |   47 ++++++
 MAINTAINERS                           |    6 +
 drivers/platform/x86/Kconfig          |   11 ++
 drivers/platform/x86/Makefile         |    1 +
 drivers/platform/x86/ts5xxx-sbcinfo.c |  254 +++++++++++++++++++++++++++++++++
 include/linux/ts5xxx-sbcinfo.h        |   42 ++++++
 6 files changed, 361 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ts5xxx-sbcinfo.txt
 create mode 100644 drivers/platform/x86/ts5xxx-sbcinfo.c
 create mode 100644 include/linux/ts5xxx-sbcinfo.h

diff --git a/Documentation/ts5xxx-sbcinfo.txt b/Documentation/ts5xxx-sbcinfo.txt
new file mode 100644
index 0000000..54905b1
--- /dev/null
+++ b/Documentation/ts5xxx-sbcinfo.txt
@@ -0,0 +1,47 @@
+TS-5xxx boards detection
+========================
+
+Supported boards:
+  * Technologic Systems TS-3100
+    Manual: http://www.embeddedarm.com/documentation/ts-3100-manual.pdf
+
+  * Technologic Systems TS-3200
+    Manual: http://www.embeddedarm.com/documentation/ts-3200-manual.pdf
+
+  * Technologic Systems TS-3300
+    Manual: http://www.embeddedarm.com/documentation/ts-3300-manual.pdf
+
+  * Technologic Systems TS-3400
+    Manual: http://www.embeddedarm.com/documentation/ts-3400-manual.pdf
+
+  * Technologic Systems TS-5300
+    Manual: http://www.embeddedarm.com/documentation/ts-5300-manual.pdf
+
+  * Technologic Systems TS-5400
+    Manual: http://www.embeddedarm.com/documentation/ts-5400-manual.pdf
+
+  * Technologic Systems TS-5500
+    Manual: http://www.embeddedarm.com/documentation/ts-5500-manual.pdf
+
+  * Technologic Systems TS-5600
+    Manual: http://www.embeddedarm.com/documentation/ts-5600-manual.pdf
+
+  * Technologic Systems TS-5700
+    Manual: http://www.embeddedarm.com/documentation/ts-5700-manual.pdf
+
+Authors:
+    Liberty Young <liberty@embeddedx86.com>
+    Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
+    Alexandre Savard <alexandre.savard@savoirfairelinux.com>
+
+Description
+-----------
+
+The ts5xxx-sbcinfo driver provides detection for Technologic Systems TS-5xxx
+Single Board Computers. This driver also works with TS-3xxx boards.
+
+/proc filesystem
+----------------
+
+Information about the TS board is available through the /proc/ts-sbcinfo.
+
diff --git a/MAINTAINERS b/MAINTAINERS
index 1380312..b077e6d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6053,6 +6053,12 @@ W:	http://tcp-lp-mod.sourceforge.net/
 S:	Maintained
 F:	net/ipv4/tcp_lp.c
 
+TECHNOLOGIC SYSTEMS TS5500 MACHINE SUPPORT
+M:	Savoir-faire Linux Inc. <ts-kernel@savoirfairelinux.com>
+S:	Maintained
+F:	drivers/platform/x86/ts5xxx-sbcinfo.c
+F:	include/linux/ts5xxx-sbcinfo.h
+
 TEGRA SUPPORT
 M:	Colin Cross <ccross@android.com>
 M:	Erik Gilling <konkers@android.com>
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 0485e39..5c25da2 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -753,4 +753,15 @@ config SAMSUNG_LAPTOP
 	  To compile this driver as a module, choose M here: the module
 	  will be called samsung-laptop.
 
+config TS5500_SBC
+	tristate "Technologic Systems TS-5500 SBC support"
+	depends on X86_ELAN
+	---help---
+	  This enables support for the Technologic Systems TS-5500 platform.
+
+	  It  also gives access to specific device informations in the
+	  /proc/sbcinfo file.
+
+	  If you have a TS-5500, say Y here.
+
 endif # X86_PLATFORM_DEVICES
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 029e886..e47b449 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_XO15_EBOOK)	+= xo15-ebook.o
 obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
 obj-$(CONFIG_SAMSUNG_LAPTOP)	+= samsung-laptop.o
 obj-$(CONFIG_INTEL_MFLD_THERMAL)	+= intel_mid_thermal.o
+obj-$(CONFIG_TS5500_SBC)	+= ts5xxx-sbcinfo.o
diff --git a/drivers/platform/x86/ts5xxx-sbcinfo.c b/drivers/platform/x86/ts5xxx-sbcinfo.c
new file mode 100644
index 0000000..ea9501b
--- /dev/null
+++ b/drivers/platform/x86/ts5xxx-sbcinfo.c
@@ -0,0 +1,254 @@
+/*
+ * Technologic Systems TS-5xxx boards - SBC info layer
+ *
+ * Copyright (c) 2010 Savoir-faire Linux Inc.
+ *	Alexandre Savard <alexandre.savard@savoirfairelinux.com>
+ *	Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
+ *
+ * Portions originate from ts_sbcinfo.c (c) Technologic Systems
+ *	Liberty Young <liberty@embeddedx86.com>
+ *
+ * These functions add a proc ts-sbcinfo entry to display information
+ * about the Single Board Computer (SBC).
+ */
+
+#include <linux/module.h>
+#include <linux/ioport.h>
+#include <linux/proc_fs.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/io.h>
+
+#include <linux/ts5xxx-sbcinfo.h>
+
+#define PROCFS_NAME "ts-sbcinfo"
+
+#define PROCFS_MAX_SIZE 1024
+
+#define IOADDR_SBCID  0x74
+#define IOADDR_SRAM   0x75
+#define IOADDR_RESTOP 0x76
+#define IOADDR_LEDJP  0x77
+
+/* Structure containing the Single Board Computer's info */
+static struct ts5xxx_sbcinfo ts_sbcinfo;
+
+static struct proc_dir_entry *proc_entry;
+static char procfs_buffer[PROCFS_MAX_SIZE];
+static unsigned long procfs_buffer_size;
+
+/**
+ * ts5xxx_sbcinfo_set() - set the SBC info structure with the current SBC's info
+ * @sbcinfo:		structure containing SBC info to set.
+ */
+void ts5xxx_sbcinfo_set(struct ts5xxx_sbcinfo *sbcinfo)
+{
+	memcpy(sbcinfo, &ts_sbcinfo, sizeof(*sbcinfo));
+}
+EXPORT_SYMBOL(ts5xxx_sbcinfo_set);
+
+/**
+ * struct ts_sbc_config - TS SBC configuration
+ * @ref:		SBC's reference.
+ * @id:			ID read from the id register.
+ * @sram:		Bit to indicate the existence of SRAM.
+ * @adc:		Bit for analogic to digital converter.
+ * @rs485:		Bit for RS485.
+ * @auto485:		Bit for auto 485.
+ * @external_reset:	Bit for external reset feature.
+ * @jumpers:		Mask to list connected jumpers.
+ */
+struct ts_sbc_config {
+	int	ref;
+	u8	id;
+	u8	sram;
+	u8	adc;
+	u8	rs485;
+	u8	auto485;
+	u8	external_reset;
+	u8	jumpers;
+};
+
+#define NONE	0x00
+#define ALWAYS	0xFF
+
+/* TS SBCs configurations */
+struct ts_sbc_config ts_sbcs_configs[] = {
+	/* Ref	ID	SRAM	ADC	RS485	Auto485	E-Reset	Jprs */
+	{ 3100,	0x01,	NONE,	NONE,	NONE,	NONE,	NONE,	NONE },
+	{ 3200,	0x02,	0x01,	NONE,	NONE,	NONE,	NONE,	NONE },
+	{ 3300,	0x03,	0x01,	0x04,	NONE,	NONE,	NONE,	NONE },
+	{ 3400,	0x04,	0x01,	NONE,	NONE,	NONE,	0x01,	NONE },
+	{ 5300,	0x50,	0x01,	NONE,	0x02,	0x0A,	NONE,	0xFE },
+	{ 5400,	0x40,	NONE,	NONE,	0x02,	0x02,	NONE,	0xFE },
+	{ 5500,	0x60,	NONE,	0x04,	0x02,	0x02,	0x01,	0xFE },
+	{ 5600,	0x20,	0x01,	ALWAYS,	0x02,	0x02,	0x01,	0xFE },
+	{ 5700,	0x70,	NONE,	NONE,	0x02,	NONE,	ALWAYS,	0xFE },
+};
+
+/**
+ * ts_find_sbc_config() - find a SBC configuration from an id
+ * @id:			ID of the board to find.
+ */
+static inline struct ts_sbc_config *ts_find_sbc_config(u8 id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ts_sbcs_configs); i++)
+		if (id == ts_sbcs_configs[i].id)
+			return &ts_sbcs_configs[i];
+
+	return NULL;
+}
+
+/**
+ * ts_sbcfeature() - detect if a feature is enabled or not
+ * @info:		SBC's info structure to update.
+ * @sbc:		Configuration of the SBC.
+ * @reg:		Register containing the value.
+ * @feature:		Structure field to update.
+ */
+#define ts_sbcfeature(info, sbc, reg, feature) do {		\
+		(info)->feature = (sbc)->feature == ALWAYS ||	\
+				  !!((reg) & (sbc)->feature);	\
+	} while (0)
+
+/**
+ * ts_sbcinfo_detect() - detect the TS board
+ * @sbcinfo:		structure where to store the detected board's info.
+ */
+static int ts_sbcinfo_detect(struct ts5xxx_sbcinfo *sbcinfo)
+{
+	u8 temp;
+	struct ts_sbc_config *sbc;
+	int ret = 0;
+
+	memset(sbcinfo, 0, sizeof(*sbcinfo));
+
+	if (!request_region(IOADDR_SBCID, 4, "TS-SBC"))
+		return -EBUSY;
+
+	temp = inb(IOADDR_SBCID);
+	/* If it is a 3x00 SBC only match against the first 3 bits */
+	if (temp & 0x07)
+		temp &= 0x07;
+
+	sbc = ts_find_sbc_config(temp);
+	if (!sbc) {
+		ret = -ENODEV;
+		goto error;
+	}
+
+	sbcinfo->board_id = sbc->ref;
+
+	temp = inb(IOADDR_SRAM);
+	ts_sbcfeature(sbcinfo, sbc, temp, sram);
+	ts_sbcfeature(sbcinfo, sbc, temp, adc);
+	ts_sbcfeature(sbcinfo, sbc, temp, rs485);
+	ts_sbcfeature(sbcinfo, sbc, temp, auto485);
+
+	temp = inb(IOADDR_RESTOP);
+	sbcinfo->industrial = !!(temp & 0x02);
+	ts_sbcfeature(sbcinfo, sbc, temp, external_reset);
+
+	temp = inb(IOADDR_LEDJP);
+	sbcinfo->jumpers = temp & sbc->jumpers;
+
+error:
+	release_region(IOADDR_SBCID, 4);
+	return ret;
+}
+
+#define ts_addbuf(buf, name, fmt, a...) \
+	sprintf(buf, name ":%s" fmt "\n", \
+		&"                       "[sizeof(name) - 1], a)
+
+static int ts_sbcinfo_init_buffer(char *buf, struct ts5xxx_sbcinfo *sbcinfo)
+{
+	char *pos = buf;
+
+	pos += ts_addbuf(pos, "Board ID", "TS-%d", sbcinfo->board_id);
+	pos += ts_addbuf(pos, "RS485", "%s", sbcinfo->rs485 ? "yes" : "no");
+	pos += ts_addbuf(pos, "AnalogToDigital", "%s",
+			 sbcinfo->adc ? "yes" : "no");
+	pos += ts_addbuf(pos, "Auto485", "%s", sbcinfo->auto485 ? "yes" : "no");
+	pos += ts_addbuf(pos, "SRAM", "%s", sbcinfo->sram ? "yes" : "no");
+	pos += ts_addbuf(pos, "External Reset", "%s",
+			 sbcinfo->external_reset ? "yes" : "no");
+
+	if (sbcinfo->jumpers) {
+		pos += ts_addbuf(pos, "JPS", "%s%s%s%s%s%s",
+				 sbcinfo->jumpers & 0x02 ? "JP1 " : "",
+				 sbcinfo->jumpers & 0x04 ? "JP2 " : "",
+				 sbcinfo->jumpers & 0x08 ? "JP3 " : "",
+				 sbcinfo->jumpers & 0x10 ? "JP4 " : "",
+				 sbcinfo->jumpers & 0x20 ? "JP5 " : "",
+				 sbcinfo->jumpers & 0x80 ?
+				 (sbcinfo->board_id == 5300 ? "JP8" : "JP6")
+				 : "");
+	}
+
+	return pos - buf;
+}
+
+/**
+ * ts_sbcinfo_proc_read() - function called when a read access is done on
+ *                          /proc/ts-sbcinfo
+ */
+static int ts_sbcinfo_proc_read(char *page, char **start, off_t off,
+				int count, int *eof, void *data)
+{
+	int to_copy = (procfs_buffer_size <= count) ?
+		procfs_buffer_size - off : count;
+
+	if (off + to_copy >= procfs_buffer_size) {
+		to_copy = procfs_buffer_size - off;
+		*eof = 1;
+	}
+
+	if (to_copy <= 0)
+		return 0;
+
+	*start = page + off;
+	memcpy(*start, procfs_buffer + off, to_copy);
+
+	return to_copy;
+}
+
+static int __init ts5xxx_sbcinfo_init(void)
+{
+	int err;
+
+	err = ts_sbcinfo_detect(&ts_sbcinfo);
+	if (err < 0) {
+		printk(KERN_ERR KBUILD_MODNAME
+		       ": Failed to get SBC information\n");
+		return err;
+	}
+
+	proc_entry = create_proc_read_entry(PROCFS_NAME, S_IRUGO, NULL,
+					    ts_sbcinfo_proc_read, 0);
+	if (proc_entry == NULL) {
+		printk(KERN_ERR KBUILD_MODNAME
+		       ": Failed to create proc entry\n");
+		return -ENOMEM;
+	}
+
+	procfs_buffer_size = ts_sbcinfo_init_buffer(procfs_buffer, &ts_sbcinfo);
+	printk(KBUILD_MODNAME ": TS SBC's info driver loaded.\n");
+
+	return 0;
+}
+postcore_initcall(ts5xxx_sbcinfo_init);
+
+static void __exit ts5xxx_sbcinfo_exit(void)
+{
+	remove_proc_entry(proc_entry->name, proc_entry->parent);
+	proc_entry = NULL;
+}
+module_exit(ts5xxx_sbcinfo_exit);
+
+MODULE_AUTHOR("Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>");
+MODULE_AUTHOR("Alexandre Savard <alexandre.savard@savoirfairelinux.com>");
+MODULE_DESCRIPTION("Technologic Systems SingleBoardComputer /proc driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/ts5xxx-sbcinfo.h b/include/linux/ts5xxx-sbcinfo.h
new file mode 100644
index 0000000..0240e5c
--- /dev/null
+++ b/include/linux/ts5xxx-sbcinfo.h
@@ -0,0 +1,42 @@
+/*
+ * Technologic Systems TS-5xxx boards - SBC info layer
+ *
+ * Copyright (c) 2010 Savoir-faire Linux Inc.
+ *	Alexandre Savard <alexandre.savard@savoirfairelinux.com>
+ *
+ * Portions originate from ts_sbcinfo.h (c) Technologic Systems
+ *	Liberty Young <liberty@embeddedx86.com>
+ */
+
+#ifndef _LINUX_TS5XXX_SBCINFO_H
+#define _LINUX_TS5XXX_SBCINFO_H
+
+/**
+ * struct ts5xxx_sbcinfo - Describes the SBC and options installed
+ * @board_id:		Board name.
+ * @jumpers:		Connected jumpers.
+ * @rs485:		Flag to indicate the existence of RS485.
+ * @adc:		Analogic to digital converter?
+ * @rs422:		RS422 available?
+ * @ethernet:		Ethernet port available?
+ * @auto485:		Auto 485 available?
+ * @external_reset:	External reset available?
+ * @sram:		Presence of SRAM available?
+ * @industrial:		Industrial temperature.
+ */
+struct ts5xxx_sbcinfo {
+	int	board_id;
+	u8	jumpers;
+	bool	rs485;
+	bool	adc;
+	bool	rs422;
+	bool	ethernet;
+	bool	auto485;
+	bool	external_reset;
+	bool	sram;
+	bool	industrial;
+};
+
+extern void ts5xxx_sbcinfo_set(struct ts5xxx_sbcinfo *sbcinfo);
+
+#endif
-- 
1.7.1

