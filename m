Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab0DZT2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:28:47 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51649 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab0DZT2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:34 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 18/19] staging:iio:tsl2563 add a name attribute under the iio
Date: Mon, 26 Apr 2010 20:31:20 +0100
Message-Id: <1272310281-7418-19-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-18-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-8-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-9-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-10-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-11-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-12-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-13-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-14-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-15-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-16-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-17-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-18-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/light/tsl2563.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
index 911c898..da3d51c 100644
--- a/drivers/staging/iio/light/tsl2563.c
+++ b/drivers/staging/iio/light/tsl2563.c
@@ -598,12 +598,24 @@ static DEVICE_ATTR(calib0, S_IRUGO | S_IWUSR,
 static DEVICE_ATTR(calib1, S_IRUGO | S_IWUSR,
 		   tsl2563_calib1_show, tsl2563_calib1_store);
 
+static ssize_t tsl2563_show_name(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct tsl2563_chip *chip = indio_dev->dev_data;
+	return sprintf(buf, "%s\n", chip->client->name);
+}
+
+DEVICE_ATTR(name, S_IRUGO, tsl2563_show_name, NULL);
+
 static struct attribute *tsl2563_attributes[] = {
 	&dev_attr_adc0.attr,
 	&dev_attr_adc1.attr,
 	&dev_attr_illuminance0_input.attr,
 	&dev_attr_calib0.attr,
 	&dev_attr_calib1.attr,
+	&dev_attr_name.attr,
 	NULL
 };
 
-- 
1.6.4.4

