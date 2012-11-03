Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2KCLCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:02:23 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:11958
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667Ab2KCK6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:50 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161245669"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Steve Wise <swise@chelsio.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/16] drivers/infiniband/hw/cxgb3/iwch_cm.c: use WARN
Date: Sat,  3 Nov 2012 11:58:29 +0100
Message-Id: <1351940317-14812-9-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use WARN rather than printk followed by WARN_ON(1), for conciseness.

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression list es;
@@

-printk(
+WARN(1,
  es);
-WARN_ON(1);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/infiniband/hw/cxgb3/iwch_cm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index aaf88ef..8baaf0d 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -128,9 +128,8 @@ static void stop_ep_timer(struct iwch_ep *ep)
 {
 	PDBG("%s ep %p\n", __func__, ep);
 	if (!timer_pending(&ep->timer)) {
-		printk(KERN_ERR "%s timer stopped when its not running!  ep %p state %u\n",
+		WARN(1, KERN_ERR "%s timer stopped when its not running!  ep %p state %u\n",
 			__func__, ep, ep->com.state);
-		WARN_ON(1);
 		return;
 	}
 	del_timer_sync(&ep->timer);
@@ -1756,9 +1755,8 @@ static void ep_timeout(unsigned long arg)
 		__state_set(&ep->com, ABORTING);
 		break;
 	default:
-		printk(KERN_ERR "%s unexpected state ep %p state %u\n",
+		WARN(1, KERN_ERR "%s unexpected state ep %p state %u\n",
 			__func__, ep, ep->com.state);
-		WARN_ON(1);
 		abort = 0;
 	}
 	spin_unlock_irqrestore(&ep->com.lock, flags);

