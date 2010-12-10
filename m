Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab0LJD3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:29:30 -0500
Received: from mail.perches.com ([173.55.12.10]:2462 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab0LJD3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:29:22 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH 1/6] hid: Add and use hid_<level>: dev_<level> equivalents
Date: Thu,  9 Dec 2010 19:29:03 -0800
Message-Id: <b17b913b41061eea31ae946cfbd08b5f9cda1536.1291951482.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
References: <alpine.LNX.2.00.1012091454010.508@pobox.suse.cz>
In-Reply-To: <cover.1291951482.git.joe@perches.com>
References: <cover.1291951482.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neaten current uses of dev_<level> by adding and using
hid specific hid_<level> macros.

Convert existing uses of dev_<level> uses to hid_<level>.
Convert hid-pidff printk uses to hid_<level>.

Remove err_hid and use hid_err instead.

Add missing newlines to logging messages where necessary.
Coalesce format strings.

Add and use pr_fmt(fmt) KBUILD_MODNAME ": " fmt

Other miscellaneous changes:

Add const struct hid_device * argument to hid-core functions
extract() and implement() so hid_<level> can be used by them.
Fix bad indentation in hid-core hid_input_field function
that calls extract() function above.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/hid/hid-3m-pct.c       |    2 +-
 drivers/hid/hid-a4tech.c       |    6 +-
 drivers/hid/hid-apple.c        |   14 ++--
 drivers/hid/hid-axff.c         |   14 ++--
 drivers/hid/hid-belkin.c       |    4 +-
 drivers/hid/hid-cando.c        |    2 +-
 drivers/hid/hid-cherry.c       |    3 +-
 drivers/hid/hid-core.c         |   64 +++++++++-------
 drivers/hid/hid-cypress.c      |    4 +-
 drivers/hid/hid-debug.c        |    4 +-
 drivers/hid/hid-drff.c         |   14 ++--
 drivers/hid/hid-egalax.c       |    2 +-
 drivers/hid/hid-elecom.c       |    3 +-
 drivers/hid/hid-emsff.c        |   13 ++--
 drivers/hid/hid-gaff.c         |   13 ++--
 drivers/hid/hid-input.c        |    2 +-
 drivers/hid/hid-kye.c          |    4 +-
 drivers/hid/hid-lg.c           |   15 ++--
 drivers/hid/hid-lg2ff.c        |    9 +-
 drivers/hid/hid-lg3ff.c        |    9 +-
 drivers/hid/hid-lg4ff.c        |    9 +-
 drivers/hid/hid-lgff.c         |    8 +-
 drivers/hid/hid-magicmouse.c   |   15 ++--
 drivers/hid/hid-microsoft.c    |    7 +-
 drivers/hid/hid-monterey.c     |    3 +-
 drivers/hid/hid-mosart.c       |    2 +-
 drivers/hid/hid-ntrig.c        |    9 +-
 drivers/hid/hid-ortek.c        |    3 +-
 drivers/hid/hid-petalynx.c     |    7 +-
 drivers/hid/hid-picolcd.c      |   45 +++++------
 drivers/hid/hid-pl.c           |   16 ++--
 drivers/hid/hid-prodikeys.c    |   21 +++---
 drivers/hid/hid-quanta.c       |    2 +-
 drivers/hid/hid-roccat-kone.c  |   22 +++---
 drivers/hid/hid-roccat-pyra.c  |   20 ++---
 drivers/hid/hid-roccat.c       |   10 +-
 drivers/hid/hid-samsung.c      |    8 +-
 drivers/hid/hid-sjoy.c         |   16 ++--
 drivers/hid/hid-sony.c         |   11 +--
 drivers/hid/hid-stantum.c      |    2 +-
 drivers/hid/hid-sunplus.c      |    3 +-
 drivers/hid/hid-tmff.c         |   27 +++----
 drivers/hid/hid-wacom.c        |   26 ++++---
 drivers/hid/hid-zpff.c         |   11 +--
 drivers/hid/hid-zydacron.c     |   11 +--
 drivers/hid/hidraw.c           |   12 ++-
 drivers/hid/usbhid/hid-core.c  |   48 ++++++------
 drivers/hid/usbhid/hid-pidff.c |  164 +++++++++++++++++++---------------------
 drivers/hid/usbhid/hiddev.c    |    2 +-
 drivers/hid/usbhid/usbkbd.c    |   24 ++++---
 include/linux/hid.h            |   32 ++++++--
 51 files changed, 398 insertions(+), 399 deletions(-)

diff --git a/drivers/hid/hid-3m-pct.c b/drivers/hid/hid-3m-pct.c
index 02d8cd3..4546c12 100644
--- a/drivers/hid/hid-3m-pct.c
+++ b/drivers/hid/hid-3m-pct.c
@@ -274,7 +274,7 @@ static int mmm_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	md = kzalloc(sizeof(struct mmm_data), GFP_KERNEL);
 	if (!md) {
-		dev_err(&hdev->dev, "cannot allocate 3M data\n");
+		hid_err(hdev, "cannot allocate 3M data\n");
 		return -ENOMEM;
 	}
 	hid_set_drvdata(hdev, md);
diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index 1666c16..902d1df 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -93,7 +93,7 @@ static int a4_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	a4 = kzalloc(sizeof(*a4), GFP_KERNEL);
 	if (a4 == NULL) {
-		dev_err(&hdev->dev, "can't alloc device descriptor\n");
+		hid_err(hdev, "can't alloc device descriptor\n");
 		ret = -ENOMEM;
 		goto err_free;
 	}
@@ -104,13 +104,13 @@ static int a4_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 8aa7175..61aa712 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -16,6 +16,8 @@
  * any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
@@ -280,8 +282,8 @@ static __u8 *apple_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 	if ((asc->quirks & APPLE_RDESC_JIS) && *rsize >= 60 &&
 			rdesc[53] == 0x65 && rdesc[59] == 0x65) {
-		dev_info(&hdev->dev, "fixing up MacBook JIS keyboard report "
-				"descriptor\n");
+		hid_info(hdev,
+			 "fixing up MacBook JIS keyboard report descriptor\n");
 		rdesc[53] = rdesc[59] = 0xe7;
 	}
 	return rdesc;
@@ -351,7 +353,7 @@ static int apple_probe(struct hid_device *hdev,
 
 	asc = kzalloc(sizeof(*asc), GFP_KERNEL);
 	if (asc == NULL) {
-		dev_err(&hdev->dev, "can't alloc apple descriptor\n");
+		hid_err(hdev, "can't alloc apple descriptor\n");
 		return -ENOMEM;
 	}
 
@@ -361,7 +363,7 @@ static int apple_probe(struct hid_device *hdev,
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
@@ -372,7 +374,7 @@ static int apple_probe(struct hid_device *hdev,
 
 	ret = hid_hw_start(hdev, connect_mask);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
@@ -512,7 +514,7 @@ static int __init apple_init(void)
 
 	ret = hid_register_driver(&apple_driver);
 	if (ret)
-		printk(KERN_ERR "can't register apple driver\n");
+		pr_err("can't register apple driver\n");
 
 	return ret;
 }
diff --git a/drivers/hid/hid-axff.c b/drivers/hid/hid-axff.c
index f42ee14..e5b961d 100644
--- a/drivers/hid/hid-axff.c
+++ b/drivers/hid/hid-axff.c
@@ -73,14 +73,14 @@ static int axff_init(struct hid_device *hid)
 	int error;
 
 	if (list_empty(report_list)) {
-		dev_err(&hid->dev, "no output reports found\n");
+		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
 	}
 
 	report = list_first_entry(report_list, struct hid_report, list);
 
 	if (report->maxfield < 4) {
-		dev_err(&hid->dev, "no fields in the report: %d\n", report->maxfield);
+		hid_err(hid, "no fields in the report: %d\n", report->maxfield);
 		return -ENODEV;
 	}
 
@@ -101,7 +101,7 @@ static int axff_init(struct hid_device *hid)
 	axff->report->field[3]->value[0] = 0x00;
 	usbhid_submit_report(hid, axff->report, USB_DIR_OUT);
 
-	dev_info(&hid->dev, "Force Feedback for ACRUX game controllers by Sergei Kolzun<x0r@dv-life.ru>\n");
+	hid_info(hid, "Force Feedback for ACRUX game controllers by Sergei Kolzun<x0r@dv-life.ru>\n");
 
 	return 0;
 
@@ -114,17 +114,17 @@ static int ax_probe(struct hid_device *hdev, const struct hid_device_id *id)
 {
 	int error;
 
-	dev_dbg(&hdev->dev, "ACRUX HID hardware probe...");
+	dev_dbg(&hdev->dev, "ACRUX HID hardware probe...\n");
 
 	error = hid_parse(hdev);
 	if (error) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		return error;
 	}
 
 	error = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
 	if (error) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		return error;
 	}
 
@@ -134,7 +134,7 @@ static int ax_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		 * Do not fail device initialization completely as device
 		 * may still be partially operable, just warn.
 		 */
-		dev_warn(&hdev->dev,
+		hid_warn(hdev,
 			 "Failed to enable force feedback support, error: %d\n",
 			 error);
 	}
diff --git a/drivers/hid/hid-belkin.c b/drivers/hid/hid-belkin.c
index 4ce7aa3..a1a765a 100644
--- a/drivers/hid/hid-belkin.c
+++ b/drivers/hid/hid-belkin.c
@@ -56,14 +56,14 @@ static int belkin_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT |
 		((quirks & BELKIN_HIDDEV) ? HID_CONNECT_HIDDEV_FORCE : 0));
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
diff --git a/drivers/hid/hid-cando.c b/drivers/hid/hid-cando.c
index 5925bdc..375b509 100644
--- a/drivers/hid/hid-cando.c
+++ b/drivers/hid/hid-cando.c
@@ -207,7 +207,7 @@ static int cando_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	td = kmalloc(sizeof(struct cando_data), GFP_KERNEL);
 	if (!td) {
-		dev_err(&hdev->dev, "cannot allocate Cando Touch data\n");
+		hid_err(hdev, "cannot allocate Cando Touch data\n");
 		return -ENOMEM;
 	}
 	hid_set_drvdata(hdev, td);
diff --git a/drivers/hid/hid-cherry.c b/drivers/hid/hid-cherry.c
index e880086..888ece6 100644
--- a/drivers/hid/hid-cherry.c
+++ b/drivers/hid/hid-cherry.c
@@ -30,8 +30,7 @@ static __u8 *ch_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 17 && rdesc[11] == 0x3c && rdesc[12] == 0x02) {
-		dev_info(&hdev->dev, "fixing up Cherry Cymotion report "
-				"descriptor\n");
+		hid_info(hdev, "fixing up Cherry Cymotion report descriptor\n");
 		rdesc[11] = rdesc[16] = 0xff;
 		rdesc[12] = rdesc[17] = 0x03;
 	}
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 94105b8..2f410ae 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -14,6 +14,8 @@
  * any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -672,7 +674,8 @@ int hid_parse_report(struct hid_device *device, __u8 *start,
 
 		if (dispatch_type[item.type](parser, &item)) {
 			dbg_hid("item %u %u %u %u parsing failed\n",
-				item.format, (unsigned)item.size, (unsigned)item.type, (unsigned)item.tag);
+				item.format, (unsigned)item.size,
+				(unsigned)item.type, (unsigned)item.tag);
 			goto err;
 		}
 
@@ -737,13 +740,14 @@ static u32 s32ton(__s32 value, unsigned n)
  * Search linux-kernel and linux-usb-devel archives for "hid-core extract".
  */
 
-static __inline__ __u32 extract(__u8 *report, unsigned offset, unsigned n)
+static __inline__ __u32 extract(const struct hid_device *hid, __u8 *report,
+				unsigned offset, unsigned n)
 {
 	u64 x;
 
 	if (n > 32)
-		printk(KERN_WARNING "HID: extract() called with n (%d) > 32! (%s)\n",
-				n, current->comm);
+		hid_warn(hid, "extract() called with n (%d) > 32! (%s)\n",
+			 n, current->comm);
 
 	report += offset >> 3;  /* adjust byte index */
 	offset &= 7;            /* now only need bit offset into one byte */
@@ -760,18 +764,19 @@ static __inline__ __u32 extract(__u8 *report, unsigned offset, unsigned n)
  * endianness of register values by considering a register
  * a "cached" copy of the little endiad bit stream.
  */
-static __inline__ void implement(__u8 *report, unsigned offset, unsigned n, __u32 value)
+static __inline__ void implement(const struct hid_device *hid, __u8 *report,
+				 unsigned offset, unsigned n, __u32 value)
 {
 	u64 x;
 	u64 m = (1ULL << n) - 1;
 
 	if (n > 32)
-		printk(KERN_WARNING "HID: implement() called with n (%d) > 32! (%s)\n",
-				n, current->comm);
+		hid_warn(hid, "%s() called with n (%d) > 32! (%s)\n",
+			 __func__, n, current->comm);
 
 	if (value > m)
-		printk(KERN_WARNING "HID: implement() called with too large value %d! (%s)\n",
-				value, current->comm);
+		hid_warn(hid, "%s() called with too large value %d! (%s)\n",
+			 __func__, value, current->comm);
 	WARN_ON(value > m);
 	value &= m;
 
@@ -892,13 +897,16 @@ static void hid_input_field(struct hid_device *hid, struct hid_field *field,
 
 	for (n = 0; n < count; n++) {
 
-			value[n] = min < 0 ? snto32(extract(data, offset + n * size, size), size) :
-						    extract(data, offset + n * size, size);
+		value[n] = min < 0 ?
+			snto32(extract(hid, data, offset + n * size, size),
+			       size) :
+			extract(hid, data, offset + n * size, size);
 
-			if (!(field->flags & HID_MAIN_ITEM_VARIABLE) /* Ignore report if ErrorRollOver */
-			    && value[n] >= min && value[n] <= max
-			    && field->usage[value[n] - min].hid == HID_UP_KEYBOARD + 1)
-				goto exit;
+		/* Ignore report if ErrorRollOver */
+		if (!(field->flags & HID_MAIN_ITEM_VARIABLE) &&
+		    value[n] >= min && value[n] <= max &&
+		    field->usage[value[n] - min].hid == HID_UP_KEYBOARD + 1)
+			goto exit;
 	}
 
 	for (n = 0; n < count; n++) {
@@ -928,7 +936,8 @@ exit:
  * Output the field into the report.
  */
 
-static void hid_output_field(struct hid_field *field, __u8 *data)
+static void hid_output_field(const struct hid_device *hid,
+			     struct hid_field *field, __u8 *data)
 {
 	unsigned count = field->report_count;
 	unsigned offset = field->report_offset;
@@ -937,9 +946,11 @@ static void hid_output_field(struct hid_field *field, __u8 *data)
 
 	for (n = 0; n < count; n++) {
 		if (field->logical_minimum < 0)	/* signed values */
-			implement(data, offset + n * size, size, s32ton(field->value[n], size));
+			implement(hid, data, offset + n * size, size,
+				  s32ton(field->value[n], size));
 		else				/* unsigned values */
-			implement(data, offset + n * size, size, field->value[n]);
+			implement(hid, data, offset + n * size, size,
+				  field->value[n]);
 	}
 }
 
@@ -956,7 +967,7 @@ void hid_output_report(struct hid_report *report, __u8 *data)
 
 	memset(data, 0, ((report->size - 1) >> 3) + 1);
 	for (n = 0; n < report->maxfield; n++)
-		hid_output_field(report->field[n], data);
+		hid_output_field(report->device, report->field[n], data);
 }
 EXPORT_SYMBOL_GPL(hid_output_report);
 
@@ -1169,8 +1180,7 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 		hdev->claimed |= HID_CLAIMED_HIDRAW;
 
 	if (!hdev->claimed) {
-		dev_err(&hdev->dev, "claimed by neither input, hiddev nor "
-				"hidraw\n");
+		hid_err(hdev, "claimed by neither input, hiddev nor hidraw\n");
 		return -ENODEV;
 	}
 
@@ -1210,9 +1220,9 @@ int hid_connect(struct hid_device *hdev, unsigned int connect_mask)
 		bus = "<UNKNOWN>";
 	}
 
-	dev_info(&hdev->dev, "%s: %s HID v%x.%02x %s [%s] on %s\n",
-			buf, bus, hdev->version >> 8, hdev->version & 0xff,
-			type, hdev->name, hdev->phys);
+	hid_info(hdev, "%s: %s HID v%x.%02x %s [%s] on %s\n",
+		 buf, bus, hdev->version >> 8, hdev->version & 0xff,
+		 type, hdev->name, hdev->phys);
 
 	return 0;
 }
@@ -1962,12 +1972,12 @@ static int __init hid_init(void)
 	int ret;
 
 	if (hid_debug)
-		printk(KERN_WARNING "HID: hid_debug is now used solely for parser and driver debugging.\n"
-				"HID: debugfs is now used for inspecting the device (report descriptor, reports)\n");
+		pr_warn("hid_debug is now used solely for parser and driver debugging.\n"
+			"debugfs is now used for inspecting the device (report descriptor, reports)\n");
 
 	ret = bus_register(&hid_bus_type);
 	if (ret) {
-		printk(KERN_ERR "HID: can't register hid bus\n");
+		pr_err("can't register hid bus\n");
 		goto err;
 	}
 
diff --git a/drivers/hid/hid-cypress.c b/drivers/hid/hid-cypress.c
index 4cd0e23..2f0be4c 100644
--- a/drivers/hid/hid-cypress.c
+++ b/drivers/hid/hid-cypress.c
@@ -107,13 +107,13 @@ static int cp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 75c5e23..555382f 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -26,6 +26,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/sched.h>
@@ -393,7 +395,7 @@ char *hid_resolv_usage(unsigned usage, struct seq_file *f) {
 
 	buf = resolv_usage_page(usage >> 16, f);
 	if (IS_ERR(buf)) {
-		printk(KERN_ERR "error allocating HID debug buffer\n");
+		pr_err("error allocating HID debug buffer\n");
 		return NULL;
 	}
 
diff --git a/drivers/hid/hid-drff.c b/drivers/hid/hid-drff.c
index 968b04f..afcf3d6 100644
--- a/drivers/hid/hid-drff.c
+++ b/drivers/hid/hid-drff.c
@@ -96,18 +96,18 @@ static int drff_init(struct hid_device *hid)
 	int error;
 
 	if (list_empty(report_list)) {
-		dev_err(&hid->dev, "no output reports found\n");
+		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
 	}
 
 	report = list_first_entry(report_list, struct hid_report, list);
 	if (report->maxfield < 1) {
-		dev_err(&hid->dev, "no fields in the report\n");
+		hid_err(hid, "no fields in the report\n");
 		return -ENODEV;
 	}
 
 	if (report->field[0]->report_count < 7) {
-		dev_err(&hid->dev, "not enough values in the field\n");
+		hid_err(hid, "not enough values in the field\n");
 		return -ENODEV;
 	}
 
@@ -133,8 +133,8 @@ static int drff_init(struct hid_device *hid)
 	drff->report->field[0]->value[6] = 0x00;
 	usbhid_submit_report(hid, drff->report, USB_DIR_OUT);
 
-	dev_info(&hid->dev, "Force Feedback for DragonRise Inc. game "
-	       "controllers by Richard Walmsley <richwalm@gmail.com>\n");
+	hid_info(hid, "Force Feedback for DragonRise Inc. "
+		 "game controllers by Richard Walmsley <richwalm@gmail.com>\n");
 
 	return 0;
 }
@@ -153,13 +153,13 @@ static int dr_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err;
 	}
 
diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
index 5a1b52e..72b1dd8 100644
--- a/drivers/hid/hid-egalax.c
+++ b/drivers/hid/hid-egalax.c
@@ -223,7 +223,7 @@ static int egalax_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	td = kzalloc(sizeof(struct egalax_data), GFP_KERNEL);
 	if (!td) {
-		dev_err(&hdev->dev, "cannot allocate eGalax data\n");
+		hid_err(hdev, "cannot allocate eGalax data\n");
 		return -ENOMEM;
 	}
 	hid_set_drvdata(hdev, td);
diff --git a/drivers/hid/hid-elecom.c b/drivers/hid/hid-elecom.c
index 6e31f30..79d0c61 100644
--- a/drivers/hid/hid-elecom.c
+++ b/drivers/hid/hid-elecom.c
@@ -24,8 +24,7 @@ static __u8 *elecom_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 48 && rdesc[46] == 0x05 && rdesc[47] == 0x0c) {
-		dev_info(&hdev->dev, "Fixing up Elecom BM084 "
-				"report descriptor.\n");
+		hid_info(hdev, "Fixing up Elecom BM084 report descriptor\n");
 		rdesc[47] = 0x00;
 	}
     return rdesc;
diff --git a/drivers/hid/hid-emsff.c b/drivers/hid/hid-emsff.c
index c61b192..81877c6 100644
--- a/drivers/hid/hid-emsff.c
+++ b/drivers/hid/hid-emsff.c
@@ -68,18 +68,18 @@ static int emsff_init(struct hid_device *hid)
 	int error;
 
 	if (list_empty(report_list)) {
-		dev_err(&hid->dev, "no output reports found\n");
+		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
 	}
 
 	report = list_first_entry(report_list, struct hid_report, list);
 	if (report->maxfield < 1) {
-		dev_err(&hid->dev, "no fields in the report\n");
+		hid_err(hid, "no fields in the report\n");
 		return -ENODEV;
 	}
 
 	if (report->field[0]->report_count < 7) {
-		dev_err(&hid->dev, "not enough values in the field\n");
+		hid_err(hid, "not enough values in the field\n");
 		return -ENODEV;
 	}
 
@@ -105,8 +105,7 @@ static int emsff_init(struct hid_device *hid)
 	emsff->report->field[0]->value[6] = 0x00;
 	usbhid_submit_report(hid, emsff->report, USB_DIR_OUT);
 
-	dev_info(&hid->dev, "force feedback for EMS based devices by "
-	       "Ignaz Forster <ignaz.forster@gmx.de>\n");
+	hid_info(hid, "force feedback for EMS based devices by Ignaz Forster <ignaz.forster@gmx.de>\n");
 
 	return 0;
 }
@@ -117,13 +116,13 @@ static int ems_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err;
 	}
 
diff --git a/drivers/hid/hid-gaff.c b/drivers/hid/hid-gaff.c
index 88dfcf4..279ba53 100644
--- a/drivers/hid/hid-gaff.c
+++ b/drivers/hid/hid-gaff.c
@@ -87,7 +87,7 @@ static int gaff_init(struct hid_device *hid)
 	int error;
 
 	if (list_empty(report_list)) {
-		dev_err(&hid->dev, "no output reports found\n");
+		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
 	}
 
@@ -95,12 +95,12 @@ static int gaff_init(struct hid_device *hid)
 
 	report = list_entry(report_ptr, struct hid_report, list);
 	if (report->maxfield < 1) {
-		dev_err(&hid->dev, "no fields in the report\n");
+		hid_err(hid, "no fields in the report\n");
 		return -ENODEV;
 	}
 
 	if (report->field[0]->report_count < 6) {
-		dev_err(&hid->dev, "not enough values in the field\n");
+		hid_err(hid, "not enough values in the field\n");
 		return -ENODEV;
 	}
 
@@ -128,8 +128,7 @@ static int gaff_init(struct hid_device *hid)
 
 	usbhid_submit_report(hid, gaff->report, USB_DIR_OUT);
 
-	dev_info(&hid->dev, "Force Feedback for GreenAsia 0x12"
-	       " devices by Lukasz Lubojanski <lukasz@lubojanski.info>\n");
+	hid_info(hid, "Force Feedback for GreenAsia 0x12 devices by Lukasz Lubojanski <lukasz@lubojanski.info>\n");
 
 	return 0;
 }
@@ -148,13 +147,13 @@ static int ga_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err;
 	}
 
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 861488a..c075782 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -871,7 +871,7 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 				if (!hidinput || !input_dev) {
 					kfree(hidinput);
 					input_free_device(input_dev);
-					err_hid("Out of memory during hid input probe");
+					hid_err(hid, "Out of memory during hid input probe\n");
 					goto out_unwind;
 				}
 
diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
index 817247e..f2ba9ef 100644
--- a/drivers/hid/hid-kye.c
+++ b/drivers/hid/hid-kye.c
@@ -32,8 +32,8 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		rdesc[65] == 0x29 && rdesc[66] == 0x0f &&
 		rdesc[71] == 0x75 && rdesc[72] == 0x08 &&
 		rdesc[73] == 0x95 && rdesc[74] == 0x01) {
-		dev_info(&hdev->dev, "fixing up Kye/Genius Ergo Mouse report "
-				"descriptor\n");
+		hid_info(hdev,
+			 "fixing up Kye/Genius Ergo Mouse report descriptor\n");
 		rdesc[62] = 0x09;
 		rdesc[64] = 0x04;
 		rdesc[66] = 0x07;
diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index b629fba..aef4104 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -53,23 +53,22 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 	if ((quirks & LG_RDESC) && *rsize >= 90 && rdesc[83] == 0x26 &&
 			rdesc[84] == 0x8c && rdesc[85] == 0x02) {
-		dev_info(&hdev->dev, "fixing up Logitech keyboard report "
-				"descriptor\n");
+		hid_info(hdev,
+			 "fixing up Logitech keyboard report descriptor\n");
 		rdesc[84] = rdesc[89] = 0x4d;
 		rdesc[85] = rdesc[90] = 0x10;
 	}
 	if ((quirks & LG_RDESC_REL_ABS) && *rsize >= 50 &&
 			rdesc[32] == 0x81 && rdesc[33] == 0x06 &&
 			rdesc[49] == 0x81 && rdesc[50] == 0x06) {
-		dev_info(&hdev->dev, "fixing up rel/abs in Logitech "
-				"report descriptor\n");
+		hid_info(hdev,
+			 "fixing up rel/abs in Logitech report descriptor\n");
 		rdesc[33] = rdesc[50] = 0x02;
 	}
 	if ((quirks & LG_FF4) && *rsize >= 101 &&
 			rdesc[41] == 0x95 && rdesc[42] == 0x0B &&
 			rdesc[47] == 0x05 && rdesc[48] == 0x09) {
-		dev_info(&hdev->dev, "fixing up Logitech Speed Force Wireless "
-			"button descriptor\n");
+		hid_info(hdev, "fixing up Logitech Speed Force Wireless button descriptor\n");
 		rdesc[41] = 0x05;
 		rdesc[42] = 0x09;
 		rdesc[47] = 0x95;
@@ -288,7 +287,7 @@ static int lg_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
@@ -297,7 +296,7 @@ static int lg_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_hw_start(hdev, connect_mask);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
diff --git a/drivers/hid/hid-lg2ff.c b/drivers/hid/hid-lg2ff.c
index 4258253..3c31bc6 100644
--- a/drivers/hid/hid-lg2ff.c
+++ b/drivers/hid/hid-lg2ff.c
@@ -72,18 +72,18 @@ int lg2ff_init(struct hid_device *hid)
 	int error;
 
 	if (list_empty(report_list)) {
-		dev_err(&hid->dev, "no output report found\n");
+		hid_err(hid, "no output report found\n");
 		return -ENODEV;
 	}
 
 	report = list_entry(report_list->next, struct hid_report, list);
 
 	if (report->maxfield < 1) {
-		dev_err(&hid->dev, "output report is empty\n");
+		hid_err(hid, "output report is empty\n");
 		return -ENODEV;
 	}
 	if (report->field[0]->report_count < 7) {
-		dev_err(&hid->dev, "not enough values in the field\n");
+		hid_err(hid, "not enough values in the field\n");
 		return -ENODEV;
 	}
 
@@ -110,8 +110,7 @@ int lg2ff_init(struct hid_device *hid)
 
 	usbhid_submit_report(hid, report, USB_DIR_OUT);
 
-	dev_info(&hid->dev, "Force feedback for Logitech RumblePad/Rumblepad 2 by "
-	       "Anssi Hannula <anssi.hannula@gmail.com>\n");
+	hid_info(hid, "Force feedback for Logitech RumblePad/Rumblepad 2 by Anssi Hannula <anssi.hannula@gmail.com>\n");
 
 	return 0;
 }
diff --git a/drivers/hid/hid-lg3ff.c b/drivers/hid/hid-lg3ff.c
index 4002832..f98644c 100644
--- a/drivers/hid/hid-lg3ff.c
+++ b/drivers/hid/hid-lg3ff.c
@@ -141,20 +141,20 @@ int lg3ff_init(struct hid_device *hid)
 
 	/* Find the report to use */
 	if (list_empty(report_list)) {
-		err_hid("No output report found");
+		hid_err(hid, "No output report found\n");
 		return -1;
 	}
 
 	/* Check that the report looks ok */
 	report = list_entry(report_list->next, struct hid_report, list);
 	if (!report) {
-		err_hid("NULL output report");
+		hid_err(hid, "NULL output report\n");
 		return -1;
 	}
 
 	field = report->field[0];
 	if (!field) {
-		err_hid("NULL field");
+		hid_err(hid, "NULL field\n");
 		return -1;
 	}
 
@@ -169,8 +169,7 @@ int lg3ff_init(struct hid_device *hid)
 	if (test_bit(FF_AUTOCENTER, dev->ffbit))
 		dev->ff->set_autocenter = hid_lg3ff_set_autocenter;
 
-	dev_info(&hid->dev, "Force feedback for Logitech Flight System G940 by "
-			"Gary Stein <LordCnidarian@gmail.com>\n");
+	hid_info(hid, "Force feedback for Logitech Flight System G940 by Gary Stein <LordCnidarian@gmail.com>\n");
 	return 0;
 }
 
diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 7eef5a2..fa550c8 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -101,20 +101,20 @@ int lg4ff_init(struct hid_device *hid)
 
 	/* Find the report to use */
 	if (list_empty(report_list)) {
-		err_hid("No output report found");
+		hid_err(hid, "No output report found\n");
 		return -1;
 	}
 
 	/* Check that the report looks ok */
 	report = list_entry(report_list->next, struct hid_report, list);
 	if (!report) {
-		err_hid("NULL output report");
+		hid_err(hid, "NULL output report\n");
 		return -1;
 	}
 
 	field = report->field[0];
 	if (!field) {
-		err_hid("NULL field");
+		hid_err(hid, "NULL field\n");
 		return -1;
 	}
 
@@ -129,8 +129,7 @@ int lg4ff_init(struct hid_device *hid)
 	if (test_bit(FF_AUTOCENTER, dev->ffbit))
 		dev->ff->set_autocenter = hid_lg4ff_set_autocenter;
 
-	dev_info(&hid->dev, "Force feedback for Logitech Speed Force Wireless by "
-			"Simon Wood <simon@mungewell.org>\n");
+	hid_info(hid, "Force feedback for Logitech Speed Force Wireless by Simon Wood <simon@mungewell.org>\n");
 	return 0;
 }
 
diff --git a/drivers/hid/hid-lgff.c b/drivers/hid/hid-lgff.c
index 61142b7..90d0ef2 100644
--- a/drivers/hid/hid-lgff.c
+++ b/drivers/hid/hid-lgff.c
@@ -27,6 +27,8 @@
  * e-mail - mail your message to <johann.deneux@it.uu.se>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/input.h>
 #include <linux/usb.h>
 #include <linux/hid.h>
@@ -146,7 +148,7 @@ int lgff_init(struct hid_device* hid)
 
 	/* Find the report to use */
 	if (list_empty(report_list)) {
-		err_hid("No output report found");
+		hid_err(hid, "No output report found\n");
 		return -1;
 	}
 
@@ -154,7 +156,7 @@ int lgff_init(struct hid_device* hid)
 	report = list_entry(report_list->next, struct hid_report, list);
 	field = report->field[0];
 	if (!field) {
-		err_hid("NULL field");
+		hid_err(hid, "NULL field\n");
 		return -1;
 	}
 
@@ -176,7 +178,7 @@ int lgff_init(struct hid_device* hid)
 	if ( test_bit(FF_AUTOCENTER, dev->ffbit) )
 		dev->ff->set_autocenter = hid_lgff_set_autocenter;
 
-	printk(KERN_INFO "Force feedback for Logitech force feedback devices by Johann Deneux <johann.deneux@it.uu.se>\n");
+	pr_info("Force feedback for Logitech force feedback devices by Johann Deneux <johann.deneux@it.uu.se>\n");
 
 	return 0;
 }
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index e6dc151..11306b3 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -12,6 +12,8 @@
  * any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
@@ -446,7 +448,7 @@ static int magicmouse_probe(struct hid_device *hdev,
 
 	msc = kzalloc(sizeof(*msc), GFP_KERNEL);
 	if (msc == NULL) {
-		dev_err(&hdev->dev, "can't alloc magicmouse descriptor\n");
+		hid_err(hdev, "can't alloc magicmouse descriptor\n");
 		return -ENOMEM;
 	}
 
@@ -459,13 +461,13 @@ static int magicmouse_probe(struct hid_device *hdev,
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "magicmouse hid parse failed\n");
+		hid_err(hdev, "magicmouse hid parse failed\n");
 		goto err_free;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
-		dev_err(&hdev->dev, "magicmouse hw start failed\n");
+		hid_err(hdev, "magicmouse hw start failed\n");
 		goto err_free;
 	}
 
@@ -486,7 +488,7 @@ static int magicmouse_probe(struct hid_device *hdev,
 	}
 
 	if (!report) {
-		dev_err(&hdev->dev, "unable to register touch report\n");
+		hid_err(hdev, "unable to register touch report\n");
 		ret = -ENOMEM;
 		goto err_stop_hw;
 	}
@@ -495,8 +497,7 @@ static int magicmouse_probe(struct hid_device *hdev,
 	ret = hdev->hid_output_raw_report(hdev, feature, sizeof(feature),
 			HID_FEATURE_REPORT);
 	if (ret != sizeof(feature)) {
-		dev_err(&hdev->dev, "unable to request touch data (%d)\n",
-				ret);
+		hid_err(hdev, "unable to request touch data (%d)\n", ret);
 		goto err_stop_hw;
 	}
 
@@ -540,7 +541,7 @@ static int __init magicmouse_init(void)
 
 	ret = hid_register_driver(&magicmouse_driver);
 	if (ret)
-		printk(KERN_ERR "can't register magicmouse driver\n");
+		pr_err("can't register magicmouse driver\n");
 
 	return ret;
 }
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index dc618c3..0f6fc54 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -40,8 +40,7 @@ static __u8 *ms_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 	if ((quirks & MS_RDESC) && *rsize == 571 && rdesc[557] == 0x19 &&
 			rdesc[559] == 0x29) {
-		dev_info(&hdev->dev, "fixing up Microsoft Wireless Receiver "
-				"Model 1028 report descriptor\n");
+		hid_info(hdev, "fixing up Microsoft Wireless Receiver Model 1028 report descriptor\n");
 		rdesc[557] = 0x35;
 		rdesc[559] = 0x45;
 	}
@@ -155,14 +154,14 @@ static int ms_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT | ((quirks & MS_HIDINPUT) ?
 				HID_CONNECT_HIDINPUT_FORCE : 0));
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
diff --git a/drivers/hid/hid-monterey.c b/drivers/hid/hid-monterey.c
index c95c31e..dedf757 100644
--- a/drivers/hid/hid-monterey.c
+++ b/drivers/hid/hid-monterey.c
@@ -26,8 +26,7 @@ static __u8 *mr_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 30 && rdesc[29] == 0x05 && rdesc[30] == 0x09) {
-		dev_info(&hdev->dev, "fixing up button/consumer in HID report "
-				"descriptor\n");
+		hid_info(hdev, "fixing up button/consumer in HID report descriptor\n");
 		rdesc[30] = 0x0c;
 	}
 	return rdesc;
diff --git a/drivers/hid/hid-mosart.c b/drivers/hid/hid-mosart.c
index ac5421d..0668685 100644
--- a/drivers/hid/hid-mosart.c
+++ b/drivers/hid/hid-mosart.c
@@ -199,7 +199,7 @@ static int mosart_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	td = kmalloc(sizeof(struct mosart_data), GFP_KERNEL);
 	if (!td) {
-		dev_err(&hdev->dev, "cannot allocate MosArt data\n");
+		hid_err(hdev, "cannot allocate MosArt data\n");
 		return -ENOMEM;
 	}
 	td->valid = false;
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 69169ef..beb4034 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -130,8 +130,7 @@ static void ntrig_report_version(struct hid_device *hdev)
 	if (ret == 8) {
 		ret = ntrig_version_string(&data[2], buf);
 
-		dev_info(&hdev->dev,
-			 "Firmware version: %s (%02x%02x %02x%02x)\n",
+		hid_info(hdev, "Firmware version: %s (%02x%02x %02x%02x)\n",
 			 buf, data[2], data[3], data[4], data[5]);
 	}
 
@@ -831,7 +830,7 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	nd = kmalloc(sizeof(struct ntrig_data), GFP_KERNEL);
 	if (!nd) {
-		dev_err(&hdev->dev, "cannot allocate N-Trig data\n");
+		hid_err(hdev, "cannot allocate N-Trig data\n");
 		return -ENOMEM;
 	}
 
@@ -850,13 +849,13 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
diff --git a/drivers/hid/hid-ortek.c b/drivers/hid/hid-ortek.c
index 2e79716..e90edfc 100644
--- a/drivers/hid/hid-ortek.c
+++ b/drivers/hid/hid-ortek.c
@@ -23,8 +23,7 @@ static __u8 *ortek_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
 	if (*rsize >= 56 && rdesc[54] == 0x25 && rdesc[55] == 0x01) {
-		dev_info(&hdev->dev, "Fixing up Ortek WKB-2000 "
-				"report descriptor.\n");
+		hid_info(hdev, "Fixing up Ortek WKB-2000 report descriptor\n");
 		rdesc[55] = 0x92;
 	}
 	return rdesc;
diff --git a/drivers/hid/hid-petalynx.c b/drivers/hid/hid-petalynx.c
index 308d6ae..f1ea3ff 100644
--- a/drivers/hid/hid-petalynx.c
+++ b/drivers/hid/hid-petalynx.c
@@ -29,8 +29,7 @@ static __u8 *pl_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	if (*rsize >= 60 && rdesc[39] == 0x2a && rdesc[40] == 0xf5 &&
 			rdesc[41] == 0x00 && rdesc[59] == 0x26 &&
 			rdesc[60] == 0xf9 && rdesc[61] == 0x00) {
-		dev_info(&hdev->dev, "fixing up Petalynx Maxter Remote report "
-				"descriptor\n");
+		hid_info(hdev, "fixing up Petalynx Maxter Remote report descriptor\n");
 		rdesc[60] = 0xfa;
 		rdesc[40] = 0xfa;
 	}
@@ -77,13 +76,13 @@ static int pl_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index 38565fe..e4ce471 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -253,7 +253,7 @@ static struct hid_report *picolcd_report(int id, struct hid_device *hdev, int di
 		if (report->id == id)
 			return report;
 	}
-	dev_warn(&hdev->dev, "No report with id 0x%x found\n", id);
+	hid_warn(hdev, "No report with id 0x%x found\n", id);
 	return NULL;
 }
 
@@ -1329,7 +1329,7 @@ static int picolcd_check_version(struct hid_device *hdev)
 
 	verinfo = picolcd_send_and_wait(hdev, REPORT_VERSION, NULL, 0);
 	if (!verinfo) {
-		dev_err(&hdev->dev, "no version response from PicoLCD");
+		hid_err(hdev, "no version response from PicoLCD\n");
 		return -ENODEV;
 	}
 
@@ -1337,14 +1337,14 @@ static int picolcd_check_version(struct hid_device *hdev)
 		data->version[0] = verinfo->raw_data[1];
 		data->version[1] = verinfo->raw_data[0];
 		if (data->status & PICOLCD_BOOTLOADER) {
-			dev_info(&hdev->dev, "PicoLCD, bootloader version %d.%d\n",
-					verinfo->raw_data[1], verinfo->raw_data[0]);
+			hid_info(hdev, "PicoLCD, bootloader version %d.%d\n",
+				 verinfo->raw_data[1], verinfo->raw_data[0]);
 		} else {
-			dev_info(&hdev->dev, "PicoLCD, firmware version %d.%d\n",
-					verinfo->raw_data[1], verinfo->raw_data[0]);
+			hid_info(hdev, "PicoLCD, firmware version %d.%d\n",
+				 verinfo->raw_data[1], verinfo->raw_data[0]);
 		}
 	} else {
-		dev_err(&hdev->dev, "confused, got unexpected version response from PicoLCD\n");
+		hid_err(hdev, "confused, got unexpected version response from PicoLCD\n");
 		ret = -EINVAL;
 	}
 	kfree(verinfo);
@@ -2328,8 +2328,7 @@ static void picolcd_init_devfs(struct picolcd_data *data,
 			(flash_w ? S_IWUSR : 0) | (flash_r ? S_IRUSR : 0),
 			hdev->debug_dir, data, &picolcd_debug_flash_fops);
 	} else if (flash_r || flash_w)
-		dev_warn(&hdev->dev, "Unexpected FLASH access reports, "
-				"please submit rdesc for review\n");
+		hid_warn(hdev, "Unexpected FLASH access reports, please submit rdesc for review\n");
 }
 
 static void picolcd_exit_devfs(struct picolcd_data *data)
@@ -2457,13 +2456,13 @@ static int picolcd_init_keys(struct picolcd_data *data,
 		return -ENODEV;
 	if (report->maxfield != 1 || report->field[0]->report_count != 2 ||
 			report->field[0]->report_size != 8) {
-		dev_err(&hdev->dev, "unsupported KEY_STATE report");
+		hid_err(hdev, "unsupported KEY_STATE report\n");
 		return -EINVAL;
 	}
 
 	idev = input_allocate_device();
 	if (idev == NULL) {
-		dev_err(&hdev->dev, "failed to allocate input device");
+		hid_err(hdev, "failed to allocate input device\n");
 		return -ENOMEM;
 	}
 	input_set_drvdata(idev, hdev);
@@ -2485,7 +2484,7 @@ static int picolcd_init_keys(struct picolcd_data *data,
 		input_set_capability(idev, EV_KEY, data->keycode[i]);
 	error = input_register_device(idev);
 	if (error) {
-		dev_err(&hdev->dev, "error registering the input device");
+		hid_err(hdev, "error registering the input device\n");
 		input_free_device(idev);
 		return error;
 	}
@@ -2522,9 +2521,8 @@ static int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data *data)
 		return error;
 
 	if (data->version[0] != 0 && data->version[1] != 3)
-		dev_info(&hdev->dev, "Device with untested firmware revision, "
-				"please submit /sys/kernel/debug/hid/%s/rdesc for this device.\n",
-				dev_name(&hdev->dev));
+		hid_info(hdev, "Device with untested firmware revision, please submit /sys/kernel/debug/hid/%s/rdesc for this device.\n",
+			 dev_name(&hdev->dev));
 
 	/* Setup keypad input device */
 	error = picolcd_init_keys(data, picolcd_in_report(REPORT_KEY_STATE, hdev));
@@ -2581,9 +2579,8 @@ static int picolcd_probe_bootloader(struct hid_device *hdev, struct picolcd_data
 		return error;
 
 	if (data->version[0] != 1 && data->version[1] != 0)
-		dev_info(&hdev->dev, "Device with untested bootloader revision, "
-				"please submit /sys/kernel/debug/hid/%s/rdesc for this device.\n",
-				dev_name(&hdev->dev));
+		hid_info(hdev, "Device with untested bootloader revision, please submit /sys/kernel/debug/hid/%s/rdesc for this device.\n",
+			 dev_name(&hdev->dev));
 
 	picolcd_init_devfs(data, NULL, NULL,
 			picolcd_out_report(REPORT_BL_READ_MEMORY, hdev),
@@ -2605,7 +2602,7 @@ static int picolcd_probe(struct hid_device *hdev,
 	 */
 	data = kzalloc(sizeof(struct picolcd_data), GFP_KERNEL);
 	if (data == NULL) {
-		dev_err(&hdev->dev, "can't allocate space for Minibox PicoLCD device data\n");
+		hid_err(hdev, "can't allocate space for Minibox PicoLCD device data\n");
 		error = -ENOMEM;
 		goto err_no_cleanup;
 	}
@@ -2621,7 +2618,7 @@ static int picolcd_probe(struct hid_device *hdev,
 	/* Parse the device reports and start it up */
 	error = hid_parse(hdev);
 	if (error) {
-		dev_err(&hdev->dev, "device report parse failed\n");
+		hid_err(hdev, "device report parse failed\n");
 		goto err_cleanup_data;
 	}
 
@@ -2631,25 +2628,25 @@ static int picolcd_probe(struct hid_device *hdev,
 	error = hid_hw_start(hdev, 0);
 	hdev->claimed = 0;
 	if (error) {
-		dev_err(&hdev->dev, "hardware start failed\n");
+		hid_err(hdev, "hardware start failed\n");
 		goto err_cleanup_data;
 	}
 
 	error = hid_hw_open(hdev);
 	if (error) {
-		dev_err(&hdev->dev, "failed to open input interrupt pipe for key and IR events\n");
+		hid_err(hdev, "failed to open input interrupt pipe for key and IR events\n");
 		goto err_cleanup_hid_hw;
 	}
 
 	error = device_create_file(&hdev->dev, &dev_attr_operation_mode_delay);
 	if (error) {
-		dev_err(&hdev->dev, "failed to create sysfs attributes\n");
+		hid_err(hdev, "failed to create sysfs attributes\n");
 		goto err_cleanup_hid_ll;
 	}
 
 	error = device_create_file(&hdev->dev, &dev_attr_operation_mode);
 	if (error) {
-		dev_err(&hdev->dev, "failed to create sysfs attributes\n");
+		hid_err(hdev, "failed to create sysfs attributes\n");
 		goto err_cleanup_sysfs1;
 	}
 
diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index 9f41e2b..06e5300 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -103,7 +103,7 @@ static int plff_init(struct hid_device *hid)
 	*/
 
 	if (list_empty(report_list)) {
-		dev_err(&hid->dev, "no output reports found\n");
+		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
 	}
 
@@ -112,14 +112,13 @@ static int plff_init(struct hid_device *hid)
 		report_ptr = report_ptr->next;
 
 		if (report_ptr == report_list) {
-			dev_err(&hid->dev, "required output report is "
-					"missing\n");
+			hid_err(hid, "required output report is missing\n");
 			return -ENODEV;
 		}
 
 		report = list_entry(report_ptr, struct hid_report, list);
 		if (report->maxfield < 1) {
-			dev_err(&hid->dev, "no fields in the report\n");
+			hid_err(hid, "no fields in the report\n");
 			return -ENODEV;
 		}
 
@@ -137,7 +136,7 @@ static int plff_init(struct hid_device *hid)
 			weak = &report->field[3]->value[0];
 			debug("detected 4-field device");
 		} else {
-			dev_err(&hid->dev, "not enough fields or values\n");
+			hid_err(hid, "not enough fields or values\n");
 			return -ENODEV;
 		}
 
@@ -164,8 +163,7 @@ static int plff_init(struct hid_device *hid)
 		usbhid_submit_report(hid, plff->report, USB_DIR_OUT);
 	}
 
-	dev_info(&hid->dev, "Force feedback for PantherLord/GreenAsia "
-	       "devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
+	hid_info(hid, "Force feedback for PantherLord/GreenAsia devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
 
 	return 0;
 }
@@ -185,13 +183,13 @@ static int pl_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err;
 	}
 
diff --git a/drivers/hid/hid-prodikeys.c b/drivers/hid/hid-prodikeys.c
index 5f0fa6c..ab19f29 100644
--- a/drivers/hid/hid-prodikeys.c
+++ b/drivers/hid/hid-prodikeys.c
@@ -16,6 +16,8 @@
  * any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/usb.h>
@@ -285,11 +287,11 @@ static int pcmidi_get_output_report(struct pcmidi_snd *pm)
 			continue;
 
 		if (report->maxfield < 1) {
-			dev_err(&hdev->dev, "output report is empty\n");
+			hid_err(hdev, "output report is empty\n");
 			break;
 		}
 		if (report->field[0]->report_count != 2) {
-			dev_err(&hdev->dev, "field count too low\n");
+			hid_err(hdev, "field count too low\n");
 			break;
 		}
 		pm->pcmidi_report6 = report;
@@ -746,8 +748,8 @@ static __u8 *pk_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 	if (*rsize == 178 &&
 	      rdesc[111] == 0x06 && rdesc[112] == 0x00 &&
 	      rdesc[113] == 0xff) {
-		dev_info(&hdev->dev, "fixing up pc-midi keyboard report "
-			"descriptor\n");
+		hid_info(hdev,
+			 "fixing up pc-midi keyboard report descriptor\n");
 
 		rdesc[144] = 0x18; /* report 4: was 0x10 report count */
 	}
@@ -805,7 +807,7 @@ static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	pk = kzalloc(sizeof(*pk), GFP_KERNEL);
 	if (pk == NULL) {
-		dev_err(&hdev->dev, "prodikeys: can't alloc descriptor\n");
+		hid_err(hdev, "can't alloc descriptor\n");
 		return -ENOMEM;
 	}
 
@@ -813,8 +815,7 @@ static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	pm = kzalloc(sizeof(*pm), GFP_KERNEL);
 	if (pm == NULL) {
-		dev_err(&hdev->dev,
-			"prodikeys: can't alloc descriptor\n");
+		hid_err(hdev, "can't alloc descriptor\n");
 		ret = -ENOMEM;
 		goto err_free;
 	}
@@ -827,7 +828,7 @@ static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "prodikeys: hid parse failed\n");
+		hid_err(hdev, "hid parse failed\n");
 		goto err_free;
 	}
 
@@ -837,7 +838,7 @@ static int pk_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
-		dev_err(&hdev->dev, "prodikeys: hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
@@ -896,7 +897,7 @@ static int pk_init(void)
 
 	ret = hid_register_driver(&pk_driver);
 	if (ret)
-		printk(KERN_ERR "can't register prodikeys driver\n");
+		pr_err("can't register prodikeys driver\n");
 
 	return ret;
 }
diff --git a/drivers/hid/hid-quanta.c b/drivers/hid/hid-quanta.c
index 54d3db5..87a54df 100644
--- a/drivers/hid/hid-quanta.c
+++ b/drivers/hid/hid-quanta.c
@@ -195,7 +195,7 @@ static int quanta_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	td = kmalloc(sizeof(struct quanta_data), GFP_KERNEL);
 	if (!td) {
-		dev_err(&hdev->dev, "cannot allocate Quanta Touch data\n");
+		hid_err(hdev, "cannot allocate Quanta Touch data\n");
 		return -ENOMEM;
 	}
 	td->valid = false;
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index f776957..73199de 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -90,8 +90,7 @@ static int kone_check_write(struct usb_device *usb_dev)
 		kfree(data);
 		return 0;
 	} else { /* unknown answer */
-		dev_err(&usb_dev->dev, "got retval %d when checking write\n",
-				*data);
+		hid_err(usb_dev, "got retval %d when checking write\n", *data);
 		kfree(data);
 		return -EIO;
 	}
@@ -556,7 +555,7 @@ static ssize_t kone_sysfs_set_tcu(struct device *dev,
 
 		retval = kone_set_settings(usb_dev, &kone->settings);
 		if (retval) {
-			dev_err(&usb_dev->dev, "couldn't set tcu state\n");
+			hid_err(usb_dev, "couldn't set tcu state\n");
 			/*
 			 * try to reread valid settings into buffer overwriting
 			 * first error code
@@ -570,7 +569,7 @@ static ssize_t kone_sysfs_set_tcu(struct device *dev,
 
 	retval = size;
 exit_no_settings:
-	dev_err(&usb_dev->dev, "couldn't read settings\n");
+	hid_err(usb_dev, "couldn't read settings\n");
 exit_unlock:
 	mutex_unlock(&kone->kone_lock);
 	return retval;
@@ -818,21 +817,20 @@ static int kone_init_specials(struct hid_device *hdev)
 
 		kone = kzalloc(sizeof(*kone), GFP_KERNEL);
 		if (!kone) {
-			dev_err(&hdev->dev, "can't alloc device descriptor\n");
+			hid_err(hdev, "can't alloc device descriptor\n");
 			return -ENOMEM;
 		}
 		hid_set_drvdata(hdev, kone);
 
 		retval = kone_init_kone_device_struct(usb_dev, kone);
 		if (retval) {
-			dev_err(&hdev->dev,
-					"couldn't init struct kone_device\n");
+			hid_err(hdev, "couldn't init struct kone_device\n");
 			goto exit_free;
 		}
 
 		retval = roccat_connect(hdev);
 		if (retval < 0) {
-			dev_err(&hdev->dev, "couldn't init char dev\n");
+			hid_err(hdev, "couldn't init char dev\n");
 			/* be tolerant about not getting chrdev */
 		} else {
 			kone->roccat_claimed = 1;
@@ -841,7 +839,7 @@ static int kone_init_specials(struct hid_device *hdev)
 
 		retval = kone_create_sysfs_attributes(intf);
 		if (retval) {
-			dev_err(&hdev->dev, "cannot create sysfs files\n");
+			hid_err(hdev, "cannot create sysfs files\n");
 			goto exit_free;
 		}
 	} else {
@@ -876,19 +874,19 @@ static int kone_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	retval = hid_parse(hdev);
 	if (retval) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto exit;
 	}
 
 	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (retval) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto exit;
 	}
 
 	retval = kone_init_specials(hdev);
 	if (retval) {
-		dev_err(&hdev->dev, "couldn't install mouse\n");
+		hid_err(hdev, "couldn't install mouse\n");
 		goto exit_stop;
 	}
 
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index 9bf2304..e7b4aff 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -87,9 +87,8 @@ static int pyra_receive_control_status(struct usb_device *usb_dev)
 			control.value == 1)
 			return 0;
 	else {
-		dev_err(&usb_dev->dev, "receive control status: "
-				"unknown response 0x%x 0x%x\n",
-				control.request, control.value);
+		hid_err(usb_dev, "receive control status: unknown response 0x%x 0x%x\n",
+			control.request, control.value);
 		return -EINVAL;
 	}
 }
@@ -770,21 +769,20 @@ static int pyra_init_specials(struct hid_device *hdev)
 
 		pyra = kzalloc(sizeof(*pyra), GFP_KERNEL);
 		if (!pyra) {
-			dev_err(&hdev->dev, "can't alloc device descriptor\n");
+			hid_err(hdev, "can't alloc device descriptor\n");
 			return -ENOMEM;
 		}
 		hid_set_drvdata(hdev, pyra);
 
 		retval = pyra_init_pyra_device_struct(usb_dev, pyra);
 		if (retval) {
-			dev_err(&hdev->dev,
-					"couldn't init struct pyra_device\n");
+			hid_err(hdev, "couldn't init struct pyra_device\n");
 			goto exit_free;
 		}
 
 		retval = roccat_connect(hdev);
 		if (retval < 0) {
-			dev_err(&hdev->dev, "couldn't init char dev\n");
+			hid_err(hdev, "couldn't init char dev\n");
 		} else {
 			pyra->chrdev_minor = retval;
 			pyra->roccat_claimed = 1;
@@ -792,7 +790,7 @@ static int pyra_init_specials(struct hid_device *hdev)
 
 		retval = pyra_create_sysfs_attributes(intf);
 		if (retval) {
-			dev_err(&hdev->dev, "cannot create sysfs files\n");
+			hid_err(hdev, "cannot create sysfs files\n");
 			goto exit_free;
 		}
 	} else {
@@ -826,19 +824,19 @@ static int pyra_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	retval = hid_parse(hdev);
 	if (retval) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto exit;
 	}
 
 	retval = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (retval) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto exit;
 	}
 
 	retval = pyra_init_specials(hdev);
 	if (retval) {
-		dev_err(&hdev->dev, "couldn't install mouse\n");
+		hid_err(hdev, "couldn't install mouse\n");
 		goto exit_stop;
 	}
 	return 0;
diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index a9d9b29..4bc7a93 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -21,6 +21,8 @@
  * It is inspired by hidraw, but uses only one circular buffer for all readers.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/cdev.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
@@ -165,8 +167,7 @@ static int roccat_open(struct inode *inode, struct file *file)
 	mutex_lock(&device->readers_lock);
 
 	if (!device) {
-		printk(KERN_EMERG "roccat device with minor %d doesn't exist\n",
-				minor);
+		pr_emerg("roccat device with minor %d doesn't exist\n", minor);
 		error = -ENODEV;
 		goto exit_err;
 	}
@@ -214,8 +215,7 @@ static int roccat_release(struct inode *inode, struct file *file)
 	device = devices[minor];
 	if (!device) {
 		mutex_unlock(&devices_lock);
-		printk(KERN_EMERG "roccat device with minor %d doesn't exist\n",
-				minor);
+		pr_emerg("roccat device with minor %d doesn't exist\n", minor);
 		return -ENODEV;
 	}
 
@@ -392,7 +392,7 @@ static int __init roccat_init(void)
 	roccat_major = MAJOR(dev_id);
 
 	if (retval < 0) {
-		printk(KERN_WARNING "roccat: can't get major number\n");
+		pr_warn("can't get major number\n");
 		return retval;
 	}
 
diff --git a/drivers/hid/hid-samsung.c b/drivers/hid/hid-samsung.c
index 3589444..3c1fd8a 100644
--- a/drivers/hid/hid-samsung.c
+++ b/drivers/hid/hid-samsung.c
@@ -57,8 +57,8 @@
 static inline void samsung_irda_dev_trace(struct hid_device *hdev,
 		unsigned int rsize)
 {
-	dev_info(&hdev->dev, "fixing up Samsung IrDA %d byte report "
-			"descriptor\n", rsize);
+	hid_info(hdev, "fixing up Samsung IrDA %d byte report descriptor\n",
+		 rsize);
 }
 
 static __u8 *samsung_irda_report_fixup(struct hid_device *hdev, __u8 *rdesc,
@@ -160,7 +160,7 @@ static int samsung_probe(struct hid_device *hdev,
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
@@ -174,7 +174,7 @@ static int samsung_probe(struct hid_device *hdev,
 
 	ret = hid_hw_start(hdev, cmask);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
diff --git a/drivers/hid/hid-sjoy.c b/drivers/hid/hid-sjoy.c
index e10a768..16f7caf 100644
--- a/drivers/hid/hid-sjoy.c
+++ b/drivers/hid/hid-sjoy.c
@@ -74,26 +74,25 @@ static int sjoyff_init(struct hid_device *hid)
 	int error;
 
 	if (list_empty(report_list)) {
-		dev_err(&hid->dev, "no output reports found\n");
+		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
 	}
 
 	report_ptr = report_ptr->next;
 
 	if (report_ptr == report_list) {
-		dev_err(&hid->dev, "required output report is "
-				"missing\n");
+		hid_err(hid, "required output report is missing\n");
 		return -ENODEV;
 	}
 
 	report = list_entry(report_ptr, struct hid_report, list);
 	if (report->maxfield < 1) {
-		dev_err(&hid->dev, "no fields in the report\n");
+		hid_err(hid, "no fields in the report\n");
 		return -ENODEV;
 	}
 
 	if (report->field[0]->report_count < 3) {
-		dev_err(&hid->dev, "not enough values in the field\n");
+		hid_err(hid, "not enough values in the field\n");
 		return -ENODEV;
 	}
 
@@ -117,8 +116,7 @@ static int sjoyff_init(struct hid_device *hid)
 	sjoyff->report->field[0]->value[2] = 0x00;
 	usbhid_submit_report(hid, sjoyff->report, USB_DIR_OUT);
 
-	dev_info(&hid->dev,
-		"Force feedback for SmartJoy PLUS PS2/USB adapter\n");
+	hid_info(hid, "Force feedback for SmartJoy PLUS PS2/USB adapter\n");
 
 	return 0;
 }
@@ -135,13 +133,13 @@ static int sjoy_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err;
 	}
 
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 677bb3d..68d7b36 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -40,8 +40,7 @@ static __u8 *sony_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 
 	if ((sc->quirks & VAIO_RDESC_CONSTANT) &&
 			*rsize >= 56 && rdesc[54] == 0x81 && rdesc[55] == 0x07) {
-		dev_info(&hdev->dev, "Fixing up Sony Vaio VGX report "
-				"descriptor\n");
+		hid_info(hdev, "Fixing up Sony Vaio VGX report descriptor\n");
 		rdesc[55] = 0x06;
 	}
 	return rdesc;
@@ -89,7 +88,7 @@ static int sixaxis_set_operational_usb(struct hid_device *hdev)
 				 (3 << 8) | 0xf2, ifnum, buf, 17,
 				 USB_CTRL_GET_TIMEOUT);
 	if (ret < 0)
-		dev_err(&hdev->dev, "can't set operational mode\n");
+		hid_err(hdev, "can't set operational mode\n");
 
 	kfree(buf);
 
@@ -110,7 +109,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	sc = kzalloc(sizeof(*sc), GFP_KERNEL);
 	if (sc == NULL) {
-		dev_err(&hdev->dev, "can't alloc sony descriptor\n");
+		hid_err(hdev, "can't alloc sony descriptor\n");
 		return -ENOMEM;
 	}
 
@@ -119,14 +118,14 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT |
 			HID_CONNECT_HIDDEV_FORCE);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
diff --git a/drivers/hid/hid-stantum.c b/drivers/hid/hid-stantum.c
index 3171be2..b2be1d1 100644
--- a/drivers/hid/hid-stantum.c
+++ b/drivers/hid/hid-stantum.c
@@ -222,7 +222,7 @@ static int stantum_probe(struct hid_device *hdev,
 
 	sd = kmalloc(sizeof(struct stantum_data), GFP_KERNEL);
 	if (!sd) {
-		dev_err(&hdev->dev, "cannot allocate Stantum data\n");
+		hid_err(hdev, "cannot allocate Stantum data\n");
 		return -ENOMEM;
 	}
 	sd->valid = false;
diff --git a/drivers/hid/hid-sunplus.c b/drivers/hid/hid-sunplus.c
index 164ed56..d484a00 100644
--- a/drivers/hid/hid-sunplus.c
+++ b/drivers/hid/hid-sunplus.c
@@ -27,8 +27,7 @@ static __u8 *sp_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 {
 	if (*rsize >= 107 && rdesc[104] == 0x26 && rdesc[105] == 0x80 &&
 			rdesc[106] == 0x03) {
-		dev_info(&hdev->dev, "fixing up Sunplus Wireless Desktop "
-				"report descriptor\n");
+		hid_info(hdev, "fixing up Sunplus Wireless Desktop report descriptor\n");
 		rdesc[105] = rdesc[110] = 0x03;
 		rdesc[106] = rdesc[111] = 0x21;
 	}
diff --git a/drivers/hid/hid-tmff.c b/drivers/hid/hid-tmff.c
index 25be4e1..575862b 100644
--- a/drivers/hid/hid-tmff.c
+++ b/drivers/hid/hid-tmff.c
@@ -151,28 +151,23 @@ static int tmff_init(struct hid_device *hid, const signed short *ff_bits)
 			switch (field->usage[0].hid) {
 			case THRUSTMASTER_USAGE_FF:
 				if (field->report_count < 2) {
-					dev_warn(&hid->dev, "ignoring FF field "
-						"with report_count < 2\n");
+					hid_warn(hid, "ignoring FF field with report_count < 2\n");
 					continue;
 				}
 
 				if (field->logical_maximum ==
 						field->logical_minimum) {
-					dev_warn(&hid->dev, "ignoring FF field "
-							"with logical_maximum "
-							"== logical_minimum\n");
+					hid_warn(hid, "ignoring FF field with logical_maximum == logical_minimum\n");
 					continue;
 				}
 
 				if (tmff->report && tmff->report != report) {
-					dev_warn(&hid->dev, "ignoring FF field "
-							"in other report\n");
+					hid_warn(hid, "ignoring FF field in other report\n");
 					continue;
 				}
 
 				if (tmff->ff_field && tmff->ff_field != field) {
-					dev_warn(&hid->dev, "ignoring "
-							"duplicate FF field\n");
+					hid_warn(hid, "ignoring duplicate FF field\n");
 					continue;
 				}
 
@@ -185,16 +180,15 @@ static int tmff_init(struct hid_device *hid, const signed short *ff_bits)
 				break;
 
 			default:
-				dev_warn(&hid->dev, "ignoring unknown output "
-						"usage %08x\n",
-						field->usage[0].hid);
+				hid_warn(hid, "ignoring unknown output usage %08x\n",
+					 field->usage[0].hid);
 				continue;
 			}
 		}
 	}
 
 	if (!tmff->report) {
-		dev_err(&hid->dev, "can't find FF field in output reports\n");
+		hid_err(hid, "can't find FF field in output reports\n");
 		error = -ENODEV;
 		goto fail;
 	}
@@ -203,8 +197,7 @@ static int tmff_init(struct hid_device *hid, const signed short *ff_bits)
 	if (error)
 		goto fail;
 
-	dev_info(&hid->dev, "force feedback for ThrustMaster devices by Zinx "
-			"Verituse <zinx@epicsol.org>");
+	hid_info(hid, "force feedback for ThrustMaster devices by Zinx Verituse <zinx@epicsol.org>\n");
 	return 0;
 
 fail:
@@ -224,13 +217,13 @@ static int tm_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err;
 	}
 
diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 94caae7..0688832 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -18,6 +18,8 @@
  * any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/device.h>
 #include <linux/hid.h>
 #include <linux/module.h>
@@ -141,8 +143,8 @@ static void wacom_poke(struct hid_device *hdev, u8 speed)
 	 * Note that if the raw queries fail, it's not a hard failure and it
 	 * is safe to continue
 	 */
-	dev_warn(&hdev->dev, "failed to poke device, command %d, err %d\n",
-				rep_data[0], ret);
+	hid_warn(hdev, "failed to poke device, command %d, err %d\n",
+		 rep_data[0], ret);
 	return;
 }
 
@@ -312,7 +314,7 @@ static int wacom_probe(struct hid_device *hdev,
 
 	wdata = kzalloc(sizeof(*wdata), GFP_KERNEL);
 	if (wdata == NULL) {
-		dev_err(&hdev->dev, "can't alloc wacom descriptor\n");
+		hid_err(hdev, "can't alloc wacom descriptor\n");
 		return -ENOMEM;
 	}
 
@@ -321,20 +323,20 @@ static int wacom_probe(struct hid_device *hdev,
 	/* Parse the HID report now */
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
 	ret = device_create_file(&hdev->dev, &dev_attr_speed);
 	if (ret)
-		dev_warn(&hdev->dev,
-			"can't create sysfs speed attribute err: %d\n", ret);
+		hid_warn(hdev,
+			 "can't create sysfs speed attribute err: %d\n", ret);
 
 	/* Set Wacom mode 2 with high reporting speed */
 	wacom_poke(hdev, 1);
@@ -349,8 +351,8 @@ static int wacom_probe(struct hid_device *hdev,
 
 	ret = power_supply_register(&hdev->dev, &wdata->battery);
 	if (ret) {
-		dev_warn(&hdev->dev,
-			"can't create sysfs battery attribute, err: %d\n", ret);
+		hid_warn(hdev, "can't create sysfs battery attribute, err: %d\n",
+			 ret);
 		/*
 		 * battery attribute is not critical for the tablet, but if it
 		 * failed then there is no need to create ac attribute
@@ -367,8 +369,8 @@ static int wacom_probe(struct hid_device *hdev,
 
 	ret = power_supply_register(&hdev->dev, &wdata->ac);
 	if (ret) {
-		dev_warn(&hdev->dev,
-			"can't create ac battery attribute, err: %d\n", ret);
+		hid_warn(hdev,
+			 "can't create ac battery attribute, err: %d\n", ret);
 		/*
 		 * ac attribute is not critical for the tablet, but if it
 		 * failed then we don't want to battery attribute to exist
@@ -454,7 +456,7 @@ static int __init wacom_init(void)
 
 	ret = hid_register_driver(&wacom_driver);
 	if (ret)
-		printk(KERN_ERR "can't register wacom driver\n");
+		pr_err("can't register wacom driver\n");
 	return ret;
 }
 
diff --git a/drivers/hid/hid-zpff.c b/drivers/hid/hid-zpff.c
index b7accea..f31fab0 100644
--- a/drivers/hid/hid-zpff.c
+++ b/drivers/hid/hid-zpff.c
@@ -75,14 +75,14 @@ static int zpff_init(struct hid_device *hid)
 	int error;
 
 	if (list_empty(report_list)) {
-		dev_err(&hid->dev, "no output report found\n");
+		hid_err(hid, "no output report found\n");
 		return -ENODEV;
 	}
 
 	report = list_entry(report_list->next, struct hid_report, list);
 
 	if (report->maxfield < 4) {
-		dev_err(&hid->dev, "not enough fields in report\n");
+		hid_err(hid, "not enough fields in report\n");
 		return -ENODEV;
 	}
 
@@ -105,8 +105,7 @@ static int zpff_init(struct hid_device *hid)
 	zpff->report->field[3]->value[0] = 0x00;
 	usbhid_submit_report(hid, zpff->report, USB_DIR_OUT);
 
-	dev_info(&hid->dev, "force feedback for Zeroplus based devices by "
-	       "Anssi Hannula <anssi.hannula@gmail.com>\n");
+	hid_info(hid, "force feedback for Zeroplus based devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
 
 	return 0;
 }
@@ -123,13 +122,13 @@ static int zp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT & ~HID_CONNECT_FF);
 	if (ret) {
-		dev_err(&hdev->dev, "hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err;
 	}
 
diff --git a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
index aac1f92..e903715 100644
--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -34,9 +34,8 @@ static __u8 *zc_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		rdesc[0x96] == 0xbc && rdesc[0x97] == 0xff &&
 		rdesc[0xca] == 0xbc && rdesc[0xcb] == 0xff &&
 		rdesc[0xe1] == 0xbc && rdesc[0xe2] == 0xff) {
-			dev_info(&hdev->dev,
-				"fixing up zydacron remote control report "
-				"descriptor\n");
+			hid_info(hdev,
+				"fixing up zydacron remote control report descriptor\n");
 			rdesc[0x96] = rdesc[0xca] = rdesc[0xe1] = 0x0c;
 			rdesc[0x97] = rdesc[0xcb] = rdesc[0xe2] = 0x00;
 		}
@@ -172,7 +171,7 @@ static int zc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	zc = kzalloc(sizeof(*zc), GFP_KERNEL);
 	if (zc == NULL) {
-		dev_err(&hdev->dev, "zydacron: can't alloc descriptor\n");
+		hid_err(hdev, "can't alloc descriptor\n");
 		return -ENOMEM;
 	}
 
@@ -180,13 +179,13 @@ static int zc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_parse(hdev);
 	if (ret) {
-		dev_err(&hdev->dev, "zydacron: parse failed\n");
+		hid_err(hdev, "parse failed\n");
 		goto err_free;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
-		dev_err(&hdev->dev, "zydacron: hw start failed\n");
+		hid_err(hdev, "hw start failed\n");
 		goto err_free;
 	}
 
diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
index 93b51eb..68d087f 100644
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -19,6 +19,8 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/errno.h>
@@ -122,15 +124,15 @@ static ssize_t hidraw_write(struct file *file, const char __user *buffer, size_t
 	}
 
 	if (count > HID_MAX_BUFFER_SIZE) {
-		printk(KERN_WARNING "hidraw: pid %d passed too large report\n",
-				task_pid_nr(current));
+		hid_warn(dev, "pid %d passed too large report\n",
+			 task_pid_nr(current));
 		ret = -EINVAL;
 		goto out;
 	}
 
 	if (count < 2) {
-		printk(KERN_WARNING "hidraw: pid %d passed too short report\n",
-				task_pid_nr(current));
+		hid_warn(dev, "pid %d passed too short report\n",
+			 task_pid_nr(current));
 		ret = -EINVAL;
 		goto out;
 	}
@@ -449,7 +451,7 @@ int __init hidraw_init(void)
 	hidraw_major = MAJOR(dev_id);
 
 	if (result < 0) {
-		printk(KERN_WARNING "hidraw: can't get major number\n");
+		pr_warn("can't get major number\n");
 		result = 0;
 		goto out;
 	}
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 5489eab..276758f 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -136,10 +136,10 @@ static void hid_reset(struct work_struct *work)
 			hid_io_error(hid);
 		break;
 	default:
-		err_hid("can't reset device, %s-%s/input%d, status %d",
-				hid_to_usb_dev(hid)->bus->bus_name,
-				hid_to_usb_dev(hid)->devpath,
-				usbhid->ifnum, rc);
+		hid_err(hid, "can't reset device, %s-%s/input%d, status %d\n",
+			hid_to_usb_dev(hid)->bus->bus_name,
+			hid_to_usb_dev(hid)->devpath,
+			usbhid->ifnum, rc);
 		/* FALLTHROUGH */
 	case -EHOSTUNREACH:
 	case -ENODEV:
@@ -278,18 +278,18 @@ static void hid_irq_in(struct urb *urb)
 		hid_io_error(hid);
 		return;
 	default:		/* error */
-		dev_warn(&urb->dev->dev, "input irq status %d  "
-				"received\n", urb->status);
+		hid_warn(urb->dev, "input irq status %d received\n",
+			 urb->status);
 	}
 
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status) {
 		clear_bit(HID_IN_RUNNING, &usbhid->iofl);
 		if (status != -EPERM) {
-			err_hid("can't resubmit intr, %s-%s/input%d, status %d",
-					hid_to_usb_dev(hid)->bus->bus_name,
-					hid_to_usb_dev(hid)->devpath,
-					usbhid->ifnum, status);
+			hid_err(hid, "can't resubmit intr, %s-%s/input%d, status %d\n",
+				hid_to_usb_dev(hid)->bus->bus_name,
+				hid_to_usb_dev(hid)->devpath,
+				usbhid->ifnum, status);
 			hid_io_error(hid);
 		}
 	}
@@ -313,7 +313,7 @@ static int hid_submit_out(struct hid_device *hid)
 		dbg_hid("submitting out urb\n");
 
 		if (usb_submit_urb(usbhid->urbout, GFP_ATOMIC)) {
-			err_hid("usb_submit_urb(out) failed");
+			hid_err(hid, "usb_submit_urb(out) failed\n");
 			return -1;
 		}
 		usbhid->last_out = jiffies;
@@ -375,7 +375,7 @@ static int hid_submit_ctrl(struct hid_device *hid)
 			usbhid->cr->wValue, usbhid->cr->wIndex, usbhid->cr->wLength);
 
 		if (usb_submit_urb(usbhid->urbctrl, GFP_ATOMIC)) {
-			err_hid("usb_submit_urb(ctrl) failed");
+			hid_err(hid, "usb_submit_urb(ctrl) failed\n");
 			return -1;
 		}
 		usbhid->last_ctrl = jiffies;
@@ -413,8 +413,8 @@ static void hid_irq_out(struct urb *urb)
 	case -ENOENT:
 		break;
 	default:		/* error */
-		dev_warn(&urb->dev->dev, "output irq status %d "
-				"received\n", urb->status);
+		hid_warn(urb->dev, "output irq status %d received\n",
+			 urb->status);
 	}
 
 	spin_lock_irqsave(&usbhid->lock, flags);
@@ -466,8 +466,7 @@ static void hid_ctrl(struct urb *urb)
 	case -EPIPE:		/* report not available */
 		break;
 	default:		/* error */
-		dev_warn(&urb->dev->dev, "ctrl urb status %d "
-				"received\n", status);
+		hid_warn(urb->dev, "ctrl urb status %d received\n", status);
 	}
 
 	if (unplug)
@@ -501,13 +500,13 @@ static void __usbhid_submit_report(struct hid_device *hid, struct hid_report *re
 
 	if (usbhid->urbout && dir == USB_DIR_OUT && report->type == HID_OUTPUT_REPORT) {
 		if ((head = (usbhid->outhead + 1) & (HID_OUTPUT_FIFO_SIZE - 1)) == usbhid->outtail) {
-			dev_warn(&hid->dev, "output queue full\n");
+			hid_warn(hid, "output queue full\n");
 			return;
 		}
 
 		usbhid->out[usbhid->outhead].raw_report = kmalloc(len, GFP_ATOMIC);
 		if (!usbhid->out[usbhid->outhead].raw_report) {
-			dev_warn(&hid->dev, "output queueing failed\n");
+			hid_warn(hid, "output queueing failed\n");
 			return;
 		}
 		hid_output_report(report, usbhid->out[usbhid->outhead].raw_report);
@@ -532,14 +531,14 @@ static void __usbhid_submit_report(struct hid_device *hid, struct hid_report *re
 	}
 
 	if ((head = (usbhid->ctrlhead + 1) & (HID_CONTROL_FIFO_SIZE - 1)) == usbhid->ctrltail) {
-		dev_warn(&hid->dev, "control queue full\n");
+		hid_warn(hid, "control queue full\n");
 		return;
 	}
 
 	if (dir == USB_DIR_OUT) {
 		usbhid->ctrl[usbhid->ctrlhead].raw_report = kmalloc(len, GFP_ATOMIC);
 		if (!usbhid->ctrl[usbhid->ctrlhead].raw_report) {
-			dev_warn(&hid->dev, "control queueing failed\n");
+			hid_warn(hid, "control queueing failed\n");
 			return;
 		}
 		hid_output_report(report, usbhid->ctrl[usbhid->ctrlhead].raw_report);
@@ -590,7 +589,7 @@ static int usb_hidinput_input_event(struct input_dev *dev, unsigned int type, un
 		return -1;
 
 	if ((offset = hidinput_find_field(hid, type, code, &field)) == -1) {
-		dev_warn(&dev->dev, "event field not found\n");
+		hid_warn(dev, "event field not found\n");
 		return -1;
 	}
 
@@ -722,7 +721,7 @@ void usbhid_init_reports(struct hid_device *hid)
 	}
 
 	if (err)
-		dev_warn(&hid->dev, "timeout initializing reports\n");
+		hid_warn(hid, "timeout initializing reports\n");
 }
 
 /*
@@ -1140,8 +1139,7 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 		if (usb_endpoint_is_int_in(&interface->endpoint[n].desc))
 			has_in++;
 	if (!has_in) {
-		dev_err(&intf->dev, "couldn't find an input interrupt "
-				"endpoint\n");
+		hid_err(intf, "couldn't find an input interrupt endpoint\n");
 		return -ENODEV;
 	}
 
@@ -1213,7 +1211,7 @@ static int usbhid_probe(struct usb_interface *intf, const struct usb_device_id *
 	ret = hid_add_device(hid);
 	if (ret) {
 		if (ret != -ENODEV)
-			dev_err(&intf->dev, "can't add hid device: %d\n", ret);
+			hid_err(intf, "can't add hid device: %d\n", ret);
 		goto err_free;
 	}
 
diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index ef381d7..f91c136 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -22,7 +22,7 @@
 
 /* #define DEBUG */
 
-#define debug(format, arg...) pr_debug("hid-pidff: " format "\n" , ## arg)
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -220,7 +220,7 @@ static int pidff_rescale_signed(int i, struct hid_field *field)
 static void pidff_set(struct pidff_usage *usage, u16 value)
 {
 	usage->value[0] = pidff_rescale(value, 0xffff, usage->field);
-	debug("calculated from %d to %d", value, usage->value[0]);
+	pr_debug("calculated from %d to %d\n", value, usage->value[0]);
 }
 
 static void pidff_set_signed(struct pidff_usage *usage, s16 value)
@@ -235,7 +235,7 @@ static void pidff_set_signed(struct pidff_usage *usage, s16 value)
 			usage->value[0] =
 			    pidff_rescale(value, 0x7fff, usage->field);
 	}
-	debug("calculated from %d to %d", value, usage->value[0]);
+	pr_debug("calculated from %d to %d\n", value, usage->value[0]);
 }
 
 /*
@@ -259,8 +259,9 @@ static void pidff_set_envelope_report(struct pidff_device *pidff,
 	pidff->set_envelope[PID_ATTACK_TIME].value[0] = envelope->attack_length;
 	pidff->set_envelope[PID_FADE_TIME].value[0] = envelope->fade_length;
 
-	debug("attack %u => %d", envelope->attack_level,
-	      pidff->set_envelope[PID_ATTACK_LEVEL].value[0]);
+	hid_dbg(pidff->hid, "attack %u => %d\n",
+		envelope->attack_level,
+		pidff->set_envelope[PID_ATTACK_LEVEL].value[0]);
 
 	usbhid_submit_report(pidff->hid, pidff->reports[PID_SET_ENVELOPE],
 			  USB_DIR_OUT);
@@ -466,33 +467,33 @@ static int pidff_request_effect_upload(struct pidff_device *pidff, int efnum)
 	pidff->create_new_effect_type->value[0] = efnum;
 	usbhid_submit_report(pidff->hid, pidff->reports[PID_CREATE_NEW_EFFECT],
 			  USB_DIR_OUT);
-	debug("create_new_effect sent, type: %d", efnum);
+	hid_dbg(pidff->hid, "create_new_effect sent, type: %d\n", efnum);
 
 	pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0] = 0;
 	pidff->block_load_status->value[0] = 0;
 	usbhid_wait_io(pidff->hid);
 
 	for (j = 0; j < 60; j++) {
-		debug("pid_block_load requested");
+		hid_dbg(pidff->hid, "pid_block_load requested\n");
 		usbhid_submit_report(pidff->hid, pidff->reports[PID_BLOCK_LOAD],
 				  USB_DIR_IN);
 		usbhid_wait_io(pidff->hid);
 		if (pidff->block_load_status->value[0] ==
 		    pidff->status_id[PID_BLOCK_LOAD_SUCCESS]) {
-			debug("device reported free memory: %d bytes",
-			      pidff->block_load[PID_RAM_POOL_AVAILABLE].value ?
-				pidff->block_load[PID_RAM_POOL_AVAILABLE].value[0] : -1);
+			hid_dbg(pidff->hid, "device reported free memory: %d bytes\n",
+				 pidff->block_load[PID_RAM_POOL_AVAILABLE].value ?
+				 pidff->block_load[PID_RAM_POOL_AVAILABLE].value[0] : -1);
 			return 0;
 		}
 		if (pidff->block_load_status->value[0] ==
 		    pidff->status_id[PID_BLOCK_LOAD_FULL]) {
-			debug("not enough memory free: %d bytes",
-			      pidff->block_load[PID_RAM_POOL_AVAILABLE].value ?
+			hid_dbg(pidff->hid, "not enough memory free: %d bytes\n",
+				pidff->block_load[PID_RAM_POOL_AVAILABLE].value ?
 				pidff->block_load[PID_RAM_POOL_AVAILABLE].value[0] : -1);
 			return -ENOSPC;
 		}
 	}
-	printk(KERN_ERR "hid-pidff: pid_block_load failed 60 times\n");
+	hid_err(pidff->hid, "pid_block_load failed 60 times\n");
 	return -EIO;
 }
 
@@ -546,7 +547,8 @@ static int pidff_erase_effect(struct input_dev *dev, int effect_id)
 	struct pidff_device *pidff = dev->ff->private;
 	int pid_id = pidff->pid_id[effect_id];
 
-	debug("starting to erase %d/%d", effect_id, pidff->pid_id[effect_id]);
+	hid_dbg(pidff->hid, "starting to erase %d/%d\n",
+		effect_id, pidff->pid_id[effect_id]);
 	/* Wait for the queue to clear. We do not want a full fifo to
 	   prevent the effect removal. */
 	usbhid_wait_io(pidff->hid);
@@ -604,8 +606,7 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
 				type_id = PID_SAW_DOWN;
 				break;
 			default:
-				printk(KERN_ERR
-				       "hid-pidff: invalid waveform\n");
+				hid_err(pidff->hid, "invalid waveform\n");
 				return -EINVAL;
 			}
 
@@ -696,7 +697,7 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
 		break;
 
 	default:
-		printk(KERN_ERR "hid-pidff: invalid type\n");
+		hid_err(pidff->hid, "invalid type\n");
 		return -EINVAL;
 	}
 
@@ -704,7 +705,7 @@ static int pidff_upload_effect(struct input_dev *dev, struct ff_effect *effect,
 		pidff->pid_id[effect->id] =
 		    pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0];
 
-	debug("uploaded");
+	hid_dbg(pidff->hid, "uploaded\n");
 
 	return 0;
 }
@@ -770,14 +771,14 @@ static int pidff_find_fields(struct pidff_usage *usage, const u8 *table,
 		for (i = 0; i < report->maxfield; i++) {
 			if (report->field[i]->maxusage !=
 			    report->field[i]->report_count) {
-				debug("maxusage and report_count do not match, "
-				      "skipping");
+				pr_debug("maxusage and report_count do not match, skipping\n");
 				continue;
 			}
 			for (j = 0; j < report->field[i]->maxusage; j++) {
 				if (report->field[i]->usage[j].hid ==
 				    (HID_UP_PID | table[k])) {
-					debug("found %d at %d->%d", k, i, j);
+					pr_debug("found %d at %d->%d\n",
+						 k, i, j);
 					usage[k].field = report->field[i];
 					usage[k].value =
 						&report->field[i]->value[j];
@@ -789,7 +790,7 @@ static int pidff_find_fields(struct pidff_usage *usage, const u8 *table,
 				break;
 		}
 		if (!found && strict) {
-			debug("failed to locate %d", k);
+			pr_debug("failed to locate %d\n", k);
 			return -1;
 		}
 	}
@@ -826,8 +827,8 @@ static void pidff_find_reports(struct hid_device *hid, int report_type,
 			continue;
 		ret = pidff_check_usage(report->field[0]->logical);
 		if (ret != -1) {
-			debug("found usage 0x%02x from field->logical",
-			      pidff_reports[ret]);
+			hid_dbg(hid, "found usage 0x%02x from field->logical\n",
+				pidff_reports[ret]);
 			pidff->reports[ret] = report;
 			continue;
 		}
@@ -845,8 +846,9 @@ static void pidff_find_reports(struct hid_device *hid, int report_type,
 			continue;
 		ret = pidff_check_usage(hid->collection[i - 1].usage);
 		if (ret != -1 && !pidff->reports[ret]) {
-			debug("found usage 0x%02x from collection array",
-			      pidff_reports[ret]);
+			hid_dbg(hid,
+				"found usage 0x%02x from collection array\n",
+				pidff_reports[ret]);
 			pidff->reports[ret] = report;
 		}
 	}
@@ -861,7 +863,7 @@ static int pidff_reports_ok(struct pidff_device *pidff)
 
 	for (i = 0; i <= PID_REQUIRED_REPORTS; i++) {
 		if (!pidff->reports[i]) {
-			debug("%d missing", i);
+			hid_dbg(pidff->hid, "%d missing\n", i);
 			return 0;
 		}
 	}
@@ -884,8 +886,7 @@ static struct hid_field *pidff_find_special_field(struct hid_report *report,
 			    report->field[i]->logical_minimum == 1)
 				return report->field[i];
 			else {
-				printk(KERN_ERR "hid-pidff: logical_minimum "
-					"is not 1 as it should be\n");
+				pr_err("logical_minimum is not 1 as it should be\n");
 				return NULL;
 			}
 		}
@@ -924,7 +925,7 @@ static int pidff_find_special_keys(int *keys, struct hid_field *fld,
  */
 static int pidff_find_special_fields(struct pidff_device *pidff)
 {
-	debug("finding special fields");
+	hid_dbg(pidff->hid, "finding special fields\n");
 
 	pidff->create_new_effect_type =
 		pidff_find_special_field(pidff->reports[PID_CREATE_NEW_EFFECT],
@@ -945,32 +946,30 @@ static int pidff_find_special_fields(struct pidff_device *pidff)
 		pidff_find_special_field(pidff->reports[PID_EFFECT_OPERATION],
 					 0x78, 1);
 
-	debug("search done");
+	hid_dbg(pidff->hid, "search done\n");
 
 	if (!pidff->create_new_effect_type || !pidff->set_effect_type) {
-		printk(KERN_ERR "hid-pidff: effect lists not found\n");
+		hid_err(pidff->hid, "effect lists not found\n");
 		return -1;
 	}
 
 	if (!pidff->effect_direction) {
-		printk(KERN_ERR "hid-pidff: direction field not found\n");
+		hid_err(pidff->hid, "direction field not found\n");
 		return -1;
 	}
 
 	if (!pidff->device_control) {
-		printk(KERN_ERR "hid-pidff: device control field not found\n");
+		hid_err(pidff->hid, "device control field not found\n");
 		return -1;
 	}
 
 	if (!pidff->block_load_status) {
-		printk(KERN_ERR
-		       "hid-pidff: block load status field not found\n");
+		hid_err(pidff->hid, "block load status field not found\n");
 		return -1;
 	}
 
 	if (!pidff->effect_operation_status) {
-		printk(KERN_ERR
-		       "hid-pidff: effect operation field not found\n");
+		hid_err(pidff->hid, "effect operation field not found\n");
 		return -1;
 	}
 
@@ -982,23 +981,22 @@ static int pidff_find_special_fields(struct pidff_device *pidff)
 
 	if (!PIDFF_FIND_SPECIAL_KEYS(type_id, create_new_effect_type,
 				     effect_types)) {
-		printk(KERN_ERR "hid-pidff: no effect types found\n");
+		hid_err(pidff->hid, "no effect types found\n");
 		return -1;
 	}
 
 	if (PIDFF_FIND_SPECIAL_KEYS(status_id, block_load_status,
 				    block_load_status) !=
 			sizeof(pidff_block_load_status)) {
-		printk(KERN_ERR
-		       "hidpidff: block load status identifiers not found\n");
+		hid_err(pidff->hid,
+			"block load status identifiers not found\n");
 		return -1;
 	}
 
 	if (PIDFF_FIND_SPECIAL_KEYS(operation_id, effect_operation_status,
 				    effect_operation_status) !=
 			sizeof(pidff_effect_operation_status)) {
-		printk(KERN_ERR
-		       "hidpidff: effect operation identifiers not found\n");
+		hid_err(pidff->hid, "effect operation identifiers not found\n");
 		return -1;
 	}
 
@@ -1017,8 +1015,8 @@ static int pidff_find_effects(struct pidff_device *pidff,
 		int pidff_type = pidff->type_id[i];
 		if (pidff->set_effect_type->usage[pidff_type].hid !=
 		    pidff->create_new_effect_type->usage[pidff_type].hid) {
-			printk(KERN_ERR "hid-pidff: "
-			       "effect type number %d is invalid\n", i);
+			hid_err(pidff->hid,
+				"effect type number %d is invalid\n", i);
 			return -1;
 		}
 	}
@@ -1073,27 +1071,23 @@ static int pidff_init_fields(struct pidff_device *pidff, struct input_dev *dev)
 	int envelope_ok = 0;
 
 	if (PIDFF_FIND_FIELDS(set_effect, PID_SET_EFFECT, 1)) {
-		printk(KERN_ERR
-		       "hid-pidff: unknown set_effect report layout\n");
+		hid_err(pidff->hid, "unknown set_effect report layout\n");
 		return -ENODEV;
 	}
 
 	PIDFF_FIND_FIELDS(block_load, PID_BLOCK_LOAD, 0);
 	if (!pidff->block_load[PID_EFFECT_BLOCK_INDEX].value) {
-		printk(KERN_ERR
-		       "hid-pidff: unknown pid_block_load report layout\n");
+		hid_err(pidff->hid, "unknown pid_block_load report layout\n");
 		return -ENODEV;
 	}
 
 	if (PIDFF_FIND_FIELDS(effect_operation, PID_EFFECT_OPERATION, 1)) {
-		printk(KERN_ERR
-		       "hid-pidff: unknown effect_operation report layout\n");
+		hid_err(pidff->hid, "unknown effect_operation report layout\n");
 		return -ENODEV;
 	}
 
 	if (PIDFF_FIND_FIELDS(block_free, PID_BLOCK_FREE, 1)) {
-		printk(KERN_ERR
-		       "hid-pidff: unknown pid_block_free report layout\n");
+		hid_err(pidff->hid, "unknown pid_block_free report layout\n");
 		return -ENODEV;
 	}
 
@@ -1105,27 +1099,26 @@ static int pidff_init_fields(struct pidff_device *pidff, struct input_dev *dev)
 
 	if (!envelope_ok) {
 		if (test_and_clear_bit(FF_CONSTANT, dev->ffbit))
-			printk(KERN_WARNING "hid-pidff: "
-			       "has constant effect but no envelope\n");
+			hid_warn(pidff->hid,
+				 "has constant effect but no envelope\n");
 		if (test_and_clear_bit(FF_RAMP, dev->ffbit))
-			printk(KERN_WARNING "hid-pidff: "
-				"has ramp effect but no envelope\n");
+			hid_warn(pidff->hid,
+				 "has ramp effect but no envelope\n");
 
 		if (test_and_clear_bit(FF_PERIODIC, dev->ffbit))
-			printk(KERN_WARNING "hid-pidff: "
-				"has periodic effect but no envelope\n");
+			hid_warn(pidff->hid,
+				 "has periodic effect but no envelope\n");
 	}
 
 	if (test_bit(FF_CONSTANT, dev->ffbit) &&
 	    PIDFF_FIND_FIELDS(set_constant, PID_SET_CONSTANT, 1)) {
-		printk(KERN_WARNING
-		       "hid-pidff: unknown constant effect layout\n");
+		hid_warn(pidff->hid, "unknown constant effect layout\n");
 		clear_bit(FF_CONSTANT, dev->ffbit);
 	}
 
 	if (test_bit(FF_RAMP, dev->ffbit) &&
 	    PIDFF_FIND_FIELDS(set_ramp, PID_SET_RAMP, 1)) {
-		printk(KERN_WARNING "hid-pidff: unknown ramp effect layout\n");
+		hid_warn(pidff->hid, "unknown ramp effect layout\n");
 		clear_bit(FF_RAMP, dev->ffbit);
 	}
 
@@ -1134,8 +1127,7 @@ static int pidff_init_fields(struct pidff_device *pidff, struct input_dev *dev)
 	     test_bit(FF_FRICTION, dev->ffbit) ||
 	     test_bit(FF_INERTIA, dev->ffbit)) &&
 	    PIDFF_FIND_FIELDS(set_condition, PID_SET_CONDITION, 1)) {
-		printk(KERN_WARNING
-		       "hid-pidff: unknown condition effect layout\n");
+		hid_warn(pidff->hid, "unknown condition effect layout\n");
 		clear_bit(FF_SPRING, dev->ffbit);
 		clear_bit(FF_DAMPER, dev->ffbit);
 		clear_bit(FF_FRICTION, dev->ffbit);
@@ -1144,8 +1136,7 @@ static int pidff_init_fields(struct pidff_device *pidff, struct input_dev *dev)
 
 	if (test_bit(FF_PERIODIC, dev->ffbit) &&
 	    PIDFF_FIND_FIELDS(set_periodic, PID_SET_PERIODIC, 1)) {
-		printk(KERN_WARNING
-		       "hid-pidff: unknown periodic effect layout\n");
+		hid_warn(pidff->hid, "unknown periodic effect layout\n");
 		clear_bit(FF_PERIODIC, dev->ffbit);
 	}
 
@@ -1184,12 +1175,12 @@ static void pidff_reset(struct pidff_device *pidff)
 	if (pidff->pool[PID_SIMULTANEOUS_MAX].value) {
 		while (pidff->pool[PID_SIMULTANEOUS_MAX].value[0] < 2) {
 			if (i++ > 20) {
-				printk(KERN_WARNING "hid-pidff: device reports "
-				       "%d simultaneous effects\n",
-				       pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
+				hid_warn(pidff->hid,
+					 "device reports %d simultaneous effects\n",
+					 pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
 				break;
 			}
-			debug("pid_pool requested again");
+			hid_dbg(pidff->hid, "pid_pool requested again\n");
 			usbhid_submit_report(hid, pidff->reports[PID_POOL],
 					  USB_DIR_IN);
 			usbhid_wait_io(hid);
@@ -1215,7 +1206,7 @@ static int pidff_check_autocenter(struct pidff_device *pidff,
 
 	error = pidff_request_effect_upload(pidff, 1);
 	if (error) {
-		printk(KERN_ERR "hid-pidff: upload request failed\n");
+		hid_err(pidff->hid, "upload request failed\n");
 		return error;
 	}
 
@@ -1224,8 +1215,8 @@ static int pidff_check_autocenter(struct pidff_device *pidff,
 		pidff_autocenter(pidff, 0xffff);
 		set_bit(FF_AUTOCENTER, dev->ffbit);
 	} else {
-		printk(KERN_NOTICE "hid-pidff: "
-		       "device has unknown autocenter control method\n");
+		hid_notice(pidff->hid,
+			   "device has unknown autocenter control method\n");
 	}
 
 	pidff_erase_pid(pidff,
@@ -1248,10 +1239,10 @@ int hid_pidff_init(struct hid_device *hid)
 	int max_effects;
 	int error;
 
-	debug("starting pid init");
+	hid_dbg(hid, "starting pid init\n");
 
 	if (list_empty(&hid->report_enum[HID_OUTPUT_REPORT].report_list)) {
-		debug("not a PID device, no output report");
+		hid_dbg(hid, "not a PID device, no output report\n");
 		return -ENODEV;
 	}
 
@@ -1265,7 +1256,7 @@ int hid_pidff_init(struct hid_device *hid)
 	pidff_find_reports(hid, HID_FEATURE_REPORT, pidff);
 
 	if (!pidff_reports_ok(pidff)) {
-		debug("reports not ok, aborting");
+		hid_dbg(hid, "reports not ok, aborting\n");
 		error = -ENODEV;
 		goto fail;
 	}
@@ -1278,8 +1269,8 @@ int hid_pidff_init(struct hid_device *hid)
 
 	if (test_bit(FF_GAIN, dev->ffbit)) {
 		pidff_set(&pidff->device_gain[PID_DEVICE_GAIN_FIELD], 0xffff);
-		usbhid_submit_report(pidff->hid, pidff->reports[PID_DEVICE_GAIN],
-				  USB_DIR_OUT);
+		usbhid_submit_report(hid, pidff->reports[PID_DEVICE_GAIN],
+				     USB_DIR_OUT);
 	}
 
 	error = pidff_check_autocenter(pidff, dev);
@@ -1290,23 +1281,23 @@ int hid_pidff_init(struct hid_device *hid)
 	    pidff->block_load[PID_EFFECT_BLOCK_INDEX].field->logical_maximum -
 	    pidff->block_load[PID_EFFECT_BLOCK_INDEX].field->logical_minimum +
 	    1;
-	debug("max effects is %d", max_effects);
+	hid_dbg(hid, "max effects is %d\n", max_effects);
 
 	if (max_effects > PID_EFFECTS_MAX)
 		max_effects = PID_EFFECTS_MAX;
 
 	if (pidff->pool[PID_SIMULTANEOUS_MAX].value)
-		debug("max simultaneous effects is %d",
-		      pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
+		hid_dbg(hid, "max simultaneous effects is %d\n",
+			pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
 
 	if (pidff->pool[PID_RAM_POOL_SIZE].value)
-		debug("device memory size is %d bytes",
-		      pidff->pool[PID_RAM_POOL_SIZE].value[0]);
+		hid_dbg(hid, "device memory size is %d bytes\n",
+			pidff->pool[PID_RAM_POOL_SIZE].value[0]);
 
 	if (pidff->pool[PID_DEVICE_MANAGED_POOL].value &&
 	    pidff->pool[PID_DEVICE_MANAGED_POOL].value[0] == 0) {
-		printk(KERN_NOTICE "hid-pidff: "
-		       "device does not support device managed pool\n");
+		hid_notice(hid,
+			   "device does not support device managed pool\n");
 		goto fail;
 	}
 
@@ -1322,8 +1313,7 @@ int hid_pidff_init(struct hid_device *hid)
 	ff->set_autocenter = pidff_set_autocenter;
 	ff->playback = pidff_playback;
 
-	printk(KERN_INFO "Force feedback for USB HID PID devices by "
-	       "Anssi Hannula <anssi.hannula@gmail.com>\n");
+	hid_info(dev, "Force feedback for USB HID PID devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
 
 	return 0;
 
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index d099cad..af0a7c1 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -905,7 +905,7 @@ int hiddev_connect(struct hid_device *hid, unsigned int force)
 	hiddev->exist = 1;
 	retval = usb_register_dev(usbhid->intf, &hiddev_class);
 	if (retval) {
-		err_hid("Not able to get a minor for this device.");
+		hid_err(hid, "Not able to get a minor for this device\n");
 		hid->hiddev = NULL;
 		kfree(hiddev);
 		return -1;
diff --git a/drivers/hid/usbhid/usbkbd.c b/drivers/hid/usbhid/usbkbd.c
index a948605..0658173 100644
--- a/drivers/hid/usbhid/usbkbd.c
+++ b/drivers/hid/usbhid/usbkbd.c
@@ -24,6 +24,8 @@
  * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -104,16 +106,18 @@ static void usb_kbd_irq(struct urb *urb)
 			if (usb_kbd_keycode[kbd->old[i]])
 				input_report_key(kbd->dev, usb_kbd_keycode[kbd->old[i]], 0);
 			else
-				dev_info(&urb->dev->dev,
-						"Unknown key (scancode %#x) released.\n", kbd->old[i]);
+				hid_info(urb->dev,
+					 "Unknown key (scancode %#x) released.\n",
+					 kbd->old[i]);
 		}
 
 		if (kbd->new[i] > 3 && memscan(kbd->old + 2, kbd->new[i], 6) == kbd->old + 8) {
 			if (usb_kbd_keycode[kbd->new[i]])
 				input_report_key(kbd->dev, usb_kbd_keycode[kbd->new[i]], 1);
 			else
-				dev_info(&urb->dev->dev,
-						"Unknown key (scancode %#x) released.\n", kbd->new[i]);
+				hid_info(urb->dev,
+					 "Unknown key (scancode %#x) released.\n",
+					 kbd->new[i]);
 		}
 	}
 
@@ -124,9 +128,9 @@ static void usb_kbd_irq(struct urb *urb)
 resubmit:
 	i = usb_submit_urb (urb, GFP_ATOMIC);
 	if (i)
-		err_hid ("can't resubmit intr, %s-%s/input0, status %d",
-				kbd->usbdev->bus->bus_name,
-				kbd->usbdev->devpath, i);
+		hid_err(urb->dev, "can't resubmit intr, %s-%s/input0, status %d",
+			kbd->usbdev->bus->bus_name,
+			kbd->usbdev->devpath, i);
 }
 
 static int usb_kbd_event(struct input_dev *dev, unsigned int type,
@@ -150,7 +154,7 @@ static int usb_kbd_event(struct input_dev *dev, unsigned int type,
 	*(kbd->leds) = kbd->newleds;
 	kbd->led->dev = kbd->usbdev;
 	if (usb_submit_urb(kbd->led, GFP_ATOMIC))
-		err_hid("usb_submit_urb(leds) failed");
+		pr_err("usb_submit_urb(leds) failed\n");
 
 	return 0;
 }
@@ -160,7 +164,7 @@ static void usb_kbd_led(struct urb *urb)
 	struct usb_kbd *kbd = urb->context;
 
 	if (urb->status)
-		dev_warn(&urb->dev->dev, "led urb status %d received\n",
+		hid_warn(urb->dev, "led urb status %d received\n",
 			 urb->status);
 
 	if (*(kbd->leds) == kbd->newleds)
@@ -169,7 +173,7 @@ static void usb_kbd_led(struct urb *urb)
 	*(kbd->leds) = kbd->newleds;
 	kbd->led->dev = kbd->usbdev;
 	if (usb_submit_urb(kbd->led, GFP_ATOMIC))
-		err_hid("usb_submit_urb(leds) failed");
+		hid_err(urb->dev, "usb_submit_urb(leds) failed\n");
 }
 
 static int usb_kbd_open(struct input_dev *dev)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index e2af195..20b9801 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -881,12 +881,32 @@ int hid_pidff_init(struct hid_device *hid);
 #define hid_pidff_init NULL
 #endif
 
-#define dbg_hid(format, arg...) if (hid_debug) \
-				printk(KERN_DEBUG "%s: " format ,\
-				__FILE__ , ## arg)
-#define err_hid(format, arg...) printk(KERN_ERR "%s: " format "\n" , \
-		__FILE__ , ## arg)
-#endif /* HID_FF */
+#define dbg_hid(format, arg...)						\
+do {									\
+	if (hid_debug)							\
+		printk(KERN_DEBUG "%s: " format, __FILE__, ##arg);	\
+} while (0)
+
+#define hid_printk(level, hid, fmt, arg...)		\
+	dev_printk(level, &(hid)->dev, fmt, ##arg)
+#define hid_emerg(hid, fmt, arg...)			\
+	dev_emerg(&(hid)->dev, fmt, ##arg)
+#define hid_crit(hid, fmt, arg...)			\
+	dev_crit(&(hid)->dev, fmt, ##arg)
+#define hid_alert(hid, fmt, arg...)			\
+	dev_alert(&(hid)->dev, fmt, ##arg)
+#define hid_err(hid, fmt, arg...)			\
+	dev_err(&(hid)->dev, fmt, ##arg)
+#define hid_notice(hid, fmt, arg...)			\
+	dev_notice(&(hid)->dev, fmt, ##arg)
+#define hid_warn(hid, fmt, arg...)			\
+	dev_warn(&(hid)->dev, fmt, ##arg)
+#define hid_info(hid, fmt, arg...)			\
+	dev_info(&(hid)->dev, fmt, ##arg)
+#define hid_dbg(hid, fmt, arg...)			\
+	dev_dbg(&(hid)->dev, fmt, ##arg)
+
+#endif /* __KERNEL__ */
 
 #endif
 
-- 
1.7.3.3.464.gf80b6

