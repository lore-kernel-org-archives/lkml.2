Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0C0Vsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 17:48:46 -0400
Received: from mout5.freenet.de ([195.4.92.95]:32855 "EHLO mout5.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab0C0Vsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 17:48:45 -0400
From: Karsten Wiese <fzuuzf@googlemail.com>
To: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>
Subject: [RFC PATCH] drm/i915: Don't touch PORT_HOTPLUG_EN in intel_dp_detect()
Date: Sat, 27 Mar 2010 22:48:33 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.x86_64; KDE/4.3.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003272248.34294.fzuuzf@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PORT_HOTPLUG_EN has allready been setup in i915_driver_irq_postinstall(),
when intel_dp_detect() runs.

Delete the DP[BCD]_HOTPLUG_INT_EN defines, they are not referenced anymore.

I found this while searching for a fix for
        https://bugzilla.redhat.com/show_bug.cgi?id=528312

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
---
See also 
"drm/i915: only enable hotplug for detected outputs"
b01f2c3a4a37d09a47ad73ccbb46d554d21cfeb0

 drivers/gpu/drm/i915/i915_reg.h |    3 ---
 drivers/gpu/drm/i915/intel_dp.c |   10 ----------
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index ab1bd2d..92f440d 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -854,11 +854,8 @@
 /* Hotplug control (945+ only) */
 #define PORT_HOTPLUG_EN                0x61110
 #define   HDMIB_HOTPLUG_INT_EN                 (1 << 29)
-#define   DPB_HOTPLUG_INT_EN                   (1 << 29)
 #define   HDMIC_HOTPLUG_INT_EN                 (1 << 28)
-#define   DPC_HOTPLUG_INT_EN                   (1 << 28)
 #define   HDMID_HOTPLUG_INT_EN                 (1 << 27)
-#define   DPD_HOTPLUG_INT_EN                   (1 << 27)
 #define   SDVOB_HOTPLUG_INT_EN                 (1 << 26)
 #define   SDVOC_HOTPLUG_INT_EN                 (1 << 25)
 #define   TV_HOTPLUG_INT_EN                    (1 << 18)
diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 439506c..7a3b5c8 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1179,16 +1179,6 @@ intel_dp_detect(struct drm_connector *connector)
        if (IS_IRONLAKE(dev))
                return ironlake_dp_detect(connector);

-       temp = I915_READ(PORT_HOTPLUG_EN);
-
-       I915_WRITE(PORT_HOTPLUG_EN,
-              temp |
-              DPB_HOTPLUG_INT_EN |
-              DPC_HOTPLUG_INT_EN |
-              DPD_HOTPLUG_INT_EN);
-
-       POSTING_READ(PORT_HOTPLUG_EN);
-
        switch (dp_priv->output_reg) {
        case DP_B:
                bit = DPB_HOTPLUG_INT_STATUS;
--
