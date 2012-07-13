Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030807Ab2GMFe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:34:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50082 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030245Ab2GMFev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:34:51 -0400
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>, Ursula Braun <ursula.braun@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/8] s390: Use eth_random_addr
Date: Thu, 12 Jul 2012 22:33:10 -0700
Message-Id: <26e67c596de28829d68351aa7b8355e6b83a089d.1342157022.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <1341968967.13724.23.camel@joe2Laptop>
References: <1341968967.13724.23.camel@joe2Laptop>
In-Reply-To: <cover.1342157022.git.joe@perches.com>
References: <cover.1342157022.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the existing uses of random_ether_addr to
the new eth_random_addr.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/net/qeth_l2_main.c |    2 +-
 drivers/s390/net/qeth_l3_main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 4269865..b09355c 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -647,7 +647,7 @@ static int qeth_l2_request_initial_mac(struct qeth_card *card)
 		}
 		QETH_DBF_HEX(SETUP, 2, card->dev->dev_addr, OSA_ADDR_LEN);
 	} else {
-		random_ether_addr(card->dev->dev_addr);
+		eth_random_addr(card->dev->dev_addr);
 		memcpy(card->dev->dev_addr, vendor_pre, 3);
 	}
 	return 0;
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 73ac63d..bada7f6 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1473,7 +1473,7 @@ static int qeth_l3_iqd_read_initial_mac_cb(struct qeth_card *card,
 		memcpy(card->dev->dev_addr,
 			cmd->data.create_destroy_addr.unique_id, ETH_ALEN);
 	else
-		random_ether_addr(card->dev->dev_addr);
+		eth_random_addr(card->dev->dev_addr);
 
 	return 0;
 }
-- 
1.7.8.111.gad25c.dirty

