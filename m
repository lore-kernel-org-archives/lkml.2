Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab1LOQvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 11:51:18 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:29690 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab1LOQvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 11:51:16 -0500
X-SpamScore: -10
X-BigFish: VPS-10(zzzz1202hzz15d4R8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LW9816-01-70P-02
X-M-MSG: 
Date: Thu, 15 Dec 2011 17:48:37 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: "David S. Miller" <davem@davemloft.net>,
        Yevgeny Petrilin <yevgenyp@mellanox.co.il>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] mlx4: Fix compile error when driver is comiled-in
Message-ID: <20111215164837.GE2112@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Testing my iommu-configs against linux-next found a compile error for
allyesconfig. It only happens when the mlx4 driver is compiled into the
kernel and not as a module because these two static functions are also
used in another file. The attached patch fixes it.

>From b993c4448c2ce5447fd24e7d4fce02e633d3222e Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Thu, 15 Dec 2011 17:30:33 +0100
Subject: [PATCH 1/2] mlx4: Fix compile error when driver is comiled-in

This patch fixes a compile error that occurs when the driver
is compile into the kernel and not as a module.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/net/ethernet/mellanox/mlx4/port.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index 00a9547..88b52e5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -783,7 +783,7 @@ int mlx4_SET_PORT(struct mlx4_dev *dev, u8 port)
 	return err;
 }
 
-static int mlx4_SET_PORT_general(struct mlx4_dev *dev, u8 port, int mtu,
+int mlx4_SET_PORT_general(struct mlx4_dev *dev, u8 port, int mtu,
 			  u8 pptx, u8 pfctx, u8 pprx, u8 pfcrx)
 {
 	struct mlx4_cmd_mailbox *mailbox;
@@ -813,7 +813,7 @@ static int mlx4_SET_PORT_general(struct mlx4_dev *dev, u8 port, int mtu,
 }
 EXPORT_SYMBOL(mlx4_SET_PORT_general);
 
-static int mlx4_SET_PORT_qpn_calc(struct mlx4_dev *dev, u8 port, u32 base_qpn,
+int mlx4_SET_PORT_qpn_calc(struct mlx4_dev *dev, u8 port, u32 base_qpn,
 			   u8 promisc)
 {
 	struct mlx4_cmd_mailbox *mailbox;
-- 
1.7.5.4


-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

