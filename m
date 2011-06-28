Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1F1WE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:04:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35040 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab1F1WEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:04:21 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 04/29] gma500: Set the correct bits according to the pipe
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:03:52 +0100
Message-ID: <20110628220348.898.87885.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Squash a hardcoded assumption we shouldn't really make

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_intel_display.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)


diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 4f47d09..a99271d 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -723,17 +723,18 @@ static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
 	if (is_lvds) {
 		u32 lvds = REG_READ(LVDS);
 
-		lvds |=
-		    LVDS_PORT_EN | LVDS_A0A2_CLKA_POWER_UP |
-		    LVDS_PIPEB_SELECT;
+		lvds &= ~LVDS_PIPEB_SELECT;
+                if (pipe == 1)
+                        lvds |= LVDS_PIPEB_SELECT;
+
+		lvds |= LVDS_PORT_EN | LVDS_A0A2_CLKA_POWER_UP;
 		/* Set the B0-B3 data pairs corresponding to
 		 * whether we're going to
 		 * set the DPLLs for dual-channel mode or not.
 		 */
+		lvds &= ~(LVDS_B0B3_POWER_UP | LVDS_CLKB_POWER_UP);
 		if (clock.p2 == 7)
 			lvds |= LVDS_B0B3_POWER_UP | LVDS_CLKB_POWER_UP;
-		else
-			lvds &= ~(LVDS_B0B3_POWER_UP | LVDS_CLKB_POWER_UP);
 
 		/* It would be nice to set 24 vs 18-bit mode (LVDS_A3_POWER_UP)
 		 * appropriately here, but we need to look more

