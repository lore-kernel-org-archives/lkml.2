Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992990Ab2KOEht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:37:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:48923 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992933Ab2KOELQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 22/66] drm/i915: Only kick out vesafb if we takeover the fbcon with KMS
Date: Wed, 14 Nov 2012 20:10:27 -0800
Message-Id: <20121115040940.616195253@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 1623392af9da983f3ad088a75076c9da05e5600d upstream.

Otherwise we may remove the only console for a nomodeset system.

We became more aggressive in our kicking with
commit e188719a2891f01b3100dca4ae3a055fb5a7ab52
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue Jun 12 11:28:17 2012 +0200

    drm/i915: kick any firmware framebuffers before claiming the gtt

Reported-and-tested-by: monnier@iro.umontreal.ca
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=54615
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_dma.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1484,7 +1484,8 @@ int i915_driver_load(struct drm_device *
 		goto put_gmch;
 	}
 
-	i915_kick_out_firmware_fb(dev_priv);
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		i915_kick_out_firmware_fb(dev_priv);
 
 	pci_set_master(dev->pdev);
 


