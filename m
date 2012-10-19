Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab2JSEPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 00:15:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48201 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757657Ab2JSEPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 00:15:07 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/21] s390: Convert is_<foo>_ether_addr uses to eth_addr_<foo>
Date: Thu, 18 Oct 2012 21:14:54 -0700
Message-Id: <b59b6bd165426ab02eaca59c8eeb11efcb302bff.1350618011.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350618006.git.joe@perches.com>
References: <cover.1350618006.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the old ether_addr tests to eth_addr_<foo>.
Adds api consistency.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/net/qeth_l2_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index e67e025..58324dc 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -227,9 +227,9 @@ static inline int qeth_l2_get_cast_type(struct qeth_card *card,
 {
 	if (card->info.type == QETH_CARD_TYPE_OSN)
 		return RTN_UNSPEC;
-	if (is_broadcast_ether_addr(skb->data))
+	if (eth_addr_broadcast(skb->data))
 		return RTN_BROADCAST;
-	if (is_multicast_ether_addr(skb->data))
+	if (eth_addr_multicast(skb->data))
 		return RTN_MULTICAST;
 	return RTN_UNSPEC;
 }
-- 
1.7.8.111.gad25c.dirty

