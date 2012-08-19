Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab2HST4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 15:56:45 -0400
Received: from smtpg-pc.aruba.it ([62.149.157.233]:46291 "EHLO
	smtpg-pc.aruba.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2HST4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 15:56:41 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Aug 2012 15:56:41 EDT
From: Michele Ballabio <barra_cuda@katamail.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nouveau: avoid excessive gart aperture for on-board cards
Date: Sun, 19 Aug 2012 21:50:40 +0200
Message-Id: <1345405840-2740-1-git-send-email-barra_cuda@katamail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d0f3c7e41d30859a638083654002b9b6faf7f67b ("drm/nouveau: give a
slightly larger pci(e)gart aperture on all chipsets") removed a test:
that caused an 8x increase in gart aperture, instead of a 2x one, for
on-board cards >= NV_40.

Signed-off-by: Michele Ballabio <barra_cuda@katamail.com>
---

Hi,
	in Linux 3.5.x I experienced some crashes of the X server, and
noticed from the boot that while the gart aperture in 3.4.x was 64MB,
in 3.5.x became 512MB. So I came out with this quick patch: this seems
to work, since X did not crash anymore (and I tried quite hard to),
but I'm not sure if it is the right fix.


 drivers/gpu/drm/nouveau/nouveau_sgdma.c | 2 +-
 1 file modificato, 1 inserzione(+). 1 rimozione(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_sgdma.c b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
index 38483a0..ebc27f7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -341,7 +341,7 @@ nouveau_sgdma_init(struct drm_device *dev)
 	u32 aper_size, align;
 	int ret;
 
-	if (dev_priv->card_type >= NV_40)
+	if (dev_priv->card_type >= NV_40 && pci_is_pcie(dev->pdev))
 		aper_size = 512 * 1024 * 1024;
 	else
 		aper_size = 128 * 1024 * 1024;
-- 
1.7.11.1

