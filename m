Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0DZTbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:31:33 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51614 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab0DZT2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:32 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 07/19] staging:iio: Clean out unused IIO_SCAN_EL and add IIO_SCAN_NAMED_EL_C
Date: Mon, 26 Apr 2010 20:31:09 +0100
Message-Id: <1272310281-7418-8-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/ring_generic.h |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/iio/ring_generic.h b/drivers/staging/iio/ring_generic.h
index efd385f..c649b6d 100644
--- a/drivers/staging/iio/ring_generic.h
+++ b/drivers/staging/iio/ring_generic.h
@@ -198,25 +198,6 @@ ssize_t iio_scan_el_store(struct device *dev, struct device_attribute *attr,
  **/
 ssize_t iio_scan_el_show(struct device *dev, struct device_attribute *attr,
 			 char *buf);
-/**
- * IIO_SCAN_EL - declare and initialize a scan element without control func
- * @_name:	identifying name. Resulting struct is iio_scan_el_##_name,
- *		sysfs element, scan_en_##_name.
- * @_number:	unique id number for the scan element.
- * @_bits:	number of bits in the scan element result (used in mixed bit
- *		length devices).
- * @_label:	indentification variable used by drivers.  Often a reg address.
- **/
-#define IIO_SCAN_EL(_name, _number, _bits, _label)			\
-	struct iio_scan_el iio_scan_el_##_name = {			\
-		.dev_attr = __ATTR(scan_en_##_name,			\
-				   S_IRUGO | S_IWUSR,			\
-				   iio_scan_el_show,			\
-				   iio_scan_el_store),			\
-		.mask = (1 << _number),					\
-		.bit_count = _bits,					\
-		.label = _label,					\
-	}
 
 ssize_t iio_scan_el_ts_store(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t len);
@@ -227,7 +208,7 @@ ssize_t iio_scan_el_ts_show(struct device *dev, struct device_attribute *attr,
  * IIO_SCAN_EL_C - declare and initialize a scan element with a control func
  *
  * @_name:	identifying name. Resulting struct is iio_scan_el_##_name,
- *		sysfs element, scan_en_##_name.
+ *		sysfs element, _name##_en.
  * @_number:	unique id number for the scan element.
  * @_bits:	number of bits in the scan element result (used in mixed bit
  *		length devices).
@@ -236,7 +217,7 @@ ssize_t iio_scan_el_ts_show(struct device *dev, struct device_attribute *attr,
  **/
 #define IIO_SCAN_EL_C(_name, _number, _bits, _label, _controlfunc)	\
 	struct iio_scan_el iio_scan_el_##_name = {			\
-		.dev_attr = __ATTR(scan_en_##_name,			\
+		.dev_attr = __ATTR(_number##_##_name##_en,		\
 				   S_IRUGO | S_IWUSR,			\
 				   iio_scan_el_show,			\
 				   iio_scan_el_store),			\
@@ -245,6 +226,19 @@ ssize_t iio_scan_el_ts_show(struct device *dev, struct device_attribute *attr,
 		.label = _label,					\
 		.set_state = _controlfunc,				\
 	}
+
+#define IIO_SCAN_NAMED_EL_C(_name, _string, _number, _bits, _label, _cf) \
+	struct iio_scan_el iio_scan_el_##_name = {			\
+		.dev_attr = __ATTR(_number##_##_string##_en,		\
+				   S_IRUGO | S_IWUSR,			\
+				   iio_scan_el_show,			\
+				   iio_scan_el_store),			\
+		.number =  _number,					\
+		.bit_count = _bits,					\
+		.label = _label,					\
+		.set_state = _cf,					\
+	}
+
 /**
  * IIO_SCAN_EL_TIMESTAMP - declare a special scan element for timestamps
  *
-- 
1.6.4.4

