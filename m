Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1BEOVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54987 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1BEOVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=niKt7P16SSfkjAc2dJZDt5PU0G/ngmwfcGrFltqMpIOTemxLncDSgXFbUmkyiZkUkQ
         u5qG7TAju3W/nuURb+vRjHF+mE4mi+sdC7cG7peCf2x0sJpXcdwYboxUoCteSdKu26HA
         OuRFCbnZiGsFXUGr8JUeirgD709/Pw1mWch7g=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 18/52] kstrtox: convert drivers/gpu/drm/nouveau/
Date: Sat,  5 Feb 2011 16:20:21 +0200
Message-Id: <1296915654-7458-18-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_pm.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_pm.c b/drivers/gpu/drm/nouveau/nouveau_pm.c
index f05c0cd..9fb5b6e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_pm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_pm.c
@@ -319,10 +319,12 @@ nouveau_hwmon_set_max_temp(struct device *d, struct device_attribute *a,
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
 
@@ -354,10 +356,12 @@ nouveau_hwmon_set_critical_temp(struct device *d, struct device_attribute *a,
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
1.7.3.4

