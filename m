Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab0LERv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:51:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab0LERvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QEXvppTwrAPcj2BukAZOO7B0mcZDjkIhq7l4J7MhJkhLWLHJ2Gd+HBmkBJAdVdKLrF
         g88Kbem+lFDZ39208eeuOus1bl2Vglb23W7uiabdNaYrx85JWBK1hXTMiymEbvQAz1wg
         l/iscvodaHbVyVjPUJSbVp94ncCubYvYWRDNc=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 37/45] kstrtox: convert drivers/regulator/
Date: Sun,  5 Dec 2010 19:49:34 +0200
Message-Id: <1291571382-2719-37-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
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
1.7.2.2

