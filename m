Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0IFOgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:36:42 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33562 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab0IFOg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:36:27 -0400
Date: Mon, 6 Sep 2010 16:36:25 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: "David S. Miller" <davem@davemloft.net>, Roland Dreier <rolandd@cisco.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Joe Perches <joe@perches.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 06/14] drivers/net: Removing undead ifdef CHELSIO_T1_1G
Message-ID: <fd089f3e72b01fc29faf8113606354f6c423f141.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CHELSIO_T1_1G ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/net/chelsio/subr.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/chelsio/subr.c b/drivers/net/chelsio/subr.c
index 599d178..63ebf76 100644
--- a/drivers/net/chelsio/subr.c
+++ b/drivers/net/chelsio/subr.c
@@ -314,14 +314,12 @@ static int mi1_mdio_write(struct net_device *dev, int phy_addr, int mmd_addr,
 	return 0;
 }
 
-#if defined(CONFIG_CHELSIO_T1_1G)
 static const struct mdio_ops mi1_mdio_ops = {
 	.init = mi1_mdio_init,
 	.read = mi1_mdio_read,
 	.write = mi1_mdio_write,
 	.mode_support = MDIO_SUPPORTS_C22
 };
-#endif
 
 #endif
 
-- 
1.7.0.4

