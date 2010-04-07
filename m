Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab0DGO77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:59:59 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:60833 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719Ab0DGO74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:59:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ijgzUM/ny0yzHKdKNllmSlRagDY3MU12rhGZh/ly+l8VkHs/yE+VXHCiqSnz/xAodH
         i7GSi7AC6auAW2O40DMzfF8jJ7EzaVjapbGn1+GuNFuMGLBdvcruxNT5wQEUq7IcAZpU
         nq1ab7QnWnQJJIAJDvPGENT6y/cP+ij+nTRQ0=
From: Peter Korsgaard <peter.korsgaard@barco.com>
To: davem@davemloft.net, haavard.skinnemoen@atmel.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <peter.korsgaard@barco.com>
Subject: [PATCH] macb: allow reception of large (>1518 bytes) frames
Date: Wed,  7 Apr 2010 16:59:49 +0200
Message-Id: <1270652389-5364-1-git-send-email-peter.korsgaard@barco.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable BIG bit in the network configuration register, so the MAC doesn't
reject big frames (E.G. when vlans are used).

Signed-off-by: Peter Korsgaard <peter.korsgaard@barco.com>
---
 drivers/net/macb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index c8a18a6..4dde9db 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -793,6 +793,7 @@ static void macb_init_hw(struct macb *bp)
 	config = macb_readl(bp, NCFGR) & MACB_BF(CLK, -1L);
 	config |= MACB_BIT(PAE);		/* PAuse Enable */
 	config |= MACB_BIT(DRFCS);		/* Discard Rx FCS */
+	config |= MACB_BIT(BIG);		/* Receive oversized frames */
 	if (bp->dev->flags & IFF_PROMISC)
 		config |= MACB_BIT(CAF);	/* Copy All Frames */
 	if (!(bp->dev->flags & IFF_BROADCAST))
-- 
1.7.0

