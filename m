Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2DEBPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 21:15:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51604 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab2DEBPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 21:15:31 -0400
Date: Wed, 04 Apr 2012 21:15:06 -0400 (EDT)
Message-Id: <20120404.211506.929057223227809703.davem@davemloft.net>
To: msink@trikom.ru
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com, msink@permonline.ru
Subject: Re: [PATCH v8 0/2] Ethernet drivers for WIZnet chips
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333540660-30551-1-git-send-email-msink@trikom.ru>
References: <1333524216-23488-1-git-send-email-msink@permonline.ru>
	<1333540660-30551-1-git-send-email-msink@trikom.ru>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 04 Apr 2012 18:15:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q351FdZi023372

From: Mike Sinkovsky <msink@trikom.ru>
Date: Wed,  4 Apr 2012 17:57:38 +0600

> From: Mike Sinkovsky <msink@permonline.ru>
> 
> Based on original driver from chip manufacturer, but nearly full rewite.
> Tested and used in production with Blackfin BF531 embedded processor.
> 
> Signed-off-by: Mike Sinkovsky <msink@permonline.ru>

I don't see the appropriate changes in your patches to make
sure that drivers/net/ethernet/{Kconfig,Makefile} consider
and traverse down into the wiznet/ subdirectory.

Furthermore, once that is fixed these drivers generate warnings
when built:

drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.suspend¢) [enabled by default]
drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.resume¢) [enabled by default]
drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.freeze¢) [enabled by default]
drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.thaw¢) [enabled by default]
drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.poweroff¢) [enabled by default]
drivers/net/ethernet/wiznet/w5300.c:708:8: warning: initialization from incompatible pointer type [enabled by default]
drivers/net/ethernet/wiznet/w5300.c:708:8: warning: (near initialization for ¡w5300_pm_ops.restore¢) [enabled by default]

It seems that the arguments and return types for these operations have
changed since you worked on these patches, but this should be easy
to fix up.

Please cure these two issues and I'll happily put these new drivers
into net-next, and meanwhile you can continue to work with Eric
Dumazet to correct the TX flow control and locking issues.

Thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
