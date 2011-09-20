Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab1ITVZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:25:51 -0400
Received: from n1.taur.dk ([217.198.219.102]:35328 "EHLO n1.taur.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab1ITVZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:25:50 -0400
X-Greylist: delayed 2171 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Sep 2011 17:25:49 EDT
Message-ID: <4E78FC38.7040903@kasperkp.dk>
Date: Tue, 20 Sep 2011 22:48:56 +0200
From: Kasper Pedersen <kernel@kasperkp.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110831 Fedora/3.1.12-2.fc14 Thunderbird/3.1.12
MIME-Version: 1.0
To: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tg3: fix VLAN tagging regression
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 92cd3a17ce9c719abb4c28dee3438e0c641f8de4
    tg3: Simplify tx bd assignments

broke VLAN tagging on outbound packets.
It ifdef'ed BCM_KERNEL_SUPPORTS_8021Q, but this
is not set anywhere. So vlan never gets set, and
all packets are sent with vlan=0.

Change to use the CONFIG_VLAN_xxx defines instead.
Tested on BCM5721 rev 11.

Signed-off-by: Kasper Pedersen <kernel@kasperkp.dk>
---
 drivers/net/tg3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index dc3fbf6..a00d21b 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -6234,7 +6234,7 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 
-#ifdef BCM_KERNEL_SUPPORTS_8021Q
+#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
 	if (vlan_tx_tag_present(skb)) {
 		base_flags |= TXD_FLAG_VLAN;
 		vlan = vlan_tx_tag_get(skb);

