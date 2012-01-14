Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab2ANUUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:20:39 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14489 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab2ANUUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:20:38 -0500
Date: Sat, 14 Jan 2012 21:20:37 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: dri-devel@lists.freedesktop.org, Arjan van de Ven <arjan@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH] gpu, drm, sis: Don't return uninitialized variable from
 sis_driver_load()
Message-ID: <alpine.LNX.2.00.1201142117400.11547@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sis_driver_load(), the only use of 'ret' is as the return value
from the function, unfortunately it is never initialized, so the
function just returns garbage when it succeeds.
To fix that, remove the variable and just return 0 directly on success.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/sis/sis_drv.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

 I don't have hardware to test, so it has only been compile tested.

diff --git a/drivers/gpu/drm/sis/sis_drv.c b/drivers/gpu/drm/sis/sis_drv.c
index 06da063..573220c 100644
--- a/drivers/gpu/drm/sis/sis_drv.c
+++ b/drivers/gpu/drm/sis/sis_drv.c
@@ -40,7 +40,6 @@ static struct pci_device_id pciidlist[] = {
 static int sis_driver_load(struct drm_device *dev, unsigned long chipset)
 {
 	drm_sis_private_t *dev_priv;
-	int ret;
 
 	dev_priv = kzalloc(sizeof(drm_sis_private_t), GFP_KERNEL);
 	if (dev_priv == NULL)
@@ -50,7 +49,7 @@ static int sis_driver_load(struct drm_device *dev, unsigned long chipset)
 	dev_priv->chipset = chipset;
 	idr_init(&dev->object_name_idr);
 
-	return ret;
+	return 0;
 }
 
 static int sis_driver_unload(struct drm_device *dev)
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

