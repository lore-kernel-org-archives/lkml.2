Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2DRUHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:07:20 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41630 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2DRUHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:07:18 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/video/mbx/mbxfb.c: correct ioremap_nocache test
Date: Wed, 18 Apr 2012 22:07:11 +0200
Message-Id: <1334779631-4361-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The test tested not the most recently allocated value but a previously
allocated one.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/video/mbx/mbxfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index 55bf619..ab0a8e5 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -950,7 +950,7 @@ static int __devinit mbxfb_probe(struct platform_device *dev)
 
 	mfbi->fb_virt_addr = ioremap_nocache(mfbi->fb_phys_addr,
 					     res_size(mfbi->fb_req));
-	if (!mfbi->reg_virt_addr) {
+	if (!mfbi->fb_virt_addr) {
 		dev_err(&dev->dev, "failed to ioremap frame buffer\n");
 		ret = -EINVAL;
 		goto err4;

