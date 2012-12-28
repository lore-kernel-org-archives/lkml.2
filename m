Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab2L1Tpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:45:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55209 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754679Ab2L1TSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:18:10 -0500
Message-Id: <20121228190355.199905673@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>
Subject: [ 119/173] drm/i915: drop unnecessary check from fdi_link_train code
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 8f5718a6d9a29bf1f51910c6b32bd0244f905303 upstream.

They are all written for a specific north disaplay->pch combination.
So stop pretending otherwise.

Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 2b63859..25a3ed6 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2490,11 +2490,9 @@ static void ironlake_fdi_link_train(struct drm_crtc *crtc)
 	udelay(150);
 
 	/* Ironlake workaround, enable clock pointer after FDI enable*/
-	if (HAS_PCH_IBX(dev)) {
-		I915_WRITE(FDI_RX_CHICKEN(pipe), FDI_RX_PHASE_SYNC_POINTER_OVR);
-		I915_WRITE(FDI_RX_CHICKEN(pipe), FDI_RX_PHASE_SYNC_POINTER_OVR |
-			   FDI_RX_PHASE_SYNC_POINTER_EN);
-	}
+	I915_WRITE(FDI_RX_CHICKEN(pipe), FDI_RX_PHASE_SYNC_POINTER_OVR);
+	I915_WRITE(FDI_RX_CHICKEN(pipe), FDI_RX_PHASE_SYNC_POINTER_OVR |
+		   FDI_RX_PHASE_SYNC_POINTER_EN);
 
 	reg = FDI_RX_IIR(pipe);
 	for (tries = 0; tries < 5; tries++) {
@@ -2600,8 +2598,7 @@ static void gen6_fdi_link_train(struct drm_crtc *crtc)
 	POSTING_READ(reg);
 	udelay(150);
 
-	if (HAS_PCH_CPT(dev))
-		cpt_phase_pointer_enable(dev, pipe);
+	cpt_phase_pointer_enable(dev, pipe);
 
 	for (i = 0; i < 4; i++) {
 		reg = FDI_TX_CTL(pipe);
@@ -2735,8 +2732,7 @@ static void ivb_manual_fdi_link_train(struct drm_crtc *crtc)
 	POSTING_READ(reg);
 	udelay(150);
 
-	if (HAS_PCH_CPT(dev))
-		cpt_phase_pointer_enable(dev, pipe);
+	cpt_phase_pointer_enable(dev, pipe);
 
 	for (i = 0; i < 4; i++) {
 		reg = FDI_TX_CTL(pipe);


