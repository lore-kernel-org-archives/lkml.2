Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2HVXtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:49:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55130 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2HVXtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:49:49 -0400
Date: Wed, 22 Aug 2012 16:49:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Rob Clark <rob@ti.com>, Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] omapdrm: use alloc_ordered_workqueue() instead of UNBOUND
 w/ max_active = 1
Message-ID: <20120822234944.GS19212@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an equivalent conversion and will ease scheduled removal of
WQ_NON_REENTRANT.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/staging/omapdrm/omap_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_drv.c b/drivers/staging/omapdrm/omap_drv.c
index 4beab94..672cb3a 100644
--- a/drivers/staging/omapdrm/omap_drv.c
+++ b/drivers/staging/omapdrm/omap_drv.c
@@ -571,8 +571,7 @@ static int dev_load(struct drm_device *dev, unsigned long flags)
 
 	dev->dev_private = priv;
 
-	priv->wq = alloc_workqueue("omapdrm",
-			WQ_UNBOUND | WQ_NON_REENTRANT, 1);
+	priv->wq = alloc_ordered_workqueue("omapdrm", 0);
 
 	INIT_LIST_HEAD(&priv->obj_list);
 
