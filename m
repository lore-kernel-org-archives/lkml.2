Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab2LMOLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:11:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932933Ab2LMOLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Graham Gower <graham.gower@gmail.com>,
        Jan Ceuleers <jan.ceuleers@computer.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 177/241] skge: Add DMA mask quirk for Marvell 88E8001 on ASUS P5NSLI motherboard
Date: Thu, 13 Dec 2012 11:59:02 -0200
Message-Id: <1355407206-17100-178-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Graham Gower <graham.gower@gmail.com>

commit a2af139ff1cd85df586690ff626619ab1ee88b0a upstream.

Marvell 88E8001 on an ASUS P5NSLI motherboard is unable to send/receive
packets on a system with >4gb ram unless a 32bit DMA mask is used.

This issue has been around for years and a fix was sent 3.5 years ago, but
there was some debate as to whether it should instead be fixed as a PCI quirk.
http://www.spinics.net/lists/netdev/msg88670.html

However, 18 months later a similar workaround was introduced for another
chipset exhibiting the same problem.
http://www.spinics.net/lists/netdev/msg142287.html

Signed-off-by: Graham Gower <graham.gower@gmail.com>
Signed-off-by: Jan Ceuleers <jan.ceuleers@computer.org>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/marvell/skge.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 5a30bf8..f4be8f7 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -4153,6 +4153,13 @@ static struct dmi_system_id skge_32bit_dma_boards[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "nForce"),
 		},
 	},
+	{
+		.ident = "ASUS P5NSLI",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P5NSLI")
+		},
+	},
 	{}
 };
 
-- 
1.7.9.5

