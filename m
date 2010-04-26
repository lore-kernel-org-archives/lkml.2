Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0DZT2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:28:34 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51593 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab0DZT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:30 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 01/19] staging:iio: Add new in_raw definitions for adc channels.
Date: Mon, 26 Apr 2010 20:31:03 +0100
Message-Id: <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/adc/adc.h |   12 ++++++++++++
 drivers/staging/iio/sysfs.h   |    3 +++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/adc/adc.h b/drivers/staging/iio/adc/adc.h
index d925b2c..46f0d08 100644
--- a/drivers/staging/iio/adc/adc.h
+++ b/drivers/staging/iio/adc/adc.h
@@ -9,5 +9,17 @@
  *
  */
 
+/* Deprecated */
 #define IIO_DEV_ATTR_ADC(_num, _show, _addr)			\
   IIO_DEVICE_ATTR(adc_##_num, S_IRUGO, _show, NULL, _addr)
+
+#define IIO_DEV_ATTR_IN_RAW(_num, _show, _addr)				\
+	IIO_DEVICE_ATTR(in##_num##_raw, S_IRUGO, _show, NULL, _addr)
+
+#define IIO_DEV_ATTR_IN_DIFF_RAW(_nump, _numn, _show, _addr)		\
+	IIO_DEVICE_ATTR_NAMED(in##_nump##min##_numn##_raw,		\
+			      in##_nump-in##_numn##_raw,		\
+			      S_IRUGO,					\
+			      _show,					\
+			      NULL,					\
+			      _addr)
diff --git a/drivers/staging/iio/sysfs.h b/drivers/staging/iio/sysfs.h
index e501e13..d8fe0e2 100644
--- a/drivers/staging/iio/sysfs.h
+++ b/drivers/staging/iio/sysfs.h
@@ -98,6 +98,9 @@ struct iio_const_attr {
 	struct iio_dev_attr iio_dev_attr_##_name		\
 	= IIO_ATTR(_name, _mode, _show, _store, _addr)
 
+#define IIO_DEVICE_ATTR_NAMED(_vname, _name, _mode, _show, _store, _addr) \
+	struct iio_dev_attr iio_dev_attr_##_vname			\
+	= IIO_ATTR(_name, _mode, _show, _store, _addr)
 
 #define IIO_DEVICE_ATTR_2(_name, _mode, _show, _store, _addr, _val2)	\
 	struct iio_dev_attr iio_dev_attr_##_name			\
-- 
1.6.4.4

