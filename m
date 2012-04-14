Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2DNAJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 20:09:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34360 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754270Ab2DNAJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 20:09:15 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19Za29rJ2RZI1lTFH129WDzIS/jn9EalH8UIKBujB
	y8pOJk8lC8m9gR
From: Peter Huewe <peterhuewe@gmx.de>
To: David Airlie <airlied@linux.ie>
Cc: Ben Skeggs <bskeggs@redhat.com>, Maxim Levitsky <maximlevitsky@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
        stable@kernel.org
Subject: [PATCH 1/2] drm/nouveau: Add lock on drm_helper_resume_force_mode
Date: Sat, 14 Apr 2012 02:09:04 +0200
Message-Id: <1334362145-27627-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mode_config should be locked when calling drm_helper_resume_force_mode.
This patch adds the lock, similar to #927a2f119.

Cc: stable@kernel.org
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/gpu/drm/nouveau/nouveau_drv.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index 4f2030b..6260abe 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -375,7 +375,9 @@ nouveau_pci_resume(struct pci_dev *pdev)
 		nv_crtc->lut.depth = 0;
 	}
 
+	mutex_lock(&dev->mode_config.mutex);
 	drm_helper_resume_force_mode(dev);
+	mutex_unlock(&dev->mode_config.mutex);
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
 		struct nouveau_crtc *nv_crtc = nouveau_crtc(crtc);
-- 
1.7.3.4

