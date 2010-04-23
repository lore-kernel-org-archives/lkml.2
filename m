Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab0DWIAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:00:47 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:41841 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab0DWIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:00:40 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 02/14] m68k: amiga - Zorro bus modalias support
Date: Fri, 23 Apr 2010 10:00:23 +0200
Message-Id: <1272009635-6504-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
References: <1272009635-6504-1-git-send-email-geert@linux-m68k.org>
 <1272009635-6504-2-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Amiga Zorro bus modalias and uevent support

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/a2065.c             |    1 +
 drivers/net/ariadne.c           |    1 +
 drivers/net/hydra.c             |    1 +
 drivers/net/zorro8390.c         |    1 +
 drivers/scsi/zorro7xx.c         |    1 +
 drivers/video/cirrusfb.c        |    1 +
 drivers/video/fm2fb.c           |    1 +
 drivers/zorro/zorro-driver.c    |   24 ++++++++++++++++++++++++
 drivers/zorro/zorro-sysfs.c     |   11 +++++++++++
 include/linux/mod_devicetable.h |   10 ++++++++++
 include/linux/zorro.h           |   13 +------------
 scripts/mod/file2alias.c        |   15 +++++++++++++++
 12 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/drivers/net/a2065.c b/drivers/net/a2065.c
index 9c08374..099f4fd 100644
--- a/drivers/net/a2065.c
+++ b/drivers/net/a2065.c
@@ -694,6 +694,7 @@ static struct zorro_device_id a2065_zorro_tbl[] __devinitdata = {
 	{ ZORRO_PROD_AMERISTAR_A2065 },
 	{ 0 }
 };
+MODULE_DEVICE_TABLE(zorro, a2065_zorro_tbl);
 
 static struct zorro_driver a2065_driver = {
 	.name		= "a2065",
diff --git a/drivers/net/ariadne.c b/drivers/net/ariadne.c
index 29e53eb..47bfa37 100644
--- a/drivers/net/ariadne.c
+++ b/drivers/net/ariadne.c
@@ -147,6 +147,7 @@ static struct zorro_device_id ariadne_zorro_tbl[] __devinitdata = {
     { ZORRO_PROD_VILLAGE_TRONIC_ARIADNE },
     { 0 }
 };
+MODULE_DEVICE_TABLE(zorro, ariadne_zorro_tbl);
 
 static struct zorro_driver ariadne_driver = {
     .name	= "ariadne",
diff --git a/drivers/net/hydra.c b/drivers/net/hydra.c
index b96cf2d..dd3de56 100644
--- a/drivers/net/hydra.c
+++ b/drivers/net/hydra.c
@@ -72,6 +72,7 @@ static struct zorro_device_id hydra_zorro_tbl[] __devinitdata = {
     { ZORRO_PROD_HYDRA_SYSTEMS_AMIGANET },
     { 0 }
 };
+MODULE_DEVICE_TABLE(zorro, hydra_zorro_tbl);
 
 static struct zorro_driver hydra_driver = {
     .name	= "hydra",
diff --git a/drivers/net/zorro8390.c b/drivers/net/zorro8390.c
index 3926b2a..de28bfc 100644
--- a/drivers/net/zorro8390.c
+++ b/drivers/net/zorro8390.c
@@ -102,6 +102,7 @@ static struct zorro_device_id zorro8390_zorro_tbl[] __devinitdata = {
     { ZORRO_PROD_INDIVIDUAL_COMPUTERS_X_SURF, },
     { 0 }
 };
+MODULE_DEVICE_TABLE(zorro, zorro8390_zorro_tbl);
 
 static struct zorro_driver zorro8390_driver = {
     .name	= "zorro8390",
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 64d40a2..b416fa4 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -68,6 +68,7 @@ static struct zorro_device_id zorro7xx_zorro_tbl[] __devinitdata = {
 	},
 	{ 0 }
 };
+MODULE_DEVICE_TABLE(zorro, zorro7xx_zorro_tbl);
 
 static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 				       const struct zorro_device_id *ent)
diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 8a87602..bf19143 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -298,6 +298,7 @@ static const struct zorro_device_id cirrusfb_zorro_table[] = {
 	},
 	{ 0 }
 };
+MODULE_DEVICE_TABLE(zorro, cirrusfb_zorro_table);
 
 static const struct {
 	zorro_id id2;
diff --git a/drivers/video/fm2fb.c b/drivers/video/fm2fb.c
index 6c91c61..1b0feb8 100644
--- a/drivers/video/fm2fb.c
+++ b/drivers/video/fm2fb.c
@@ -219,6 +219,7 @@ static struct zorro_device_id fm2fb_devices[] __devinitdata = {
 	{ ZORRO_PROD_HELFRICH_RAINBOW_II },
 	{ 0 }
 };
+MODULE_DEVICE_TABLE(zorro, fm2fb_devices);
 
 static struct zorro_driver fm2fb_driver = {
 	.name		= "fm2fb",
diff --git a/drivers/zorro/zorro-driver.c b/drivers/zorro/zorro-driver.c
index e6c4390..aeb0615 100644
--- a/drivers/zorro/zorro-driver.c
+++ b/drivers/zorro/zorro-driver.c
@@ -137,10 +137,34 @@ static int zorro_bus_match(struct device *dev, struct device_driver *drv)
 	return 0;
 }
 
+static int zorro_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+#ifdef CONFIG_HOTPLUG
+	struct zorro_dev *z;
+
+	if (!dev)
+		return -ENODEV;
+
+	z = to_zorro_dev(dev);
+	if (!z)
+		return -ENODEV;
+
+	if (add_uevent_var(env, "ZORRO_ID=%08X", z->id) ||
+	    add_uevent_var(env, "ZORRO_SLOT_NAME=%s", z->dev.bus_id) ||
+	    add_uevent_var(env, "ZORRO_SLOT_ADDR=%04X", z->slotaddr) ||
+	    add_uevent_var(env, "MODALIAS=" ZORRO_DEVICE_MODALIAS_FMT, z->id))
+		return -ENOMEM;
+
+	return 0;
+#else /* !CONFIG_HOTPLUG */
+	return -ENODEV;
+#endif /* !CONFIG_HOTPLUG */
+}
 
 struct bus_type zorro_bus_type = {
 	.name	= "zorro",
 	.match	= zorro_bus_match,
+	.uevent	= zorro_uevent,
 	.probe	= zorro_device_probe,
 	.remove	= zorro_device_remove,
 };
diff --git a/drivers/zorro/zorro-sysfs.c b/drivers/zorro/zorro-sysfs.c
index 5290552..7139ec2 100644
--- a/drivers/zorro/zorro-sysfs.c
+++ b/drivers/zorro/zorro-sysfs.c
@@ -77,6 +77,16 @@ static struct bin_attribute zorro_config_attr = {
 	.read = zorro_read_config,
 };
 
+static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct zorro_dev *z = to_zorro_dev(dev);
+
+	return sprintf(buf, ZORRO_DEVICE_MODALIAS_FMT "\n", z->id);
+}
+
+static DEVICE_ATTR(modalias, S_IRUGO, modalias_show, NULL);
+
 void zorro_create_sysfs_dev_files(struct zorro_dev *z)
 {
 	struct device *dev = &z->dev;
@@ -88,6 +98,7 @@ void zorro_create_sysfs_dev_files(struct zorro_dev *z)
 	device_create_file(dev, &dev_attr_slotaddr);
 	device_create_file(dev, &dev_attr_slotsize);
 	device_create_file(dev, &dev_attr_resource);
+	device_create_file(dev, &dev_attr_modalias);
 	sysfs_create_bin_file(&dev->kobj, &zorro_config_attr);
 }
 
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 97b91d1..45026a0 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -447,4 +447,14 @@ struct dmi_system_id {
 
 #define DMI_MATCH(a, b)	{ a, b }
 
+struct zorro_device_id {
+	__u32 id;			/* Device ID or ZORRO_WILDCARD */
+	kernel_ulong_t driver_data;	/* Data private to the driver */
+};
+
+#define ZORRO_WILDCARD			(0xffffffff)	/* not official */
+
+#define ZORRO_DEVICE_MODALIAS_FMT	"zorro:i%08X"
+
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/include/linux/zorro.h b/include/linux/zorro.h
index 913bfc2..908db1b 100644
--- a/include/linux/zorro.h
+++ b/include/linux/zorro.h
@@ -38,8 +38,6 @@
 typedef __u32 zorro_id;
 
 
-#define ZORRO_WILDCARD		(0xffffffff)	/* not official */
-
 /* Include the ID list */
 #include <linux/zorro_ids.h>
 
@@ -116,6 +114,7 @@ struct ConfigDev {
 
 #include <linux/init.h>
 #include <linux/ioport.h>
+#include <linux/mod_devicetable.h>
 
 #include <asm/zorro.h>
 
@@ -155,16 +154,6 @@ extern struct bus_type zorro_bus_type;
 
 
     /*
-     *  Zorro device IDs
-     */
-
-struct zorro_device_id {
-	zorro_id id;			/* Device ID or ZORRO_WILDCARD */
-	unsigned long driver_data;	/* Data private to the driver */
-};
-
-
-    /*
      *  Zorro device drivers
      */
 
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index d4dc222..d8cbbf2 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -696,6 +696,17 @@ static int do_dmi_entry(const char *filename, struct dmi_system_id *id,
 	strcat(alias, ":");
 	return 1;
 }
+
+/* Looks like: zorro:iN. */
+static int do_zorro_entry(const char *filename, struct zorro_device_id *id,
+			  char *alias)
+{
+	id->id = TO_NATIVE(id->id);
+	strcpy(alias, "zorro:");
+	ADD(alias, "i", id->id != ZORRO_WILDCARD, id->id);
+	return 1;
+}
+
 /* Ignore any prefix, eg. some architectures prepend _ */
 static inline int sym_is(const char *symbol, const char *name)
 {
@@ -835,6 +846,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_table(symval, sym->st_size,
 			 sizeof(struct dmi_system_id), "dmi",
 			 do_dmi_entry, mod);
+	else if (sym_is(symname, "__mod_zorro_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct zorro_device_id), "zorro",
+			 do_zorro_entry, mod);
 	free(zeros);
 }
 
-- 
1.6.0.4

