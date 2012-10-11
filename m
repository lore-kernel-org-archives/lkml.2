Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435Ab2JKC12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:27:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60522 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934416Ab2JKC1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:27:08 -0400
X-Sasl-enc: IUdNLSwIcxqnZ/Yt1C+eZjLDFTU/oECnQs7UaNQJt5PC 1349922427
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        Hayes Wang <hayeswang@realtek.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 68/84] r8169: missing barriers.
Date: Thu, 11 Oct 2012 11:03:52 +0900
Message-Id: <20121011015429.319110848@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit 1e874e041fc7c222cbd85b20c4406070be1f687a upstream.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Hayes Wang <hayeswang@realtek.com>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -4957,7 +4957,7 @@ static netdev_tx_t rtl8169_start_xmit(st
 
 	if (TX_BUFFS_AVAIL(tp) < MAX_SKB_FRAGS) {
 		netif_stop_queue(dev);
-		smp_rmb();
+		smp_mb();
 		if (TX_BUFFS_AVAIL(tp) >= MAX_SKB_FRAGS)
 			netif_wake_queue(dev);
 	}
@@ -5058,7 +5058,7 @@ static void rtl8169_tx_interrupt(struct
 
 	if (tp->dirty_tx != dirty_tx) {
 		tp->dirty_tx = dirty_tx;
-		smp_wmb();
+		smp_mb();
 		if (netif_queue_stopped(dev) &&
 		    (TX_BUFFS_AVAIL(tp) >= MAX_SKB_FRAGS)) {
 			netif_wake_queue(dev);
@@ -5069,7 +5069,6 @@ static void rtl8169_tx_interrupt(struct
 		 * of start_xmit activity is detected (if it is not detected,
 		 * it is slow enough). -- FR
 		 */
-		smp_rmb();
 		if (tp->cur_tx != dirty_tx)
 			RTL_W8(TxPoll, NPQ);
 	}


