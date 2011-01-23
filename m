Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab1AWKuR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 05:50:17 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:51315
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751678Ab1AWKuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 05:50:16 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Chris Clayton <chris2553@googlemail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Disable high-precision vblank timestamping for UMS
Date: Sun, 23 Jan 2011 10:50:01 +0000
Message-Id: <1295779801-8118-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <201101230932.49998.chris2553@googlemail.com>
References: <201101230932.49998.chris2553@googlemail.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only have sufficient information for accurate (sub-frame) timestamping
when the modesetting is under our control.

Reported-by: Chris Clayton <chris2553@googlemail.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/i915_drv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.c b/drivers/gpu/drm/i915/i915_drv.c
index 59eb19b..66796bb 100644
--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -752,6 +752,9 @@ static int __init i915_init(void)
 		driver.driver_features &= ~DRIVER_MODESET;
 #endif
 
+	if (!(driver.driver_features & DRIVER_MODESET))
+		driver.get_vblank_timestamp = NULL;
+
 	return drm_init(&driver);
 }
 
-- 
1.7.2.3

