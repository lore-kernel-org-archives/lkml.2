Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0JOPAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:00:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46903 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab0JOPAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rErNNUuwzrM8ZlbT/MTSwiJtg+nQT41+UuWK1FUSaqQ/LZNLI1ONFB3eaObXBV6RKg
         ZKwgZ8jTXPB1E1GHZpEirxh3ldWVFGYZNF+yU0SlIWrVPqLoiYG0JIO9pnjGX7xrR7/o
         z9hw7G8CrbtV5fuP7KyUqhmgYkdKVIoz/zEY8=
Message-ID: <4CB86C87.5010207@gmail.com>
Date: Fri, 15 Oct 2010 23:00:23 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: netdev@vger.kernel.org, yachen@nuvoton.com,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] net/nuc900: change dev_warn to dev_dbg when link down occurs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

When I didnot connect the net cable, the warning infos are always showed,
so I change the dev_warn to dev_dbg.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
  drivers/net/arm/w90p910_ether.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/arm/w90p910_ether.c b/drivers/net/arm/w90p910_ether.c
index 4545d5a..98f8ada 100644
--- a/drivers/net/arm/w90p910_ether.c
+++ b/drivers/net/arm/w90p910_ether.c
@@ -213,7 +213,7 @@ static void update_linkspeed(struct net_device *dev)
  	if (!mii_link_ok(&ether->mii)) {
  		ether->linkflag = 0x0;
  		netif_carrier_off(dev);
-		dev_warn(&pdev->dev, "%s: Link down.\n", dev->name);
+		dev_dbg(&pdev->dev, "%s: Link down.\n", dev->name);
  		return;
  	}

-- 
1.6.3.3
