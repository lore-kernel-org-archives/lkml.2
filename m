Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab2LMOFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:05:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44294 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab2LMOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        linux-graphics-maintainer@vmware.com, Dave Airlie <airlied@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 070/241] drm/vmwgfx: Fix hibernation device reset
Date: Thu, 13 Dec 2012 11:57:15 -0200
Message-Id: <1355407206-17100-71-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 95e8f6a21996c4cc2c4574b231c6e858b749dce3 upstream.

The device would not reset properly when resuming from hibernation.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Brian Paul <brianp@vmware.com>
Reviewed-by: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-graphics-maintainer@vmware.com
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 3a4b15a..db50604 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -1102,6 +1102,11 @@ static void vmw_pm_complete(struct device *kdev)
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	struct vmw_private *dev_priv = vmw_priv(dev);
 
+	mutex_lock(&dev_priv->hw_mutex);
+	vmw_write(dev_priv, SVGA_REG_ID, SVGA_ID_2);
+	(void) vmw_read(dev_priv, SVGA_REG_ID);
+	mutex_unlock(&dev_priv->hw_mutex);
+
 	/**
 	 * Reclaim 3d reference held by fbdev and potentially
 	 * start fifo.
-- 
1.7.9.5

