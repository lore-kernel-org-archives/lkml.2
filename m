Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2KHPML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:12:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2KHPMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:12:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the l2-mtd and pinctrl trees
Date: Thu, 8 Nov 2012 15:11:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>
References: <20121107142916.824003a6c863320fbf379652@canb.auug.org.au>
In-Reply-To: <20121107142916.824003a6c863320fbf379652@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211081511.54467.arnd@arndb.de>
X-Provags-ID: V02:K0:CiDINEl+zgWvWsCfA3z3DL5ZYcDe5N5qihkcBPbmft7
 QDKa0IkM2FdC4xSNZbqMNxaWoVjo6zrdRlRTqhQFWqtshBJ1wb
 LSEn9jdr9JwLWbfPd7RQw7PIhOJXSs7Kz4rfkl4RGwveern2b0
 gBVNxoGnsMV3kNuUwf7n6y+y7wzhz817RlkgGmMjnng3xZEBw0
 ViLoNUFWXZPsbn4p7dmGxJ46wOGS/5UYL0Mq/hBt2Y+M/rQzvT
 UMIcT2CqqHeYG4O0hwQMnR0y3Oe9EPgFvsiKEi5UCkJtfk3snt
 q+Wzul1qtp6w6vQ1VuPjL1DVsZb6yr416LeaBaAkRfKEw61MFt
 1eELh+R5iOLi/LMPhouM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2012, Stephen Rothwell wrote:
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-nomadik/board-nhk8815.c between commit 1cd2fc449091 ("ARM:
> nomadik: fixup some FSMC merge problems") from the l2-mtd tree, commits
> bb16bd9b9da4 ("pinctrl/nomadik: move the platform data header") from the
> pinctrl and commit 44e47ccf8ab6 ("Merge branch 'next/multiplatform' into
> for-next") from the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 

Hi Stephen,

I think this one turned out wrong, and is missing this part:

diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index 5ccdf53..69769b7 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -26,7 +26,6 @@
 #include <linux/pinctrl/machine.h>
 #include <linux/platform_data/pinctrl-nomadik.h>
 #include <linux/platform_data/clocksource-nomadik-mtu.h>
-#include <linux/platform_data/mtd-nomadik-nand.h>
 #include <asm/hardware/vic.h>
 #include <asm/sizes.h>
 #include <asm/mach-types.h>


The mtd-nomadik-nand.h inclusion was removed in the l2-mtd tree, but
moved to a different line in the arm-soc tree. It needs to be removed
because the header is gone now.

	Arnd
