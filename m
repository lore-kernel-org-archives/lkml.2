Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2FKRK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 13:10:29 -0400
Received: from smarthost02.digicable.hu ([94.21.128.7]:47755 "EHLO
	smarthost02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab2FKRK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 13:10:26 -0400
Message-ID: <4FD62645.6090501@freemail.hu>
Date: Mon, 11 Jun 2012 19:09:25 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        dri-devel@lists.freedesktop.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm sis: initialize object_idr
References: <4FD5142B.2080809@freemail.hu> <20120611071713.GA4695@phenom.ffwll.local>
In-Reply-To: <20120611071713.GA4695@phenom.ffwll.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 188.143.106.138
X-Original: 92.249.128.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The filed object_idr of struct drm_sis_private was introduced with
commit http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=6de8a748881f1cd9d795454da2b6db616d5ca3d7 .

The idr_init(&dev->object_name_idr) is called instead of
idr_init(&dev_priv->object_idr) by mistake, leaving object_idr
uninitialized. Correct this.

This patch was not tested because of lack of hardware.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
---
diff --git a/drivers/gpu/drm/sis/sis_drv.c b/drivers/gpu/drm/sis/sis_drv.c
index 30d98d1..dd14cd1 100644
--- a/drivers/gpu/drm/sis/sis_drv.c
+++ b/drivers/gpu/drm/sis/sis_drv.c
@@ -47,9 +47,9 @@ static int sis_driver_load(struct drm_device *dev, unsigned long chipset)
 	if (dev_priv == NULL)
 		return -ENOMEM;

+	idr_init(&dev_priv->object_idr);
 	dev->dev_private = (void *)dev_priv;
 	dev_priv->chipset = chipset;
-	idr_init(&dev->object_name_idr);

 	return 0;
 }
