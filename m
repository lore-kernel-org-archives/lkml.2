Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab1GMV3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:29:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59840 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab1GMV3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:29:47 -0400
From: Sergei Trofimovich <slyfox@gentoo.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH] tusb6010_omap: fix build failure: error: 'musb' undeclared
Date: Thu, 14 Jul 2011 00:29:38 +0300
Message-Id: <1310592578-31194-1-git-send-email-slyfox@gentoo.org>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      drivers/usb/musb/tusb6010_omap.o
drivers/usb/musb/tusb6010_omap.c: In function 'tusb_omap_use_shared_dmareq':
drivers/usb/musb/tusb6010_omap.c:92: error: 'musb' undeclared (first use in this function)
drivers/usb/musb/tusb6010_omap.c:92: error: (Each undeclared identifier is reported only once
drivers/usb/musb/tusb6010_omap.c:92: error: for each function it appears in.)

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 drivers/usb/musb/tusb6010_omap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/tusb6010_omap.c b/drivers/usb/musb/tusb6010_omap.c
index c784e6c..07c8a73 100644
--- a/drivers/usb/musb/tusb6010_omap.c
+++ b/drivers/usb/musb/tusb6010_omap.c
@@ -89,7 +89,7 @@ static inline int tusb_omap_use_shared_dmareq(struct tusb_omap_dma_ch *chdat)
 	u32		reg = musb_readl(chdat->tbase, TUSB_DMA_EP_MAP);
 
 	if (reg != 0) {
-		dev_dbg(musb->controller, "ep%i dmareq0 is busy for ep%i\n",
+		dev_dbg(chdat->musb->controller, "ep%i dmareq0 is busy for ep%i\n",
 			chdat->epnum, reg & 0xf);
 		return -EAGAIN;
 	}
-- 
1.7.3.4

