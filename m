Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab2HGHCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:02:35 -0400
Received: from www17.your-server.de ([213.133.104.17]:54271 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2HGHCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:02:34 -0400
Subject: [PATCH] nouveau: Use ERR_CAST inlined function instead of
 ERR_PTR(PTR_ERR(.. [1]
From: Thomas Meyer <thomas@m3y3r.de>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 07 Aug 2012 08:57:25 +0200
Message-ID: <1344322645.14513.123.camel@localhost.localdomain>
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/err_cast.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/gpu/drm/nouveau/nouveau_prime.c b/drivers/gpu/drm/nouveau/nouveau_prime.c
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -206,7 +206,7 @@ struct drm_gem_object *nouveau_gem_prime
 	/* need to attach */
 	attach = dma_buf_attach(dma_buf, dev->dev);
 	if (IS_ERR(attach))
-		return ERR_PTR(PTR_ERR(attach));
+		return ERR_CAST(attach);
 
 	sg = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sg)) {
