Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab2C0Iah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:30:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:25805 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268Ab2C0Iad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:30:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125524111"
Subject: Re: linux-next: build failure after merge of the slave-dma tree
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martin <javier.martin@vista-silicon.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <20120327115232.ef58a6f97da2d29ed3c8bdb6@canb.auug.org.au>
References: <20120327115232.ef58a6f97da2d29ed3c8bdb6@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Mar 2012 14:03:14 +0530
Message-ID: <1332837194.1820.4.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 11:52 +1100, Stephen Rothwell wrote:
> Hi Vinod,
> 
> After merging the slave-dma tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/dma/imx-dma.c:31:22: fatal error: mach/dma.h: No such file or directory
> 
> Caused by commit 6bd081277ea0 ("dmaengine: imx-dma: merge old dma-v1.c
> with imx-dma.c").
Thanks Stephen,

This should have depends on ARCH_MXS at least and should not have built
for x86_64. Below patch should fix it and I will apply this.

> 
> I have used the slave-dma tree from next-20120326 for today.
> 
> I was wondering why this new work appeared during the merge window ...
I had this series pending and wanted to get this merged but it didn't
apply for me last week and I was out for the long weekend :(
So merged on first chance I got back.

Tree is frozen now, barring any other hiccups. Sorry for the issue
--------------------------------x-------------------x----------------------

>From 9da98b21787488f9d99b7f93b42aee95bfd07c49 Mon Sep 17 00:00:00 2001
From: Vinod Koul <vinod.koul@linux.intel.com>
Date: Tue, 27 Mar 2012 13:53:00 +0530
Subject: [PATCH] dmaengine: imx: fix the build failure on x64

commit 6bd081277ea0 "dmaengine: imx-dma: merge old dma-v1.c with
imx-dma.c" removed the dependency in config for the imx dma driver,
whereas it should depend on ARCH_MXS

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
---
 drivers/dma/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index b4a53a0..34e48d9 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -230,6 +230,7 @@ config IMX_SDMA
 
 config IMX_DMA
 	tristate "i.MX DMA support"
+	depends on ARCH_MXC
 	select DMA_ENGINE
 	help
 	  Support the i.MX DMA engine. This engine is integrated into
-- 
1.7.0.4


-- 
~Vinod

