Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab0DHRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:16:58 -0400
Received: from tex.lwn.net ([70.33.254.29]:46483 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932984Ab0DHRQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:16:52 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       Harald Welte <laforge@gnumonks.org>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 03/16] viafb: Unmap the frame buffer on initialization error
Date: Thu,  8 Apr 2010 11:15:33 -0600
Message-Id: <1270746946-12467-4-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1270746946-12467-1-git-send-email-corbet@lwn.net>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was part of Harald's "make viafb a first-class citizen using
pci_driver" patch, but somehow got dropped when that patch went into
mainline.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/viafbdev.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 91bfe6d..4a34d4f 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1991,7 +1991,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 		if (!viafbinfo1) {
 			printk(KERN_ERR
 			"allocate the second framebuffer struct error\n");
-			goto out_delete_i2c;
+			goto out_unmap_screen;
 		}
 		viaparinfo1 = viafbinfo1->par;
 		memcpy(viaparinfo1, viaparinfo, viafb_par_length);
@@ -2086,6 +2086,8 @@ out_dealloc_cmap:
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

