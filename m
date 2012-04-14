Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2DNAJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 20:09:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:34781 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757400Ab2DNAJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 20:09:31 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+7cYhcWPm7qfqwjbooH6BBq8zy1Yx5TDO1EWBaLw
	Nvj5KfYa8IyX2w
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
Subject: [PATCH 2/2] drm/radeon: Add lock on drm_helper_resume_force_mode
Date: Sat, 14 Apr 2012 02:09:05 +0200
Message-Id: <1334362145-27627-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334362145-27627-1-git-send-email-peterhuewe@gmx.de>
References: <1334362145-27627-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mode_config should be locked when calling drm_helper_resume_force_mode.
This patch adds the lock, similar to #927a2f119.

Cc: stable@kernel.org
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/gpu/drm/radeon/radeon_device.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index ea7df16..d287f23 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -973,7 +973,9 @@ int radeon_resume_kms(struct drm_device *dev)
 	/* reset hpd state */
 	radeon_hpd_init(rdev);
 	/* blat the mode back in */
+	mutex_lock(&dev->mode_config.mutex);
 	drm_helper_resume_force_mode(dev);
+	mutex_unlock(&dev->mode_config.mutex);
 	/* turn on display hw */
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		drm_helper_connector_dpms(connector, DRM_MODE_DPMS_ON);
-- 
1.7.3.4

