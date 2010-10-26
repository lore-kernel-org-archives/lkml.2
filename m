Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab0JZCqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:46:12 -0400
Received: from mail.perches.com ([173.55.12.10]:3557 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814Ab0JZCoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:44:34 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Tom Tucker <tom@opengridcomputing.com>,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/10] drivers/infiniband: Remove unnecessary KERN_<level> uses
Date: Mon, 25 Oct 2010 19:44:22 -0700
Message-Id: <a62c334347cbfbaf5c5acb29c2ae7acda84344a0.1288059486.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.90.gd4c43
In-Reply-To: <cover.1288059486.git.joe@perches.com>
References: <cover.1288059486.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/infiniband/hw/amso1100/c2_intr.c |    4 ++--
 drivers/infiniband/hw/cxgb3/iwch_cm.c    |    4 ++--
 drivers/infiniband/hw/cxgb4/cm.c         |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_intr.c b/drivers/infiniband/hw/amso1100/c2_intr.c
index 3b50954..0ebe4e8 100644
--- a/drivers/infiniband/hw/amso1100/c2_intr.c
+++ b/drivers/infiniband/hw/amso1100/c2_intr.c
@@ -62,8 +62,8 @@ void c2_rnic_interrupt(struct c2_dev *c2dev)
 static void handle_mq(struct c2_dev *c2dev, u32 mq_index)
 {
 	if (c2dev->qptr_array[mq_index] == NULL) {
-		pr_debug(KERN_INFO "handle_mq: stray activity for mq_index=%d\n",
-			mq_index);
+		pr_debug("handle_mq: stray activity for mq_index=%d\n",
+			 mq_index);
 		return;
 	}
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index 13c8887..d02dcc6 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -1093,8 +1093,8 @@ static int tx_ack(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 	PDBG("%s ep %p credits %u\n", __func__, ep, credits);
 
 	if (credits == 0) {
-		PDBG(KERN_ERR "%s 0 credit ack  ep %p state %u\n",
-			__func__, ep, state_read(&ep->com));
+		PDBG("%s 0 credit ack  ep %p state %u\n",
+		     __func__, ep, state_read(&ep->com));
 		return CPL_RET_BUF_DONE;
 	}
 
diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 32d352a..8f812cf 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1762,8 +1762,8 @@ static int fw4_ack(struct c4iw_dev *dev, struct sk_buff *skb)
 	ep = lookup_tid(t, tid);
 	PDBG("%s ep %p tid %u credits %u\n", __func__, ep, ep->hwtid, credits);
 	if (credits == 0) {
-		PDBG(KERN_ERR "%s 0 credit ack ep %p tid %u state %u\n",
-			__func__, ep, ep->hwtid, state_read(&ep->com));
+		PDBG("%s 0 credit ack ep %p tid %u state %u\n",
+		     __func__, ep, ep->hwtid, state_read(&ep->com));
 		return 0;
 	}
 
-- 
1.7.3.dirty

