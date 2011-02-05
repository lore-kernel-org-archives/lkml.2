Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab1BEO3H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:29:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1BEOVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DttGmUBuo9+oBUVq+Mi/g8NHYZh7VAqOj2MvSWs7H5OXGpgW1u5x8/sOj50CKkpack
         sc0Sf03nzzNZrbqvrixmNbNZdxEymbOXxwa6DaxxW6YoTEFP5r8iYEdVe8o2ufeF4BG4
         xBuKeLOnzgLavtdROV+mSauoC0LnUjZZ/j5Hs=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 17/52] kstrtox: convert drivers/gpio/
Date: Sat,  5 Feb 2011 16:20:20 +0200
Message-Id: <1296915654-7458-17-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/gpio/gpiolib.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 649550e..374775d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -302,7 +302,7 @@ static ssize_t gpio_value_store(struct device *dev,
 	else {
 		long		value;
 
-		status = strict_strtol(buf, 0, &value);
+		status = kstrtol(buf, 0, &value);
 		if (status == 0) {
 			if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
 				value = !value;
@@ -528,7 +528,7 @@ static ssize_t gpio_active_low_store(struct device *dev,
 	} else {
 		long		value;
 
-		status = strict_strtol(buf, 0, &value);
+		status = kstrtol(buf, 0, &value);
 		if (status == 0)
 			status = sysfs_set_active_low(desc, dev, value != 0);
 	}
@@ -606,10 +606,10 @@ static ssize_t export_store(struct class *class,
 				struct class_attribute *attr,
 				const char *buf, size_t len)
 {
-	long	gpio;
+	unsigned int	gpio;
 	int	status;
 
-	status = strict_strtol(buf, 0, &gpio);
+	status = kstrtouint(buf, 0, &gpio);
 	if (status < 0)
 		goto done;
 
@@ -638,10 +638,10 @@ static ssize_t unexport_store(struct class *class,
 				struct class_attribute *attr,
 				const char *buf, size_t len)
 {
-	long	gpio;
+	unsigned int	gpio;
 	int	status;
 
-	status = strict_strtol(buf, 0, &gpio);
+	status = kstrtouint(buf, 0, &gpio);
 	if (status < 0)
 		goto done;
 
-- 
1.7.3.4

