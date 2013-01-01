Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3AAL2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 06:28:00 -0500
Received: from mail.active-venture.com ([67.228.131.205]:62174 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3AAL15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 06:27:57 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Tue, 01 Jan 2013 05:27:56 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Dave Airlie <airlied@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH v2/RESEND] drm: nouveau: Fix build warning seen if HWMON is undefined
Date: Tue,  1 Jan 2013 03:28:00 -0800
Message-Id: <1357039680-19436-1-git-send-email-linux@roeck-us.net>
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

Introduced by commit 095f979a (drm/nouveau/pm: fix build with HWMON off) which
fixed a build error but introduced a build warning.

Cc: Dave Airlie <airlied@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Improved explanation
    Added Cc:

 drivers/gpu/drm/nouveau/nouveau_pm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_pm.c b/drivers/gpu/drm/nouveau/nouveau_pm.c
index 5566172..a701ff5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_pm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_pm.c
@@ -698,10 +698,10 @@ static int
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

