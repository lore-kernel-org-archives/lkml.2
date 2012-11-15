Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767634Ab2KOEQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:16:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:50095 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993403Ab2KOENN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:13:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Brian Paul <brianp@vmware.com>, Dmitry Torokhov <dtor@vmware.com>,
        Dave Airlie <airlied@redhat.com>, linux-graphics-maintainer@vmware.com
Subject: [ 50/57] drm/vmwgfx: Fix hibernation device reset
Date: Wed, 14 Nov 2012 20:11:58 -0800
Message-Id: <20121115040936.215059445@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1102,6 +1102,11 @@ static void vmw_pm_complete(struct devic
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


