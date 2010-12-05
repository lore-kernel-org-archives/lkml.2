Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab0LERvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:51:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362Ab0LERvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=n3A1/OVXACY9CkeR+iEUPjmBSSAEUIruE63bkkSxrarsBXL9RbkEdn5kpAUvVYauSL
         YWBpwBHVjbmevv3CXVoI+UhLXF4tpE9WJIuMv+l0rYYMPvrZ4N9p1M8zuy3A/N8NJtDu
         /VYlMoyIduI3831RvlZDXQJkhx5aRtSaCWne4=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 35/45] kstrtox: convert drivers/platform/x86/
Date: Sun,  5 Dec 2010 19:49:32 +0200
Message-Id: <1291571382-2719-35-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/platform/x86/classmate-laptop.c |    2 +-
 drivers/platform/x86/compal-laptop.c    |   14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index 341cbfe..07d7ce6 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -198,7 +198,7 @@ static ssize_t cmpc_accel_sensitivity_store(struct device *dev,
 	inputdev = dev_get_drvdata(&acpi->dev);
 	accel = dev_get_drvdata(&inputdev->dev);
 
-	r = strict_strtoul(buf, 0, &sensitivity);
+	r = kstrtoul(buf, 0, &sensitivity);
 	if (r)
 		return r;
 
diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 097083c..c4602a4 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -421,13 +421,12 @@ static ssize_t pwm_enable_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct compal_data *data = dev_get_drvdata(dev);
-	long val;
+	unsigned int val;
 	int err;
-	err = strict_strtol(buf, 10, &val);
+
+	err = kstrtouint(buf, 10, &val);
 	if (err)
 		return err;
-	if (val < 0)
-		return -EINVAL;
 
 	data->pwm_enable = val;
 
@@ -459,13 +458,12 @@ static ssize_t pwm_store(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct compal_data *data = dev_get_drvdata(dev);
-	long val;
+	u8 val;
 	int err;
-	err = strict_strtol(buf, 10, &val);
+
+	err = kstrtou8(buf, 10, &val);
 	if (err)
 		return err;
-	if (val < 0 || val > 255)
-		return -EINVAL;
 
 	data->curr_pwm = val;
 
-- 
1.7.2.2

