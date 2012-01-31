Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2AaKol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:44:41 -0500
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:33300 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2AaKoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:44:39 -0500
From: Barry Song <Barry.Song@csr.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <workgroup.linux@csr.com>, <linux-mtd@lists.infradead.org>,
        Barry Song <Baohua.Song@csr.com>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 3/3] MTD: NAND: txx9ndfmc: move to use platform_devm_request_and_ioremap() helper
Date: Tue, 31 Jan 2012 18:00:02 +0800
Message-ID: <1328004002-24646-4-git-send-email-Barry.Song@csr.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.125.36.70]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <Baohua.Song@csr.com>

Signed-off-by: Barry Song <Baohua.Song@csr.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/mtd/nand/txx9ndfmc.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/txx9ndfmc.c b/drivers/mtd/nand/txx9ndfmc.c
index c7c4f1d..b285282 100644
--- a/drivers/mtd/nand/txx9ndfmc.c
+++ b/drivers/mtd/nand/txx9ndfmc.c
@@ -290,15 +290,11 @@ static int __init txx9ndfmc_probe(struct platform_device *dev)
 	int i;
 	struct txx9ndfmc_drvdata *drvdata;
 	unsigned long gbusclk = plat->gbus_clock;
-	struct resource *res;
 
-	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 	drvdata = devm_kzalloc(&dev->dev, sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata)
 		return -ENOMEM;
-	drvdata->base = devm_request_and_ioremap(&dev->dev, res);
+	drvdata->base = platform_devm_request_and_ioremap(dev, 0);
 	if (!drvdata->base)
 		return -EBUSY;
 
-- 
1.7.1



Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
