Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2DZRbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:31:39 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:64986 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2DZRbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:31:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1335461436!9781909!48
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] NFC: nci/data.c: quiet sparse noise about plain integer as NULL pointer
Date: Thu, 26 Apr 2012 10:31:16 -0700
User-Agent: KMail/1.9.9
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <lauro.venancio@openbossa.org>, <aloisio.almeida@openbossa.org>,
        <sameo@linux.intel.com>, <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204261031.16737.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointers should be cleared with NULL, not 0.

Quiets a couple sparse warnings of the type:

warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>

---

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index a0bc326..76c48c5 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -49,7 +49,7 @@ void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 
 	if (cb) {
 		ndev->data_exchange_cb = NULL;
-		ndev->data_exchange_cb_context = 0;
+		ndev->data_exchange_cb_context = NULL;
 
 		/* forward skb to nfc core */
 		cb(cb_context, skb, err);
@@ -200,10 +200,10 @@ static void nci_add_rx_data_frag(struct nci_dev *ndev,
 			pr_err("error adding room for accumulated rx data\n");
 
 			kfree_skb(skb);
-			skb = 0;
+			skb = NULL;
 
 			kfree_skb(ndev->rx_data_reassembly);
-			ndev->rx_data_reassembly = 0;
+			ndev->rx_data_reassembly = NULL;
 
 			err = -ENOMEM;
 			goto exit;
@@ -216,7 +216,7 @@ static void nci_add_rx_data_frag(struct nci_dev *ndev,
 
 		/* third, free old reassembly */
 		kfree_skb(ndev->rx_data_reassembly);
-		ndev->rx_data_reassembly = 0;
+		ndev->rx_data_reassembly = NULL;
 	}
 
 	if (pbf == NCI_PBF_CONT) {
