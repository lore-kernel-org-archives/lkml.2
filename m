Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab0LERwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:52:05 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab0LERv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N2Fe0wYCRgswvd4SLeQvzF6G5sp5u7t8n4OdjapRXvaJUw8+nDYiaRwJ2yHaGASyx1
         hseNMC0V9g95QAXXK8NVKh4KCSF536qaGZEtRCQwk4dxgYQnDXyubnV/fGtaGkIzIU3y
         yOk3c6Guzat5cPLt724qbS/zQY/BCzSbfaVIU=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 39/45] kstrtox: convert drivers/scsi/
Date: Sun,  5 Dec 2010 19:49:36 +0200
Message-Id: <1291571382-2719-39-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/pmcraid.c    |    2 +-
 drivers/scsi/scsi_sysfs.c |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 5e76a62..3957c63 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4217,7 +4217,7 @@ static ssize_t pmcraid_store_log_level(
 	struct pmcraid_instance *pinstance;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
+	if (kstrtoul(buf, 10, &val))
 		return -EINVAL;
 	/* log-level should be from 0 to 2 */
 	if (val > 2)
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 76ee2e7..04d99c3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -757,11 +757,12 @@ sdev_store_queue_ramp_up_period(struct device *dev,
 				const char *buf, size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	unsigned long period;
-
-	if (strict_strtoul(buf, 10, &period))
-		return -EINVAL;
+	unsigned int period;
+	int rv;
 
+	rv = kstrtouint(buf, 10, &period);
+	if (rv < 0)
+		return rv;
 	sdev->queue_ramp_up_period = msecs_to_jiffies(period);
 	return period;
 }
-- 
1.7.2.2

