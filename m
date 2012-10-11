Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962Ab2JKCUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:20:30 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44989 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964884Ab2JKCPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:15:18 -0400
X-Sasl-enc: gFgZrJYftzOtSY0loIps7H04qThEzMaO1RNhdpWPPTlp 1349921716
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Francois Romieu <romieu@fr.zoreil.com>,
        Jonathan Nieder <jrnieder@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 64/84] r8169: expand received packet length indication.
Date: Thu, 11 Oct 2012 11:03:48 +0900
Message-Id: <20121011015428.591614995@linuxfoundation.org>
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

commit deb9d93c89d311714a60809b28160e538e1cbb43 upstream.

8168d and above allow jumbo frames beyond 8k. Bump the received
packet length check before enabling jumbo frames on these chipsets.

Frame length indication covers bits 0..13 of the first Rx descriptor
32 bits for the 8169 and 8168. I only have authoritative documentation
for the allowed use of the extra (13) bit with the 8169 and 8168c.
Realtek's drivers use the same mask for the 816x and the fast ethernet
only 810x.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/r8169.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -5137,7 +5137,7 @@ static int rtl8169_rx_interrupt(struct n
 		} else {
 			struct sk_buff *skb;
 			dma_addr_t addr = le64_to_cpu(desc->addr);
-			int pkt_size = (status & 0x00001FFF) - 4;
+			int pkt_size = (status & 0x00003fff) - 4;
 
 			/*
 			 * The driver does not support incoming fragmented


