Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2F1E3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 00:29:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49528 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab2F1E3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 00:29:42 -0400
Date: Wed, 27 Jun 2012 21:29:41 -0700 (PDT)
Message-Id: <20120627.212941.485325944406335522.davem@davemloft.net>
To: ddaney.cavm@gmail.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, david.daney@cavium.com
Subject: Re: [PATCH v2 0/4] netdev/phy: 10G PHY support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1340818418-10382-1-git-send-email-ddaney.cavm@gmail.com>
References: <1340818418-10382-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5S4Tnfh017381

From: David Daney <ddaney.cavm@gmail.com>
Date: Wed, 27 Jun 2012 10:33:34 -0700

> From: David Daney <david.daney@cavium.com>
> 
> The only non-cosmetic change from v1 is to pass an additional argument
> to get_phy_device() that indicates that the PHY uses 802.3 clause 45
> signaling, previously I had been using a high order bit of the addr
> parameter for this.
> 
> There are also changes from v1 in the code and comment formatting.
> These should now be closer to what David Miller prefers.

Applied, but I had to add the following warning fixup:

--------------------
phy: Fix warning in get_phy_device().

drivers/net/phy/phy_device.c: In function ¡get_phy_device¢:
drivers/net/phy/phy_device.c:340:14: warning: ¡phy_id¢ may be used uninitialized in this function [-Wmaybe-uninitialized]

GCC can't see that when we return zero we always initialize
phy_id and that's the only path where we use it.

Initialize phy_id to zero to shut it up.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/phy/phy_device.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ef4cdee..47e02e7 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -327,9 +327,9 @@ static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
  */
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
-	struct phy_device *dev = NULL;
-	u32 phy_id;
 	struct phy_c45_device_ids c45_ids = {0};
+	struct phy_device *dev = NULL;
+	u32 phy_id = 0;
 	int r;
 
 	r = get_phy_id(bus, addr, &phy_id, is_c45, &c45_ids);
-- 
1.7.10.2

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
