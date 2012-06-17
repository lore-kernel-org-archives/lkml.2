Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab2FQSWj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:22:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50104 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757941Ab2FQSWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:12 -0400
Message-Id: <20120617175942.645547568@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Skeggs <bskeggs@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 09/69] drm/nouveau: default to 8bpc for non-LVDS panels if EDID isnt
 useful
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit c8435362f2211086b34ce871fa9c3fcc7ca79ff9 upstream.

A few reports of bad behaviour since the autodetection defaulted to 6bpc,
lets fix this.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 8f510fd..fa86035 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -654,10 +654,13 @@ nouveau_connector_detect_depth(struct drm_connector *connector)
 	if (nv_connector->edid && connector->display_info.bpc)
 		return;
 
-	/* if not, we're out of options unless we're LVDS, default to 6bpc */
-	connector->display_info.bpc = 6;
-	if (nv_encoder->dcb->type != OUTPUT_LVDS)
+	/* if not, we're out of options unless we're LVDS, default to 8bpc */
+	if (nv_encoder->dcb->type != OUTPUT_LVDS) {
+		connector->display_info.bpc = 8;
 		return;
+	}
+
+	connector->display_info.bpc = 6;
 
 	/* LVDS: panel straps */
 	if (bios->fp_no_ddc) {


