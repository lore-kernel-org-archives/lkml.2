Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0D1WST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:18:19 -0400
Received: from tex.lwn.net ([70.33.254.29]:48828 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753984Ab0D1WSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:18:10 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 03/30] viafb: Unmap the frame buffer on initialization error
Date: Wed, 28 Apr 2010 16:17:04 -0600
Message-Id: <1272493051-25380-4-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was part of Harald's "make viafb a first-class citizen using
pci_driver" patch, but somehow got dropped when that patch went into
mainline.

Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: ScottFang@viatech.com.cn
Cc: JosephChan@via.com.tw
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/viafbdev.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 8af405b..8955ab4 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1870,7 +1870,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 			printk(KERN_ERR
 			"allocate the second framebuffer struct error\n");
 			rc = -ENOMEM;
-			goto out_delete_i2c;
+			goto out_unmap_screen;
 		}
 		viaparinfo1 = viafbinfo1->par;
 		memcpy(viaparinfo1, viaparinfo, viafb_par_length);
@@ -1961,6 +1961,8 @@ out_dealloc_cmap:
 out_fb1_release:
 	if (viafbinfo1)
 		framebuffer_release(viafbinfo1);
+out_unmap_screen:
+	iounmap(viafbinfo->screen_base);
 out_delete_i2c:
 	viafb_delete_i2c_buss(viaparinfo);
 out_fb_release:
-- 
1.7.0.1

