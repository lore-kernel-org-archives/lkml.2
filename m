Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab1C3JTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:19:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51185 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932141Ab1C3JTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:19:06 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 09/18] gma500: enable Moorestown CRTC handling
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 30 Mar 2011 10:00:23 +0100
Message-ID: <20110330090019.5897.69690.stgit@localhost.localdomain>
In-Reply-To: <20110330085539.5897.67919.stgit@localhost.localdomain>
References: <20110330085539.5897.67919.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_intel_display.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 92b423d..d24d0bf 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -569,9 +569,7 @@ static int psb_intel_panel_fitter_pipe(struct drm_device *dev)
 	if ((pfit_control & PFIT_ENABLE) == 0)
 		return -1;
 	/* Must be on PIPE 1 for PSB */
-	if (!IS_MRST(dev))
-		return 1;
-	return (pfit_control >> 29) & 3;
+	return 1;
 }
 
 static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
@@ -1395,7 +1393,11 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 	psb_intel_crtc->mode_dev = mode_dev;
 	psb_intel_crtc->cursor_addr = 0;
 
-	drm_crtc_helper_add(&psb_intel_crtc->base,
+	if (IS_MRST(dev))
+        	drm_crtc_helper_add(&psb_intel_crtc->base,
+				    &mrst_helper_funcs);
+	else
+        	drm_crtc_helper_add(&psb_intel_crtc->base,
 				    &psb_intel_helper_funcs);
 
 	/* Setup the array of drm_connector pointer array */

