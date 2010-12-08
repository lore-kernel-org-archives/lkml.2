Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab0LHBo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:44:26 -0500
Received: from kroah.org ([198.145.64.141]:48769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022Ab0LHBAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:00:22 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:30 2010
Message-Id: <20101208005730.144084824@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [088/289] drm/i915: diasable clock gating for the panel power sequencer
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 382b09362711d7d03272230a33767015a277926e upstream.

Needed on Ibex Peak and Cougar Point or the panel won't always come on.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    3 +++
 drivers/gpu/drm/i915/intel_display.c |    7 +++++++
 2 files changed, 10 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2726,6 +2726,9 @@
 #define FDI_RXB_CHICKEN         0xc2010
 #define  FDI_RX_PHASE_SYNC_POINTER_ENABLE       (1)
 
+#define SOUTH_DSPCLK_GATE_D	0xc2020
+#define  PCH_DPLSUNIT_CLOCK_GATE_DISABLE (1<<29)
+
 /* CPU: FDI_TX */
 #define FDI_TXA_CTL             0x60100
 #define FDI_TXB_CTL             0x61100
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5674,6 +5674,13 @@ void intel_init_clock_gating(struct drm_
 		I915_WRITE(PCH_DSPCLK_GATE_D, dspclk_gate);
 
 		/*
+		 * On Ibex Peak and Cougar Point, we need to disable clock
+		 * gating for the panel power sequencer or it will fail to
+		 * start up when no ports are active.
+		 */
+		I915_WRITE(SOUTH_DSPCLK_GATE_D, PCH_DPLSUNIT_CLOCK_GATE_DISABLE);
+
+		/*
 		 * According to the spec the following bits should be set in
 		 * order to enable memory self-refresh
 		 * The bit 22/21 of 0x42004


