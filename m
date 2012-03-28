Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab2C1AsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:48:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:51109 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508Ab2C1Arl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125867363"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        netdev@vger.kernel.org, samuel@sortiz.org
Subject: [PATCH 08/13] irda: remove spin_is_locked
Date: Tue, 27 Mar 2012 17:47:12 -0700
Message-Id: <1332895637-32572-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

It's hard to imagine how this spin_is_locked debugging check is not
totally racy.  Remove it.

Cc: netdev@vger.kernel.org
Cc: samuel@sortiz.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/net/irda/sir_dev.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/irda/sir_dev.c b/drivers/net/irda/sir_dev.c
index 5039f08..90a1b3e 100644
--- a/drivers/net/irda/sir_dev.c
+++ b/drivers/net/irda/sir_dev.c
@@ -632,11 +632,6 @@ static netdev_tx_t sirdev_hard_xmit(struct sk_buff *skb,
 	/* Init tx buffer*/
 	dev->tx_buff.data = dev->tx_buff.head;
 
-	/* Check problems */
-	if(spin_is_locked(&dev->tx_lock)) {
-		IRDA_DEBUG(3, "%s(), write not completed\n", __func__);
-	}
-
 	/* serialize with write completion */
 	spin_lock_irqsave(&dev->tx_lock, flags);
 
-- 
1.7.7.6

