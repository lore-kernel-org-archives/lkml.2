Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965175Ab2B1Uwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:52:37 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49234 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab2B1Uwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:52:35 -0500
Date: Tue, 28 Feb 2012 15:49:14 -0500 (EST)
Message-Id: <20120228.154914.662485432055205683.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: danny.kukawka@bisect.de, dkukawka@suse.de, jeffrey.t.kirsher@intel.com,
        jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] cirrus/mac89x0: print MAC via printk format
 specifier
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMuHMdW0Oh7h8tv85ScgHB50vMaZSU7S3cPJRsChnRe2sNL_kA@mail.gmail.com>
References: <1330091162-8141-4-git-send-email-danny.kukawka@bisect.de>
	<CAMuHMdXAwgtwbCV_=qJnrs=YPZksoEBkjnQB=JbR7fc+UyKdzw@mail.gmail.com>
	<CAMuHMdW0Oh7h8tv85ScgHB50vMaZSU7S3cPJRsChnRe2sNL_kA@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 12:49:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1SKqhxG029811

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Feb 2012 21:45:30 +0100

> drivers/net/ethernet/cirrus/mac89x0.c: In function ¡set_mac_address¢:
> drivers/net/ethernet/cirrus/mac89x0.c:597: warning: dereferencing
> ¡void *¢ pointer
> drivers/net/ethernet/cirrus/mac89x0.c:597: error: request for member
> ¡sa_data¢ in something not a structure or union
> drivers/net/ethernet/cirrus/mac89x0.c:600: warning: dereferencing
> ¡void *¢ pointer
> drivers/net/ethernet/cirrus/mac89x0.c:600: error: request for member
> ¡sa_data¢ in something not a structure or union
> drivers/net/ethernet/cirrus/mac89x0.c:595: warning: unused variable ¡saddr¢

Thanks, I've fixed this as follows and pushed to net-next:

--------------------
mac89x0: Fix build error.

Need to use the new 'saddr' variable not the void 'addr' in
set_mac_address().

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/cirrus/mac89x0.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cirrus/mac89x0.c b/drivers/net/ethernet/cirrus/mac89x0.c
index 419825c..932fdcc 100644
--- a/drivers/net/ethernet/cirrus/mac89x0.c
+++ b/drivers/net/ethernet/cirrus/mac89x0.c
@@ -591,13 +591,13 @@ static void set_multicast_list(struct net_device *dev)
 
 static int set_mac_address(struct net_device *dev, void *addr)
 {
-	int i;
 	struct sockaddr *saddr = addr;
+	int i;
 
-	if (!is_valid_ether_addr(addr->sa_data))
+	if (!is_valid_ether_addr(saddr->sa_data))
 		return -EADDRNOTAVAIL;
 
-	memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
+	memcpy(dev->dev_addr, saddr->sa_data, ETH_ALEN);
 	printk("%s: Setting MAC address to %pM\n", dev->name, dev->dev_addr);
 
 	/* set the Ethernet address */
-- 
1.7.7.6

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
