Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1DUWUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 18:20:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49564
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764Ab1DUWT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 18:19:59 -0400
Date: Thu, 21 Apr 2011 15:19:25 -0700 (PDT)
Message-Id: <20110421.151925.226786245.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, mirq-linux@rere.qmqm.pl
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110422081008.e7ebab59.sfr@canb.auug.org.au>
References: <20110422081008.e7ebab59.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 22 Apr 2011 08:10:08 +1000

> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc chrp32_defconfig)
> failed like this:
> 
> drivers/net/mv643xx_eth.c: In function 'port_start':
> drivers/net/mv643xx_eth.c:2250: error: 'dev' undeclared (first use in this function)
> 
> Caused by commit aad59c431b77 ("net: mv643xx: convert to hw_features").

I just pushed the following fix, thanks!

--------------------
mv643xx_eth: Fix build regression.

>From Stephen Rothwell:

--------------------
After merging the final tree, today's linux-next build (powerpc chrp32_defconfig)
failed like this:

drivers/net/mv643xx_eth.c: In function 'port_start':
drivers/net/mv643xx_eth.c:2250: error: 'dev' undeclared (first use in this function)

Caused by commit aad59c431b77 ("net: mv643xx: convert to hw_features").
--------------------

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/mv643xx_eth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index 29605a3..57c2ac0 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -2247,7 +2247,7 @@ static void port_start(struct mv643xx_eth_private *mp)
 	 * frames to RX queue #0, and include the pseudo-header when
 	 * calculating receive checksums.
 	 */
-	mv643xx_eth_set_features(dev, dev->features);
+	mv643xx_eth_set_features(mp->dev, mp->dev->features);
 
 	/*
 	 * Treat BPDUs as normal multicasts, and disable partition mode.
-- 
1.7.4.3

