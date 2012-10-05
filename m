Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab2JEP6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:58:51 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54880 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab2JEP6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:58:49 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Fri, 05 Oct 2012 10:58:48 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] drm: nouveau: Fix build warning seen is HWMON is undefined
Date: Fri,  5 Oct 2012 08:59:07 -0700
Message-Id: <1349452747-4334-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:

nouveau_pm.c: In function ‘nouveau_hwmon_init’:
nouveau_pm.c:703:24: warning: unused variable ‘therm’ [-Wunused-variable]

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
This was seen in the latest upstream kernel.

 drivers/gpu/drm/nouveau/nouveau_pm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_pm.c b/drivers/gpu/drm/nouveau/nouveau_pm.c
index 0bf64c9..90dc63e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_pm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_pm.c
@@ -699,10 +699,10 @@ static int
 nouveau_hwmon_init(struct drm_device *dev)
 {
 	struct nouveau_pm *pm = nouveau_pm(dev);
-	struct nouveau_drm *drm = nouveau_drm(dev);
-	struct nouveau_therm *therm = nouveau_therm(drm->device);
 
 #if defined(CONFIG_HWMON) || (defined(MODULE) && defined(CONFIG_HWMON_MODULE))
+	struct nouveau_drm *drm = nouveau_drm(dev);
+	struct nouveau_therm *therm = nouveau_therm(drm->device);
 	struct device *hwmon_dev;
 	int ret = 0;
 
-- 
1.7.9.7

