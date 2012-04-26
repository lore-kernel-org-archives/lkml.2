Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab2DZR7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:59:39 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:54838 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557Ab2DZR7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:59:37 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1335463126!2195686!77
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] NFC: nci/ntf.c: quiet sparse noise about plain integer as NULL pointer
Date: Thu, 26 Apr 2012 10:59:28 -0700
User-Agent: KMail/1.9.9
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <lauro.venancio@openbossa.org>, <aloisio.almeida@openbossa.org>,
        <sameo@linux.intel.com>, <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204261059.28568.hartleys@visionengravers.com>
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

diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 99e1632..cb26461 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -497,7 +497,7 @@ static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
 	/* drop partial rx data packet */
 	if (ndev->rx_data_reassembly) {
 		kfree_skb(ndev->rx_data_reassembly);
-		ndev->rx_data_reassembly = 0;
+		ndev->rx_data_reassembly = NULL;
 	}
 
 	/* complete the data exchange transaction, if exists */
