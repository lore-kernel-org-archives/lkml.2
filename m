Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992873Ab2KOEmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:42:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:48682 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992813Ab2KOEKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:10:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>, Dmitry Torokhov <dtor@vmware.com>,
        Dave Airlie <airlied@redhat.com>, linux-graphics-maintainer@vmware.com
Subject: [ 33/38] drm/vmwgfx: Fix hibernation device reset
Date: Wed, 14 Nov 2012 20:10:30 -0800
Message-Id: <20121115040934.922457234@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040932.918082372@linuxfoundation.org>
References: <20121115040932.918082372@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit 95e8f6a21996c4cc2c4574b231c6e858b749dce3 upstream.

The device would not reset properly when resuming from hibernation.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Brian Paul <brianp@vmware.com>
Reviewed-by: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-graphics-maintainer@vmware.com
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -858,6 +858,11 @@ static void vmw_pm_complete(struct devic
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


