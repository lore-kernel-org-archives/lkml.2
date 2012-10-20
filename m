Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2JTKdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 06:33:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61038 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab2JTKdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 06:33:06 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: David Airlie <airlied@linux.ie>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drm: fb: cma: Fail gracefully on allocation failure
Date: Sat, 20 Oct 2012 12:32:47 +0200
Message-Id: <1350729172-12506-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350729172-12506-1-git-send-email-thierry.reding@avionic-design.de>
References: <1350729172-12506-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:sXdiJE8S0F3OM8x7OgyV9Tn+R24RipFjsjKrec1P7wS
 C/jWGD4azYJvFxQUvBZaa5txTmfPOZ5Qrvg79VEbvvQAdWht5f
 Eo7duB0c9FytbWbDHEcSBZ/9S0ODBlx2J0xS5VcRddAQgKIQNI
 mDOCqmbG6XHHiu27h/XT/G9/XhKv2VkC6ETzF3xEnyG4Bnt3Tz
 OgEzjsoRvctPgAPzSbFHWRsMlyaIknI5QJjEq7Imx4qTtR0rjS
 CSNEC5zyL6C8myHxkqtKRn/yq1qFOCKn6LCUJ30yRJIvOF5IVq
 MNAmvVMmFF8cpSehZDD/00Kw4mlWDrAFKfMVAqJOYJA8lsAQWT
 xDddwGb0SXLKVcE4wT81IeB4AoJG6u0XdFHyG6e49wdZkIGRZr
 jV5OjB8DT18+3dfIUnazOcJG6dSIcnzBeEN9zWzdhI/sGB2sS9
 0B0rV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drm_gem_cma_create() function never returns NULL but rather an error
encoded in the return value using the ERR_PTR() macro. Callers therefore
need to check for errors using the IS_ERR() macro. This change allows
drivers to handle contiguous DMA allocation failures gracefully.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/gpu/drm/drm_fb_cma_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fb_cma_helper.c b/drivers/gpu/drm/drm_fb_cma_helper.c
index d6c80a3..fd9d0af 100644
--- a/drivers/gpu/drm/drm_fb_cma_helper.c
+++ b/drivers/gpu/drm/drm_fb_cma_helper.c
@@ -220,7 +220,7 @@ static int drm_fbdev_cma_create(struct drm_fb_helper *helper,
 
 	size = mode_cmd.pitches[0] * mode_cmd.height;
 	obj = drm_gem_cma_create(dev, size);
-	if (!obj)
+	if (IS_ERR(obj))
 		return -ENOMEM;
 
 	fbi = framebuffer_alloc(0, dev->dev);
-- 
1.7.12.4

