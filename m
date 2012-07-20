Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2GTXeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:34:36 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:37394 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2GTXef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:34:35 -0400
Message-ID: <1342827272.5434.71.camel@lorien2>
Subject: [PATCH RFT]  net: Change niu_rbr_fill() to use unlikely() to check
 niu_rbr_add_page() return value
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: davem@davemloft.net, mcarlson@broadcom.com, bhutchings@solarflare.com,
        eric.dumazet@gmail.com, mchan@broadcom.com
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Fri, 20 Jul 2012 17:34:32 -0600
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change niu_rbr_fill() to use unlikely() to check niu_rbr_add_page() return
value to be consistent with the rest of the checks after niu_rbr_add_page()
calls in this file.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 drivers/net/ethernet/sun/niu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 60d5c03..c2a0fe3 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3517,7 +3517,7 @@ static int niu_rbr_fill(struct niu *np, struct rx_ring_info *rp, gfp_t mask)
 	err = 0;
 	while (index < (rp->rbr_table_size - blocks_per_page)) {
 		err = niu_rbr_add_page(np, rp, mask, index);
-		if (err)
+		if (unlikely(err))
 			break;
 
 		index += blocks_per_page;
-- 
1.7.9.5



