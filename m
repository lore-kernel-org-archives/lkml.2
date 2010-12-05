Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab0LERye (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:54:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab0LERvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BgPbkpKsfMy7JCppmbO85Xn7Ua+PO7nR0SCdmWIuIeWUF3fXnPsLOSlzlCdD9QVwsL
         wwMg5MVdHg1jJO7zIOIZxhg08w7NfiuQVLc9/2AcXouX9Od8DeZxMs0M0fF8i4Q+tnhy
         J5CQE5GllsPcTU7UPjyubmj17rCAfQhAtC7Oc=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 19/45] kstrtox: convert drivers/gpio/
Date: Sun,  5 Dec 2010 19:49:16 +0200
Message-Id: <1291571382-2719-19-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/gpio/gpiolib.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 21da9c1..0eb79d9 100644
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
1.7.2.2

