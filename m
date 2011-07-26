Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab1GZGhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:37:09 -0400
Received: from home.keithp.com ([63.227.221.253]:48652 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab1GZGgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:36:50 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 4/5] drm/i915: Delay 250ms before running the hotplug code
Date: Mon, 25 Jul 2011 23:36:33 -0700
Message-Id: <1311662194-4050-5-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311662194-4050-1-git-send-email-keithp@keithp.com>
References: <1311662194-4050-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the connector is inserted or removed slowly, the hotplug line may
well change state before the data lines do. So, assume the user isn't
trying to fool us and give them 250ms to get the connector plugged or
unplugged.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_irq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 9da2a2c..e3ce1c3 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -306,6 +306,8 @@ static void i915_hotplug_work_func(struct work_struct *work)
 	struct drm_mode_config *mode_config = &dev->mode_config;
 	struct intel_encoder *encoder;
 
+	/* Wait a bit so that the connector change can be completed */
+	msleep(250);
 	mutex_lock(&mode_config->mutex);
 	DRM_DEBUG_KMS("running encoder hotplug functions\n");
 
-- 
1.7.5.4

