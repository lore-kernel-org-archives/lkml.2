Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab0LERwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:52:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385Ab0LERwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OaaT7i1VA8ypolpqKRYf3i/LaJAazb+K+x7R1iYNm2JId+bS3OcvvTB1JDp6v/L+96
         j5gxWXeip9c6ywF3Qf5K3EC1m3F8BrZZDpHGDnmio/EsXsYGQ50KhKBFXlfigfCnIhGP
         JDs12n4+5FXWw6JIwZJN+BeuKa/vzhAO+4GbQ=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 43/45] kstrtox: convert drivers/w1/
Date: Sun,  5 Dec 2010 19:49:40 +0200
Message-Id: <1291571382-2719-43-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/w1/w1.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index b7b5014..cd3d308 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -233,10 +233,10 @@ static ssize_t w1_master_attribute_store_search(struct device * dev,
 						struct device_attribute *attr,
 						const char * buf, size_t count)
 {
-	long tmp;
 	struct w1_master *md = dev_to_w1_master(dev);
+	int tmp;
 
-	if (strict_strtol(buf, 0, &tmp) == -EINVAL)
+	if (kstrtoint(buf, 0, &tmp) < 0)
 		return -EINVAL;
 
 	mutex_lock(&md->mutex);
@@ -265,10 +265,10 @@ static ssize_t w1_master_attribute_store_pullup(struct device *dev,
 						struct device_attribute *attr,
 						const char *buf, size_t count)
 {
-	long tmp;
 	struct w1_master *md = dev_to_w1_master(dev);
+	int tmp;
 
-	if (strict_strtol(buf, 0, &tmp) == -EINVAL)
+	if (kstrtoint(buf, 0, &tmp) < 0)
 		return -EINVAL;
 
 	mutex_lock(&md->mutex);
-- 
1.7.2.2

