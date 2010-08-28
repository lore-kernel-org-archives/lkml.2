Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0H1Plo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:41:44 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42057 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab0H1PlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:41:19 -0400
From: Julia Lawall <julia@diku.dk>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Cc: kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] drivers/usb/gadget: Remove double test
Date: Sat, 28 Aug 2010 17:41:01 +0200
Message-Id: <1283010066-20935-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283010066-20935-1-git-send-email-julia@diku.dk>
References: <1283010066-20935-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same expression is tested twice and the result is the same each time.

The sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@expression@
expression E;
@@

(
* E
  || ... || E
|
* E
  && ... && E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This is a guess as to what the code should be.  Perhaps something else
should have been tested instead.

 drivers/usb/gadget/amd5536udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 731150d..6c40c99 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -203,7 +203,7 @@ static void print_regs(struct udc *dev)
 		DBG(dev, "DMA mode       = PPBNDU (packet per buffer "
 			"WITHOUT desc. update)\n");
 		dev_info(&dev->pdev->dev, "DMA mode (%s)\n", "PPBNDU");
-	} else if (use_dma && use_dma_ppb_du && use_dma_ppb_du) {
+	} else if (use_dma && use_dma_ppb_du) {
 		DBG(dev, "DMA mode       = PPBDU (packet per buffer "
 			"WITH desc. update)\n");
 		dev_info(&dev->pdev->dev, "DMA mode (%s)\n", "PPBDU");

