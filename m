Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab0H1QtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:49:00 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35318 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab0H1Qs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:48:59 -0400
Date: Sat, 28 Aug 2010 18:48:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dan Carpenter <error27@gmail.com>
Cc: Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-geode@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers/usb/gadget/amd5536udc.c: Remove double test
In-Reply-To: <20100828163725.GI9832@bicker>
Message-ID: <Pine.LNX.4.64.1008281846170.13508@ask.diku.dk>
References: <1283010066-20935-1-git-send-email-julia@diku.dk>
 <1283010066-20935-3-git-send-email-julia@diku.dk> <20100828163725.GI9832@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same expression is tested twice and the result is the same each time.
Instead test for use_dma_ppb as in the test above.

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
+	} else if (use_dma && use_dma_ppb && use_dma_ppb_du) {
 		DBG(dev, "DMA mode       = PPBDU (packet per buffer "
 			"WITH desc. update)\n");
 		dev_info(&dev->pdev->dev, "DMA mode (%s)\n", "PPBDU");

