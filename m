Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1I3BKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:10:13 -0400
Received: from home.keithp.com ([63.227.221.253]:49808 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636Ab1I3BKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:11 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 02/21] drm/i915: Shut down PCH interrupts during irq_uninstall
Date: Thu, 29 Sep 2011 18:09:34 -0700
Message-Id: <1317344993-24945-3-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This masks out all interrupts and ack's any pending ones at IRQ
uninstall time to make sure we don't receive any unexpected interrupts
later on.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_irq.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index c22823b..adeab2a 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -2044,6 +2044,10 @@ static void ironlake_irq_uninstall(struct drm_device *dev)
 	I915_WRITE(GTIMR, 0xffffffff);
 	I915_WRITE(GTIER, 0x0);
 	I915_WRITE(GTIIR, I915_READ(GTIIR));
+
+	I915_WRITE(SDEIMR, 0xffffffff);
+	I915_WRITE(SDEIER, 0x0);
+	I915_WRITE(SDEIIR, I915_READ(SDEIIR));
 }
 
 static void i915_driver_irq_uninstall(struct drm_device * dev)
-- 
1.7.6.3

