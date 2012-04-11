Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503Ab2DKXVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:21:32 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:51108 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761431Ab2DKXV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:21:29 -0400
Message-Id: <20120411231036.075026915@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Stephen Hemminger <shemminger@vyattta.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 03/59] sky2: dont overwrite settings for PHY Quick link
In-Reply-To: <20120411231213.GA13124@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

[ Upstream commit 2240eb4ae3dc4acff20d1a8947c441c451513e37 ]

This patch corrects a bug in function sky2_open() of the Marvell Yukon 2 driver
in which the settings for PHY quick link are overwritten.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Acked-by: Stephen Hemminger <shemminger@vyattta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/sky2.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1766,13 +1766,14 @@ static int sky2_open(struct net_device *
 
 	sky2_hw_up(sky2);
 
+	/* Enable interrupts from phy/mac for port */
+	imask = sky2_read32(hw, B0_IMSK);
+
 	if (hw->chip_id == CHIP_ID_YUKON_OPT ||
 	    hw->chip_id == CHIP_ID_YUKON_PRM ||
 	    hw->chip_id == CHIP_ID_YUKON_OP_2)
 		imask |= Y2_IS_PHY_QLNK;	/* enable PHY Quick Link */
 
-	/* Enable interrupts from phy/mac for port */
-	imask = sky2_read32(hw, B0_IMSK);
 	imask |= portirq_msk[port];
 	sky2_write32(hw, B0_IMSK, imask);
 	sky2_read32(hw, B0_IMSK);


