Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab2FOAJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:09:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2FNX7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:00 -0400
Message-Id: <20120614235624.003948267@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Skeggs <bskeggs@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [ 01/42] drm/nouveau/disp: fix dithering not being enabled on some eDP macbooks
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit a6a17859f1bdf607650ee055101f54c5f207762b upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -654,7 +654,13 @@ nouveau_connector_detect_depth(struct dr
 	if (nv_connector->edid && connector->display_info.bpc)
 		return;
 
-	/* if not, we're out of options unless we're LVDS, default to 8bpc */
+	/* EDID 1.4 is *supposed* to be supported on eDP, but, Apple... */
+	if (nv_connector->type == DCB_CONNECTOR_eDP) {
+		connector->display_info.bpc = 6;
+		return;
+	}
+
+	/* we're out of options unless we're LVDS, default to 8bpc */
 	if (nv_encoder->dcb->type != OUTPUT_LVDS) {
 		connector->display_info.bpc = 8;
 		return;


