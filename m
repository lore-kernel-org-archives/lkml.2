Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab1BEOWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab1BEOWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=l/uecBMshLnuryrEh8lV+6pAoASeZk1Me710eiBqS+JawQ+niC5jcIKnTjJ43ljwML
         wn2C00FcANKiSq0hwR0sGXXKmhG+A4EBtIbmrLGrmuBb2JrVmY/f/9Dtor/1yKQ6ju8A
         dvOH/uyP3RLcCYE9m50T1LQW8ZVNfxJJIP4Nk=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 35/52] kstrtox: convert drivers/regulator/
Date: Sat,  5 Feb 2011 16:20:38 +0200
Message-Id: <1296915654-7458-35-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/regulator/virtual.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index 69e550f..6e3eee2 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -118,10 +118,12 @@ static ssize_t set_min_uV(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
 	struct virtual_consumer_data *data = dev_get_drvdata(dev);
-	long val;
+	int val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) != 0)
-		return count;
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 
@@ -144,10 +146,12 @@ static ssize_t set_max_uV(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
 	struct virtual_consumer_data *data = dev_get_drvdata(dev);
-	long val;
+	int val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) != 0)
-		return count;
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 
@@ -170,10 +174,12 @@ static ssize_t set_min_uA(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
 	struct virtual_consumer_data *data = dev_get_drvdata(dev);
-	long val;
+	int val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) != 0)
-		return count;
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 
@@ -196,10 +202,12 @@ static ssize_t set_max_uA(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t count)
 {
 	struct virtual_consumer_data *data = dev_get_drvdata(dev);
-	long val;
+	int val;
+	int rv;
 
-	if (strict_strtol(buf, 10, &val) != 0)
-		return count;
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	mutex_lock(&data->lock);
 
-- 
1.7.3.4

