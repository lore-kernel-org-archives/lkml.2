Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab0JZKS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:18:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60787 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759481Ab0JZKSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:22 -0400
From: Julia Lawall <julia@diku.dk>
To: Karsten Keil <isdn@linux-pingi.de>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] drivers/isdn: delete double assignment
Date: Tue, 26 Oct 2010 12:25:39 +0200
Message-Id: <1288088743-3725-11-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.  In the first case, the
hscx array has two elements, so change the assignment to initialize the
second one.  In the second case, the two assignments are simply identical.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
In the first case, the patch changes the semantics and has not been tested.

 drivers/isdn/hardware/mISDN/mISDNinfineon.c |    2 +-
 drivers/isdn/hisax/l3_1tr6.c                |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNinfineon.c b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
index af25e1f..e90db88 100644
--- a/drivers/isdn/hardware/mISDN/mISDNinfineon.c
+++ b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
@@ -563,7 +563,7 @@ reset_inf(struct inf_hw *hw)
 		mdelay(10);
 		hw->ipac.isac.adf2 = 0x87;
 		hw->ipac.hscx[0].slot = 0x1f;
-		hw->ipac.hscx[0].slot = 0x23;
+		hw->ipac.hscx[1].slot = 0x23;
 		break;
 	case INF_GAZEL_R753:
 		val = inl((u32)hw->cfg.start + GAZEL_CNTRL);
diff --git a/drivers/isdn/hisax/l3_1tr6.c b/drivers/isdn/hisax/l3_1tr6.c
index b0554f8..a5c76fc 100644
--- a/drivers/isdn/hisax/l3_1tr6.c
+++ b/drivers/isdn/hisax/l3_1tr6.c
@@ -164,8 +164,6 @@ l3_1tr6_setup(struct l3_process *pc, u_char pr, void *arg)
 	char tmp[80];
 	struct sk_buff *skb = arg;
 
-	p = skb->data;
-
 	/* Channel Identification */
 	p = skb->data;
 	if ((p = findie(p, skb->len, WE0_chanID, 0))) {

