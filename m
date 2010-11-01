Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0KAVCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:02:11 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:21038 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab0KAVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:02:09 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH net-2.6 2/3] cxgb4: remove call to stop TX queues at load time.
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dm@chelsio.com,
        leedom@chelsio.com, swise@opengridcomputing.com
Date: Mon, 01 Nov 2010 13:59:46 -0700
Message-ID: <20101101205946.27716.59639.stgit@speedy5.asicdesigners.com>
In-Reply-To: <20101101205940.27716.24553.stgit@speedy5.asicdesigners.com>
References: <20101101205940.27716.24553.stgit@speedy5.asicdesigners.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Remove racy queue stopping after device registration.

Signed-off-by: Dimitris Michailidis <dm@chelsio.com>

---

 drivers/net/cxgb4/cxgb4_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/drivers/net/cxgb4/cxgb4_main.c b/drivers/net/cxgb4/cxgb4_main.c
index f17703f..f50bc98 100644
--- a/drivers/net/cxgb4/cxgb4_main.c
+++ b/drivers/net/cxgb4/cxgb4_main.c
@@ -3736,7 +3736,6 @@ static int __devinit init_one(struct pci_dev *pdev,
 
 			__set_bit(i, &adapter->registered_device_map);
 			adapter->chan_map[adap2pinfo(adapter, i)->tx_chan] = i;
-			netif_tx_stop_all_queues(adapter->port[i]);
 		}
 	}
 	if (!adapter->registered_device_map) {

