Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0KHXTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:19:53 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19043 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0KHXTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:19:52 -0500
Date: Tue, 9 Nov 2010 00:08:25 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Subject: [PATCH 03/17][trivial] GPU DRM: Remove unnecessary casts of void
 ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082314420.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from drivers/gpu/drm/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drm_sman.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_sman.c b/drivers/gpu/drm/drm_sman.c
index 463aed9..3466458 100644
--- a/drivers/gpu/drm/drm_sman.c
+++ b/drivers/gpu/drm/drm_sman.c
@@ -59,9 +59,7 @@ drm_sman_init(struct drm_sman * sman, unsigned int num_managers,
 {
 	int ret = 0;
 
-	sman->mm = (struct drm_sman_mm *) kcalloc(num_managers,
-						  sizeof(*sman->mm),
-						  GFP_KERNEL);
+	sman->mm = kcalloc(num_managers, sizeof(*sman->mm), GFP_KERNEL);
 	if (!sman->mm) {
 		ret = -ENOMEM;
 		goto out;



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

