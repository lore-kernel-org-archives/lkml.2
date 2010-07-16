Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965218Ab0GPLMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 07:12:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:59083 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965152Ab0GPLLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:11:42 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Alexey Starikovskiy <astarikovskiy@suse.de>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        ibm-acpi-devel@lists.sourceforge.net
Subject: [PATCH 5/7] X86 platform drivers: Remove EC dump from thinkpad_acpi
Date: Fri, 16 Jul 2010 13:11:35 +0200
Message-Id: <1279278697-3694-6-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1279278697-3694-1-git-send-email-trenn@suse.de>
References: <1279278697-3694-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a general interface for that now (provided by
other patches in this patch series):
/sys/kernel/debug/ec/*/io

Signed-off-by: Thomas Renninger <trenn@suse.de>

CC: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org
CC: linux-acpi@vger.kernel.org
CC: platform-driver-x86@vger.kernel.org
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: ibm-acpi-devel@lists.sourceforge.net
---
 Documentation/laptops/thinkpad-acpi.txt |   71 +++++-------------------------
 drivers/platform/x86/thinkpad_acpi.c    |   73 -------------------------------
 2 files changed, 11 insertions(+), 133 deletions(-)

diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index fc15538..f6f8025 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -960,70 +960,21 @@ Sysfs notes:
 	subsystem, and follow all of the hwmon guidelines at
 	Documentation/hwmon.
 
+EXPERIMENTAL: Embedded controller register dump
+-----------------------------------------------
 
-EXPERIMENTAL: Embedded controller register dump -- /proc/acpi/ibm/ecdump
-------------------------------------------------------------------------
-
-This feature is marked EXPERIMENTAL because the implementation
-directly accesses hardware registers and may not work as expected. USE
-WITH CAUTION! To use this feature, you need to supply the
-experimental=1 parameter when loading the module.
-
-This feature dumps the values of 256 embedded controller
-registers. Values which have changed since the last time the registers
-were dumped are marked with a star:
-
-[root@x40 ibm-acpi]# cat /proc/acpi/ibm/ecdump
-EC       +00 +01 +02 +03 +04 +05 +06 +07 +08 +09 +0a +0b +0c +0d +0e +0f
-EC 0x00:  a7  47  87  01  fe  96  00  08  01  00  cb  00  00  00  40  00
-EC 0x10:  00  00  ff  ff  f4  3c  87  09  01  ff  42  01  ff  ff  0d  00
-EC 0x20:  00  00  00  00  00  00  00  00  00  00  00  03  43  00  00  80
-EC 0x30:  01  07  1a  00  30  04  00  00 *85  00  00  10  00  50  00  00
-EC 0x40:  00  00  00  00  00  00  14  01  00  04  00  00  00  00  00  00
-EC 0x50:  00  c0  02  0d  00  01  01  02  02  03  03  03  03 *bc *02 *bc
-EC 0x60: *02 *bc *02  00  00  00  00  00  00  00  00  00  00  00  00  00
-EC 0x70:  00  00  00  00  00  12  30  40 *24 *26 *2c *27 *20  80 *1f  80
-EC 0x80:  00  00  00  06 *37 *0e  03  00  00  00  0e  07  00  00  00  00
-EC 0x90:  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
-EC 0xa0: *ff  09  ff  09  ff  ff *64  00 *00 *00 *a2  41 *ff *ff *e0  00
-EC 0xb0:  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
-EC 0xc0:  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
-EC 0xd0:  03  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
-EC 0xe0:  00  00  00  00  00  00  00  00  11  20  49  04  24  06  55  03
-EC 0xf0:  31  55  48  54  35  38  57  57  08  2f  45  73  07  65  6c  1a
-
-This feature can be used to determine the register holding the fan
-speed on some models. To do that, do the following:
+This feature is not included in the thinkpad driver anymore.
+Instead the EC can be accessed through /sys/kernel/debug/ec with
+a userspace tool which can be found here:
+ftp://ftp.suse.com/pub/people/trenn/sources/ec
 
+Use it to determine the register holding the fan
+speed on some models. To do that, do the following:
 	- make sure the battery is fully charged
 	- make sure the fan is running
-	- run 'cat /proc/acpi/ibm/ecdump' several times, once per second or so
-
-The first step makes sure various charging-related values don't
-vary. The second ensures that the fan-related values do vary, since
-the fan speed fluctuates a bit. The third will (hopefully) mark the
-fan register with a star:
-
-[root@x40 ibm-acpi]# cat /proc/acpi/ibm/ecdump
-EC       +00 +01 +02 +03 +04 +05 +06 +07 +08 +09 +0a +0b +0c +0d +0e +0f
-EC 0x00:  a7  47  87  01  fe  96  00  08  01  00  cb  00  00  00  40  00
-EC 0x10:  00  00  ff  ff  f4  3c  87  09  01  ff  42  01  ff  ff  0d  00
-EC 0x20:  00  00  00  00  00  00  00  00  00  00  00  03  43  00  00  80
-EC 0x30:  01  07  1a  00  30  04  00  00  85  00  00  10  00  50  00  00
-EC 0x40:  00  00  00  00  00  00  14  01  00  04  00  00  00  00  00  00
-EC 0x50:  00  c0  02  0d  00  01  01  02  02  03  03  03  03  bc  02  bc
-EC 0x60:  02  bc  02  00  00  00  00  00  00  00  00  00  00  00  00  00
-EC 0x70:  00  00  00  00  00  12  30  40  24  27  2c  27  21  80  1f  80
-EC 0x80:  00  00  00  06 *be  0d  03  00  00  00  0e  07  00  00  00  00
-EC 0x90:  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
-EC 0xa0:  ff  09  ff  09  ff  ff  64  00  00  00  a2  41  ff  ff  e0  00
-EC 0xb0:  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
-EC 0xc0:  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
-EC 0xd0:  03  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
-EC 0xe0:  00  00  00  00  00  00  00  00  11  20  49  04  24  06  55  03
-EC 0xf0:  31  55  48  54  35  38  57  57  08  2f  45  73  07  65  6c  1a
-
-Another set of values that varies often is the temperature
+	- use above mentioned tool to read out the EC
+
+Often fan and temperature values vary between
 readings. Since temperatures don't change vary fast, you can take
 several quick dumps to eliminate them.
 
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 4bdb137..5d6119b 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5838,75 +5838,6 @@ static struct ibm_struct thermal_driver_data = {
 };
 
 /*************************************************************************
- * EC Dump subdriver
- */
-
-static u8 ecdump_regs[256];
-
-static int ecdump_read(struct seq_file *m)
-{
-	int i, j;
-	u8 v;
-
-	seq_printf(m, "EC      "
-		       " +00 +01 +02 +03 +04 +05 +06 +07"
-		       " +08 +09 +0a +0b +0c +0d +0e +0f\n");
-	for (i = 0; i < 256; i += 16) {
-		seq_printf(m, "EC 0x%02x:", i);
-		for (j = 0; j < 16; j++) {
-			if (!acpi_ec_read(i + j, &v))
-				break;
-			if (v != ecdump_regs[i + j])
-				seq_printf(m, " *%02x", v);
-			else
-				seq_printf(m, "  %02x", v);
-			ecdump_regs[i + j] = v;
-		}
-		seq_putc(m, '\n');
-		if (j != 16)
-			break;
-	}
-
-	/* These are way too dangerous to advertise openly... */
-#if 0
-	seq_printf(m, "commands:\t0x<offset> 0x<value>"
-		       " (<offset> is 00-ff, <value> is 00-ff)\n");
-	seq_printf(m, "commands:\t0x<offset> <value>  "
-		       " (<offset> is 00-ff, <value> is 0-255)\n");
-#endif
-	return 0;
-}
-
-static int ecdump_write(char *buf)
-{
-	char *cmd;
-	int i, v;
-
-	while ((cmd = next_cmd(&buf))) {
-		if (sscanf(cmd, "0x%x 0x%x", &i, &v) == 2) {
-			/* i and v set */
-		} else if (sscanf(cmd, "0x%x %u", &i, &v) == 2) {
-			/* i and v set */
-		} else
-			return -EINVAL;
-		if (i >= 0 && i < 256 && v >= 0 && v < 256) {
-			if (!acpi_ec_write(i, v))
-				return -EIO;
-		} else
-			return -EINVAL;
-	}
-
-	return 0;
-}
-
-static struct ibm_struct ecdump_driver_data = {
-	.name = "ecdump",
-	.read = ecdump_read,
-	.write = ecdump_write,
-	.flags.experimental = 1,
-};
-
-/*************************************************************************
  * Backlight/brightness subdriver
  */
 
@@ -8883,9 +8814,6 @@ static struct ibm_init_struct ibms_init[] __initdata = {
 		.data = &thermal_driver_data,
 	},
 	{
-		.data = &ecdump_driver_data,
-	},
-	{
 		.init = brightness_init,
 		.data = &brightness_driver_data,
 	},
@@ -8993,7 +8921,6 @@ TPACPI_PARAM(light);
 TPACPI_PARAM(cmos);
 TPACPI_PARAM(led);
 TPACPI_PARAM(beep);
-TPACPI_PARAM(ecdump);
 TPACPI_PARAM(brightness);
 TPACPI_PARAM(volume);
 TPACPI_PARAM(fan);
-- 
1.6.3

