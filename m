Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0DZTbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:31:04 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51627 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab0DZT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 11/19] staging:iio: Directory name changes to match new ABI.
Date: Mon, 26 Apr 2010 20:31:13 +0100
Message-Id: <1272310281-7418-12-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-11-git-send-email-jic23@cam.ac.uk>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/chrdev.h            |    2 +-
 drivers/staging/iio/industrialio-core.c |    5 +++--
 drivers/staging/iio/industrialio-ring.c |   13 +++++++++----
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/iio/chrdev.h b/drivers/staging/iio/chrdev.h
index f42bafb..3f96f86 100644
--- a/drivers/staging/iio/chrdev.h
+++ b/drivers/staging/iio/chrdev.h
@@ -94,7 +94,7 @@ struct iio_event_interface {
 	struct iio_chrdev_minor_attr		attr;
 	struct module				*owner;
 	void					*private;
-	char					_name[20];
+	char					_name[35];
 	char					_attrname[20];
 };
 
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 3df23be..3ac3ab5 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -660,8 +660,9 @@ static int iio_device_register_eventset(struct iio_dev *dev_info)
 			dev_info->event_interfaces[i].id = ret;
 
 		snprintf(dev_info->event_interfaces[i]._name, 20,
-			 "event_line%d",
-			dev_info->event_interfaces[i].id);
+			 "%s:event%d",
+			 dev_name(&dev_info->dev),
+			 dev_info->event_interfaces[i].id);
 
 		ret = iio_setup_ev_int(&dev_info->event_interfaces[i],
 				       (const char *)(dev_info
diff --git a/drivers/staging/iio/industrialio-ring.c b/drivers/staging/iio/industrialio-ring.c
index 44d4894..07b996e 100644
--- a/drivers/staging/iio/industrialio-ring.c
+++ b/drivers/staging/iio/industrialio-ring.c
@@ -164,8 +164,9 @@ __iio_request_ring_buffer_event_chrdev(struct iio_ring_buffer *buf,
 	else
 		buf->ev_int.id = ret;
 
-	snprintf(buf->ev_int._name, 20,
-		 "ring_event_line%d",
+	snprintf(buf->ev_int._name, sizeof(buf->ev_int._name),
+		 "%s:event%d",
+		 dev_name(&buf->dev),
 		 buf->ev_int.id);
 	ret = iio_setup_ev_int(&(buf->ev_int),
 			       buf->ev_int._name,
@@ -226,7 +227,9 @@ __iio_request_ring_buffer_access_chrdev(struct iio_ring_buffer *buf,
 		goto error_device_put;
 	else
 		buf->access_id = ret;
-	dev_set_name(&buf->access_dev, "ring_access%d", buf->access_id);
+	dev_set_name(&buf->access_dev, "%s:access%d",
+		     dev_name(&buf->dev),
+		     buf->access_id);
 	ret = device_add(&buf->access_dev);
 	if (ret < 0) {
 		printk(KERN_ERR "failed to add the ring access dev\n");
@@ -278,7 +281,9 @@ int iio_ring_buffer_register(struct iio_ring_buffer *ring)
 	else
 		ring->id = ret;
 
-	dev_set_name(&ring->dev, "ring_buffer%d", ring->id);
+	dev_set_name(&ring->dev, "%s:buffer%d",
+		     dev_name(ring->dev.parent),
+		     ring->id);
 	ret = device_add(&ring->dev);
 	if (ret)
 		goto error_free_id;
-- 
1.6.4.4

