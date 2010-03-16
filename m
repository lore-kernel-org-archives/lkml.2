Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013Ab0CPSeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 14:34:44 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:48230 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759988Ab0CPSec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 14:34:32 -0400
Date: Tue, 16 Mar 2010 21:34:30 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Vrabel <david.vrabel@csr.com>,
       Richard =?utf-8?Q?R=C3=B6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>,
       Pierre Ossman <pierre@ossman.eu>, Ben Dooks <ben@simtec.co.uk>,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] sdhci-pltfm: Do not print errors in case of an
 extended iomem size
Message-ID: <20100316183430.GC25670@oksana.dev.rtsoft.ru>
References: <20100316183400.GA24191@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100316183400.GA24191@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some hosts have an extended SDHCI iomem size, so the driver should
only print errors if the iomem size is less than 0x100.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mmc/host/sdhci-pltfm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index 217b911..b6ee0d7 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -61,7 +61,7 @@ static int __devinit sdhci_pltfm_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	if (resource_size(iomem) != 0x100)
+	if (resource_size(iomem) < 0x100)
 		dev_err(&pdev->dev, "Invalid iomem size. You may "
 			"experience problems.\n");
 
-- 
1.7.0
