Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab2EIGWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:22:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38965 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651Ab2EIFxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:18 -0400
Message-Id: <20120509055041.563205578@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 085/167] [PATCH 24/26] ksz884x: dont copy too much in
 netdev_set_mac_address()
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 716af4abd6e6370226f567af50bfaca274515980 ]

MAX_ADDR_LEN is 32.  ETH_ALEN is 6.  mac->sa_data is a 14 byte array, so
the memcpy() is doing a read past the end of the array.  I asked about
this on netdev and Ben Hutchings told me it's supposed to be copying
ETH_ALEN bytes (thanks Ben).

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/micrel/ksz884x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 7ece990..4b9f4bd 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5679,7 +5679,7 @@ static int netdev_set_mac_address(struct net_device *dev, void *addr)
 		memcpy(hw->override_addr, mac->sa_data, MAC_ADDR_LEN);
 	}
 
-	memcpy(dev->dev_addr, mac->sa_data, MAX_ADDR_LEN);
+	memcpy(dev->dev_addr, mac->sa_data, ETH_ALEN);
 
 	interrupt = hw_block_intr(hw);
 
-- 
1.7.10



