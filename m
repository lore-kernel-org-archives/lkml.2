Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1ANUkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 15:40:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46743
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab1ANUkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 15:40:43 -0500
Date: Fri, 14 Jan 2011 12:41:16 -0800 (PST)
Message-Id: <20110114.124116.197952526.davem@davemloft.net>
To: anca.emanuel@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        grant.likely@secretlab.ca, eric.dumazet@gmail.com, joe@perches.com,
        siccegge@cs.fau.de, jpirko@redhat.com
Subject: Re: Kernel 2.6.37-git10 build failure: cassini.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTin61iqrD0Jbax+cvQ1wxD8b=c4KJv7pBSvU7kbv@mail.gmail.com>
References: <AANLkTin61iqrD0Jbax+cvQ1wxD8b=c4KJv7pBSvU7kbv@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0EKf1cl006991

From: Anca Emanuel <anca.emanuel@gmail.com>
Date: Fri, 14 Jan 2011 10:09:43 +0200

> drivers/net/cassini.c: In function ¡cas_get_vpd_info¢:
> drivers/net/cassini.c:3358: error: implicit declaration of function
> ¡of_get_property¢
> drivers/net/cassini.c:3358: warning: assignment makes pointer from
> integer without a cast
> drivers/net/cassini.c: In function ¡cas_init_one¢:
> drivers/net/cassini.c:5035: error: implicit declaration of function
> ¡pci_device_to_OF_node¢
> drivers/net/cassini.c:5035: warning: assignment makes pointer from
> integer without a cast
> make[3]: *** [drivers/net/cassini.o] Error 1
> make[2]: *** [drivers/net] Error 2

This is the fix I'll be using:

--------------------
cassini: Fix build bustage on x86.

Unfortunately, not all CONFIG_OF platforms provide
pci_device_to_OF_node().

Change the test to CONFIG_SPARC for now to deal with
the build regressions.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/cassini.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index 7206ab2..3437613 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -3203,7 +3203,7 @@ static int cas_get_vpd_info(struct cas *cp, unsigned char *dev_addr,
 	int phy_type = CAS_PHY_MII_MDIO0; /* default phy type */
 	int mac_off  = 0;
 
-#if defined(CONFIG_OF)
+#if defined(CONFIG_SPARC)
 	const unsigned char *addr;
 #endif
 
@@ -3354,7 +3354,7 @@ use_random_mac_addr:
 	if (found & VPD_FOUND_MAC)
 		goto done;
 
-#if defined(CONFIG_OF)
+#if defined(CONFIG_SPARC)
 	addr = of_get_property(cp->of_node, "local-mac-address", NULL);
 	if (addr != NULL) {
 		memcpy(dev_addr, addr, 6);
@@ -5031,7 +5031,7 @@ static int __devinit cas_init_one(struct pci_dev *pdev,
 	cp->msg_enable = (cassini_debug < 0) ? CAS_DEF_MSG_ENABLE :
 	  cassini_debug;
 
-#if defined(CONFIG_OF)
+#if defined(CONFIG_SPARC)
 	cp->of_node = pci_device_to_OF_node(pdev);
 #endif
 
-- 
1.7.3.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
