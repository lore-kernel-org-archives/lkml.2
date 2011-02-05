Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1BEOWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab1BEOWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=efzfGcXtwzsz0KbhjxjCT41MoG1YmqNVF5cN/4/NIM6c+aVccZl7kj21S9Vua5hLnn
         FFvhANV0rkcjq5inu+7LzostBqsqLxMN/kVvnAWXjc4jkVlDZr6Fjt2efBTyP9H6+I3c
         WKt6yyNa2LgUQ0Kli1jc0YxLS3Y/TEciS8rl8=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 37/52] kstrtox: convert drivers/scsi/
Date: Sat,  5 Feb 2011 16:20:40 +0200
Message-Id: <1296915654-7458-37-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/pmcraid.c    |    2 +-
 drivers/scsi/scsi_sysfs.c |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 321cf3a..504022a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4213,7 +4213,7 @@ static ssize_t pmcraid_store_log_level(
 	struct pmcraid_instance *pinstance;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
+	if (kstrtoul(buf, 10, &val))
 		return -EINVAL;
 	/* log-level should be from 0 to 2 */
 	if (val > 2)
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 490ce21..f929326 100644
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
1.7.3.4

