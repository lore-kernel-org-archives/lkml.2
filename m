Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0KAVCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:02:18 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:9597 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab0KAVCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:02:14 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH net-2.6 3/3] cxgb4vf: remove call to stop TX queues at load
	time.
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dm@chelsio.com,
        leedom@chelsio.com, swise@opengridcomputing.com
Date: Mon, 01 Nov 2010 13:59:51 -0700
Message-ID: <20101101205951.27716.64800.stgit@speedy5.asicdesigners.com>
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

Stopping TX queues at driver load time is not necessary.

Signed-off-by: Casey Leedom <leedom@chelsio.com>

---

 drivers/net/cxgb4vf/cxgb4vf_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/drivers/net/cxgb4vf/cxgb4vf_main.c b/drivers/net/cxgb4vf/cxgb4vf_main.c
index 555ecc5..6de5e2e 100644
--- a/drivers/net/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/cxgb4vf/cxgb4vf_main.c
@@ -2600,7 +2600,6 @@ static int __devinit cxgb4vf_pci_probe(struct pci_dev *pdev,
 		pi->xact_addr_filt = -1;
 		pi->rx_offload = RX_CSO;
 		netif_carrier_off(netdev);
-		netif_tx_stop_all_queues(netdev);
 		netdev->irq = pdev->irq;
 
 		netdev->features = (NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 |

