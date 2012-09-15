Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab2IODWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 23:22:36 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54604 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab2IODWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 23:22:24 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH] i2c/scx200_*: replace printks with pr_<level>s
Date: Fri, 14 Sep 2012 21:21:58 -0600
Message-Id: <1347679318-6834-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.1.487.ga3935e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace printks with pr_<level>s, add pr_fmt()s to replace NAMEs

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/i2c/busses/scx200_acb.c | 18 ++++++++++--------
 drivers/i2c/busses/scx200_i2c.c | 12 +++++++-----
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/i2c/busses/scx200_acb.c b/drivers/i2c/busses/scx200_acb.c
index 2eacb77..8851526 100644
--- a/drivers/i2c/busses/scx200_acb.c
+++ b/drivers/i2c/busses/scx200_acb.c
@@ -23,6 +23,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -398,7 +400,7 @@ static __devinit int scx200_acb_probe(struct scx200_acb_iface *iface)
 	outb(0x70, ACBCTL2);
 
 	if (inb(ACBCTL2) != 0x70) {
-		pr_debug(NAME ": ACBCTL2 readback failed\n");
+		pr_debug("ACBCTL2 readback failed\n");
 		return -ENXIO;
 	}
 
@@ -406,7 +408,7 @@ static __devinit int scx200_acb_probe(struct scx200_acb_iface *iface)
 
 	val = inb(ACBCTL1);
 	if (val) {
-		pr_debug(NAME ": disabled, but ACBCTL1=0x%02x\n",
+		pr_debug("disabled, but ACBCTL1=0x%02x\n",
 			val);
 		return -ENXIO;
 	}
@@ -417,7 +419,7 @@ static __devinit int scx200_acb_probe(struct scx200_acb_iface *iface)
 
 	val = inb(ACBCTL1);
 	if ((val & ACBCTL1_NMINTE) != ACBCTL1_NMINTE) {
-		pr_debug(NAME ": enabled, but NMINTE won't be set, "
+		pr_debug("enabled, but NMINTE won't be set, "
 			 "ACBCTL1=0x%02x\n", val);
 		return -ENXIO;
 	}
@@ -433,7 +435,7 @@ static __devinit struct scx200_acb_iface *scx200_create_iface(const char *text,
 
 	iface = kzalloc(sizeof(*iface), GFP_KERNEL);
 	if (!iface) {
-		printk(KERN_ERR NAME ": can't allocate memory\n");
+		pr_err("can't allocate memory\n");
 		return NULL;
 	}
 
@@ -459,14 +461,14 @@ static int __devinit scx200_acb_create(struct scx200_acb_iface *iface)
 
 	rc = scx200_acb_probe(iface);
 	if (rc) {
-		printk(KERN_WARNING NAME ": probe failed\n");
+		pr_warning("probe failed\n");
 		return rc;
 	}
 
 	scx200_acb_reset(iface);
 
 	if (i2c_add_adapter(adapter) < 0) {
-		printk(KERN_ERR NAME ": failed to register\n");
+		pr_err("failed to register\n");
 		return -ENODEV;
 	}
 
@@ -493,7 +495,7 @@ static struct scx200_acb_iface * __devinit scx200_create_dev(const char *text,
 		return NULL;
 
 	if (!request_region(base, 8, iface->adapter.name)) {
-		printk(KERN_ERR NAME ": can't allocate io 0x%lx-0x%lx\n",
+		pr_err("can't allocate io 0x%lx-0x%lx\n",
 		       base, base + 8 - 1);
 		goto errout_free;
 	}
@@ -583,7 +585,7 @@ static __init void scx200_scan_isa(void)
 
 static int __init scx200_acb_init(void)
 {
-	pr_debug(NAME ": NatSemi SCx200 ACCESS.bus Driver\n");
+	pr_debug("NatSemi SCx200 ACCESS.bus Driver\n");
 
 	/* First scan for ISA-based devices */
 	scx200_scan_isa();	/* XXX: should we care about errors? */
diff --git a/drivers/i2c/busses/scx200_i2c.c b/drivers/i2c/busses/scx200_i2c.c
index 7ee0d50..355a8a5 100644
--- a/drivers/i2c/busses/scx200_i2c.c
+++ b/drivers/i2c/busses/scx200_i2c.c
@@ -21,6 +21,8 @@
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.		     
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -88,17 +90,17 @@ static struct i2c_adapter scx200_i2c_ops = {
 
 static int scx200_i2c_init(void)
 {
-	pr_debug(NAME ": NatSemi SCx200 I2C Driver\n");
+	pr_debug("NatSemi SCx200 I2C Driver\n");
 
 	if (!scx200_gpio_present()) {
-		printk(KERN_ERR NAME ": no SCx200 gpio pins available\n");
+		pr_err("no SCx200 gpio pins available\n");
 		return -ENODEV;
 	}
 
-	pr_debug(NAME ": SCL=GPIO%02u, SDA=GPIO%02u\n", scl, sda);
+	pr_debug("SCL=GPIO%02u, SDA=GPIO%02u\n", scl, sda);
 
 	if (scl == -1 || sda == -1 || scl == sda) {
-		printk(KERN_ERR NAME ": scl and sda must be specified\n");
+		pr_err("scl and sda must be specified\n");
 		return -EINVAL;
 	}
 
@@ -107,7 +109,7 @@ static int scx200_i2c_init(void)
 	scx200_gpio_configure(sda, ~2, 5);
 
 	if (i2c_bit_add_bus(&scx200_i2c_ops) < 0) {
-		printk(KERN_ERR NAME ": adapter %s registration failed\n", 
+		pr_err("adapter %s registration failed\n", 
 		       scx200_i2c_ops.name);
 		return -ENODEV;
 	}
-- 
1.7.10.1.487.ga3935e6

