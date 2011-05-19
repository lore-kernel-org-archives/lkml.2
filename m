Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099Ab1ESSST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:18:19 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52733 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934011Ab1ESSIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:38 -0400
X-Sasl-enc: DkPbvBf+ttQUXjCjFUqiZjV/96PjlZyS1RalUHl/+woL 1305828517
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:57 2011
Message-Id: <20110519180557.653734068@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [35/71] PCH_GbE : Fixed the issue of checksum judgment
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

commit 5d05a04d283061b586e8dc819cfa6f4b8cfd5948 upstream.

The checksum judgment was mistaken.
  Judgment result
     0:Correct 1:Wrong

This patch fixes the issue.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/pch_gbe/pch_gbe_main.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/net/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/pch_gbe/pch_gbe_main.c
@@ -1493,12 +1493,11 @@ pch_gbe_clean_rx(struct pch_gbe_adapter
 			/* Write meta date of skb */
 			skb_put(skb, length);
 			skb->protocol = eth_type_trans(skb, netdev);
-			if ((tcp_ip_status & PCH_GBE_RXD_ACC_STAT_TCPIPOK) ==
-			    PCH_GBE_RXD_ACC_STAT_TCPIPOK) {
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
-			} else {
+			if (tcp_ip_status & PCH_GBE_RXD_ACC_STAT_TCPIPOK)
 				skb->ip_summed = CHECKSUM_NONE;
-			}
+			else
+				skb->ip_summed = CHECKSUM_UNNECESSARY;
+
 			napi_gro_receive(&adapter->napi, skb);
 			(*work_done)++;
 			pr_debug("Receive skb->ip_summed: %d length: %d\n",


