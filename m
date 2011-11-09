Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab1KIO3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:29:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40316 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab1KIO3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:29:17 -0500
Subject: [PATCH v2] drm/i915: Prioritize SSC quirk table when determining
 SSC settings
From: Michel Alexandre Salim <salimma@fedoraproject.org>
To: intel-gfx@lists.freedesktop.org
Cc: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 09 Nov 2011 15:29:13 +0100
Organization: Fedora Project
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15)
Content-Transfer-Encoding: 7bit
Message-ID: <1320848955.5081.7.camel@fauix11.informatik.uni-erlangen.de>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ab11cf4b1b28d0abb1db8bc992d016b257489ab5 Mon Sep 17 00:00:00 2001
From: Michel Alexandre Salim <salimma@fedoraproject.org>
Date: Wed, 9 Nov 2011 14:18:45 +0100
Subject: [PATCH] drm/i915: Prioritize SSC quirk table when determining SSC settings

Commit 72bbe58cd9568c7766cc219a779ea68a02132797 makes the check against
the quirk table unreachable if i915_panel_use_ssc is set. This patch
reorders the tests so that the quirk table is checked first, the
i915_panel_use_ssc next and the original per-device setting last.

Signed-off-by: Michel Alexandre Salim <salimma@fedoraproject.org>
---
 drivers/gpu/drm/i915/intel_display.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 981b1f1..23a05bb 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4660,10 +4660,11 @@ static void intel_update_watermarks(struct drm_device *dev)
 
 static inline bool intel_panel_use_ssc(struct drm_i915_private *dev_priv)
 {
+	if (dev_priv->quirks & QUIRK_LVDS_SSC_DISABLE)
+		return false;
 	if (i915_panel_use_ssc >= 0)
 		return i915_panel_use_ssc != 0;
-	return dev_priv->lvds_use_ssc
-		&& !(dev_priv->quirks & QUIRK_LVDS_SSC_DISABLE);
+	return dev_priv->lvds_use_ssc;
 }
 
 /**
-- 
1.7.6.4



