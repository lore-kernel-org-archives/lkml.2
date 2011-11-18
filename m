Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab1KSAIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:08:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab1KSAIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:08:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:00:05 2011
Message-Id: <20111119000005.200754617@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 15:58:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>,
        Robert Hooker <robert.hooker@canonical.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [14/26] drm/i915: enable ring freq scaling, RC6 and graphics turbo on Ivy Bridge v3
In-Reply-To: <20111119000026.GA6679@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 1c70c0cebd1295a42fec75045b8a6b4419cedef3 upstream.

They use the same register interfaces, so we can simply enable the
existing code on IVB.

v2:
  - resolve conflict with ring freq scaling, we can enable it too
v3:
  - resolve conflict again, this time on drm-intel-next

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Robert Hooker <robert.hooker@canonical.com>
Acked-by: Leann Ogasawara <leann.ogasawara@canonical.com>
Acked-by: Herton Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_debugfs.c  |    2 +-
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -865,7 +865,7 @@ static int i915_cur_delayinfo(struct seq
 			   MEMSTAT_VID_SHIFT);
 		seq_printf(m, "Current P-state: %d\n",
 			   (rgvstat & MEMSTAT_PSTATE_MASK) >> MEMSTAT_PSTATE_SHIFT);
-	} else if (IS_GEN6(dev)) {
+	} else if (IS_GEN6(dev) || IS_GEN7(dev)) {
 		u32 gt_perf_status = I915_READ(GEN6_GT_PERF_STATUS);
 		u32 rp_state_limits = I915_READ(GEN6_RP_STATE_LIMITS);
 		u32 rp_state_cap = I915_READ(GEN6_RP_STATE_CAP);
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7943,7 +7943,7 @@ void intel_modeset_init(struct drm_devic
 		intel_init_emon(dev);
 	}
 
-	if (IS_GEN6(dev))
+	if (IS_GEN6(dev) || IS_GEN7(dev))
 		gen6_enable_rps(dev_priv);
 
 	INIT_WORK(&dev_priv->idle_work, intel_idle_update);
@@ -7985,7 +7985,7 @@ void intel_modeset_cleanup(struct drm_de
 
 	if (IS_IRONLAKE_M(dev))
 		ironlake_disable_drps(dev);
-	if (IS_GEN6(dev))
+	if (IS_GEN6(dev) || IS_GEN7(dev))
 		gen6_disable_rps(dev);
 
 	if (IS_IRONLAKE_M(dev))


