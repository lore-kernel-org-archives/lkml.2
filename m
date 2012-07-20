Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab2GTV2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:28:07 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11761 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2GTV2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:28:05 -0400
Message-ID: <1342819679.5434.50.camel@lorien2>
Subject: [PATCH RFT] net: Fix Neptune ethernet driver to check dma mapping
 error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: davem@davemloft.net, mcarlson@broadcom.com, bhutchings@solarflare.com,
        eric.dumazet@gmail.com, mchan@broadcom.com
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com, stable@vger.kernel.org
Date: Fri, 20 Jul 2012 15:27:59 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request for testing, since I don't have the hardware to test.

--------------------------------------------------------------------

Fix Neptune ethernet driver to check dma mapping error after map_page()
interface returns.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
Cc: <stable@vger.kernel.org>
---
 drivers/net/ethernet/sun/niu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 8c726b7..60d5c03 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3335,6 +3335,10 @@ static int niu_rbr_add_page(struct niu *np, struct rx_ring_info *rp,
 
 	addr = np->ops->map_page(np->device, page, 0,
 				 PAGE_SIZE, DMA_FROM_DEVICE);
+	if (!addr) {
+		__free_page(page);
+		return -ENOMEM;
+	}
 
 	niu_hash_page(rp, page, addr);
 	if (rp->rbr_blocks_per_page > 1)
-- 
1.7.9.5



