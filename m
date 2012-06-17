Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab2FQSWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:22:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50105 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757943Ab2FQSWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:12 -0400
Message-Id: <20120617175942.783494860@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Skeggs <bskeggs@redhat.com>
Subject: [ 10/69] drm/nouveau/disp: fix dithering not being enabled on some eDP
 macbooks
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

commit a6a17859f1bdf607650ee055101f54c5f207762b upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
[Maarten Lankhorst backported to 3.2,
 changing nv_connector->type to nv_connector->dcb->type]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -616,7 +616,13 @@
 	if (nv_connector->edid && connector->display_info.bpc)
 		return;
 
-	/* if not, we're out of options unless we're LVDS, default to 8bpc */
+	/* EDID 1.4 is *supposed* to be supported on eDP, but, Apple... */
+	if (nv_connector->dcb->type == DCB_CONNECTOR_eDP) {
+		connector->display_info.bpc = 6;
+		return;
+	}
+
+	/* we're out of options unless we're LVDS, default to 8bpc */
 	if (nv_encoder->dcb->type != OUTPUT_LVDS) {
 		connector->display_info.bpc = 8;
 		return;


