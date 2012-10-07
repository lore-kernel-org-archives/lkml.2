Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab2JGXld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:41:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38320 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672Ab2JGXWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:23 -0400
Message-Id: <20121007225846.451734344@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 085/108] ixp4xx_hss: fix build failure due to missing  linux/module.h inclusion
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian@openwrt.org>

[ Upstream commit 0b836ddde177bdd5790ade83772860940bd481ea ]

Commit 36a1211970193ce215de50ed1e4e1272bc814df1 (netprio_cgroup.h:
dont include module.h from other includes) made the following build
error on ixp4xx_hss pop up:

  CC [M]  drivers/net/wan/ixp4xx_hss.o
 drivers/net/wan/ixp4xx_hss.c:1412:20: error: expected ';', ',' or ')'
 before string constant
 drivers/net/wan/ixp4xx_hss.c:1413:25: error: expected ';', ',' or ')'
 before string constant
 drivers/net/wan/ixp4xx_hss.c:1414:21: error: expected ';', ',' or ')'
 before string constant
 drivers/net/wan/ixp4xx_hss.c:1415:19: error: expected ';', ',' or ')'
 before string constant
 make[8]: *** [drivers/net/wan/ixp4xx_hss.o] Error 1

This was previously hidden because ixp4xx_hss includes linux/hdlc.h which
includes linux/netdevice.h which includes linux/netprio_cgroup.h which
used to include linux/module.h. The real issue was actually present since
the initial commit that added this driver since it uses macros from
linux/module.h without including this file.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wan/ixp4xx_hss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index aaaca9a..3f575af 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/module.h>
 #include <linux/bitops.h>
 #include <linux/cdev.h>
 #include <linux/dma-mapping.h>


