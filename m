Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0I2Fxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:53:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56054 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab0I2Fxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:53:33 -0400
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, edgar.iglesias@gmail.com, duyl@xilinx.com,
        linnj@xilinx.com, grant.likely@secretlab.ca,
        microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 4/7] net: emaclite: Add support for little-endian platforms
Date: Wed, 29 Sep 2010 15:52:15 +1000
Message-Id: <1285739538-29058-5-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1285739538-29058-4-git-send-email-monstr@monstr.eu>
References: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
 <1285739538-29058-2-git-send-email-monstr@monstr.eu>
 <1285739538-29058-3-git-send-email-monstr@monstr.eu>
 <1285739538-29058-4-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upcomming Microblaze is little endian that's why is necessary
to fix protocol and length loading.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: "David S. Miller" <davem@davemloft.net>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: devicetree-discuss@lists.ozlabs.org
---
 drivers/net/xilinx_emaclite.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xilinx_emaclite.c b/drivers/net/xilinx_emaclite.c
index 71122ee..533ebb1 100644
--- a/drivers/net/xilinx_emaclite.c
+++ b/drivers/net/xilinx_emaclite.c
@@ -430,8 +430,8 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data)
 	}
 
 	/* Get the protocol type of the ethernet frame that arrived */
-	proto_type = ((in_be32(addr + XEL_HEADER_OFFSET +
-			XEL_RXBUFF_OFFSET) >> XEL_HEADER_SHIFT) &
+	proto_type = ((ntohl(in_be32(addr + XEL_HEADER_OFFSET +
+			XEL_RXBUFF_OFFSET)) >> XEL_HEADER_SHIFT) &
 			XEL_RPLR_LENGTH_MASK);
 
 	/* Check if received ethernet frame is a raw ethernet frame
@@ -439,9 +439,9 @@ static u16 xemaclite_recv_data(struct net_local *drvdata, u8 *data)
 	if (proto_type > (ETH_FRAME_LEN + ETH_FCS_LEN)) {
 
 		if (proto_type == ETH_P_IP) {
-			length = ((in_be32(addr +
+			length = ((ntohl(in_be32(addr +
 					XEL_HEADER_IP_LENGTH_OFFSET +
-					XEL_RXBUFF_OFFSET) >>
+					XEL_RXBUFF_OFFSET)) >>
 					XEL_HEADER_SHIFT) &
 					XEL_RPLR_LENGTH_MASK);
 			length += ETH_HLEN + ETH_FCS_LEN;
-- 
1.5.5.1

