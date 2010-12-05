Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0LERvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:51:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab0LERvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:51:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HrTvyMv6u+yGuCLHJBczMzqHVig6jZnQ2Nkfqz75AJu89u+NhfZK4YyKUS1cl/V9Jp
         2KS+aEOUDbMqUuu6v9GusgvjGK4n5aW+S75GqxxSLKuBxrt2eVbISsK8zqoGw7U7uJd6
         S8JZuxVGn/VD1IYy8VsOGE2uuueGaOc7BbY3E=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 20/45] kstrtox: convert drivers/gpu/drm/nouveau/
Date: Sun,  5 Dec 2010 19:49:17 +0200
Message-Id: <1291571382-2719-20-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_pm.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_pm.c b/drivers/gpu/drm/nouveau/nouveau_pm.c
index 9f7b158..a2cdef5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_pm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_pm.c
@@ -315,10 +315,12 @@ nouveau_hwmon_set_max_temp(struct device *d, struct device_attribute *a,
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nouveau_pm_engine *pm = &dev_priv->engine.pm;
 	struct nouveau_pm_threshold_temp *temp = &pm->threshold_temp;
-	long value;
+	int value;
+	int rv;
 
-	if (strict_strtol(buf, 10, &value) == -EINVAL)
-		return count;
+	rv = kstrtoint(buf, 10, &value);
+	if (rv < 0)
+		return rv;
 
 	temp->down_clock = value/1000;
 
@@ -350,10 +352,12 @@ nouveau_hwmon_set_critical_temp(struct device *d, struct device_attribute *a,
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nouveau_pm_engine *pm = &dev_priv->engine.pm;
 	struct nouveau_pm_threshold_temp *temp = &pm->threshold_temp;
-	long value;
+	int value;
+	int rv;
 
-	if (strict_strtol(buf, 10, &value) == -EINVAL)
-		return count;
+	rv = kstrtoint(buf, 10, &value);
+	if (rv < 0)
+		return rv;
 
 	temp->critical = value/1000;
 
-- 
1.7.2.2

