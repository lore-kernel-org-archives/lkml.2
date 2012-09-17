Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2IQAvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33531 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196Ab2IQAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:57 -0400
Message-Id: <20120917003644.446833437@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:37 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 132/135] drm/nouveau: fix booting with plymouth + dumb support
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 610bd7da160f76f1644ecb4cd7f39511b49a22cc upstream.

We noticed a plymouth bug on Fedora 18, and I then
noticed this stupid thinko, fixing it fixed the problem
with plymouth.

Acked-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index 69688ef..7e16dc5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -598,7 +598,7 @@ nouveau_display_dumb_create(struct drm_file *file_priv, struct drm_device *dev,
 	args->size = args->pitch * args->height;
 	args->size = roundup(args->size, PAGE_SIZE);
 
-	ret = nouveau_gem_new(dev, args->size, 0, TTM_PL_FLAG_VRAM, 0, 0, &bo);
+	ret = nouveau_gem_new(dev, args->size, 0, NOUVEAU_GEM_DOMAIN_VRAM, 0, 0, &bo);
 	if (ret)
 		return ret;
 


