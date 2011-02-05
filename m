Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab1BEOWv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54987 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab1BEOWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EpdAjC0foq4uQoOxnGZQ5mV+DKk+UWfUo/HspZetH9HMx6tg6EeKBqNwMObcncJhhy
         ndK2bDIV74E+lHAOX5CpAu5AaDiP1oGx9OsMnv3VG055rJao55af8XTlzIf28ia4ptgX
         TuyesJdQIY1MahkYpe1/6zZN0QqdO4BPPkcSE=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 42/52] kstrtox: convert drivers/w1/
Date: Sat,  5 Feb 2011 16:20:45 +0200
Message-Id: <1296915654-7458-42-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
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
1.7.3.4

