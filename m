Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab1FQIK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 04:10:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37398 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab1FQIKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 04:10:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=M4L9ksMIwaEZ4pL4A48B43wmQfd7j45R7r0BRMVL5NWiH+wgqhBT/KmXh8UBxWquy4
         lHgZEaSm3MYIY2cF2SeMwNjSc8ESxFzfDu0H2VLrlVey1G2wwbjoiyA7n8dQGnFpEeuG
         4V5+mdroPLGYGxZnejQcpmeylEF0jkZvnS02s=
Subject: [PATCH 1/2] mtd: onenand/omap2.c: fix build error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Jun 2011 16:09:36 +0800
Message-ID: <1308298176.13535.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:
  CC      drivers/mtd/onenand/omap2.o
drivers/mtd/onenand/omap2.c: In function 'omap2_onenand_probe':
drivers/mtd/onenand/omap2.c:754: error: 'info' undeclared (first use in this function)
drivers/mtd/onenand/omap2.c:754: error: (Each undeclared identifier is reported only once
drivers/mtd/onenand/omap2.c:754: error: for each function it appears in.)
make[3]: *** [drivers/mtd/onenand/omap2.o] Error 1
make[2]: *** [drivers/mtd/onenand] Error 2
make[1]: *** [drivers/mtd] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/onenand/omap2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index eb9cbd9..06efa14 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -751,7 +751,7 @@ static int __devinit omap2_onenand_probe(struct platform_device *pdev)
 	if ((r = onenand_scan(&c->mtd, 1)) < 0)
 		goto err_release_regulator;
 
-	r = mtd_device_parse_register(&info->mtd, NULL, 0,
+	r = mtd_device_parse_register(&c->mtd, NULL, 0,
 			pdata ? pdata->parts : NULL,
 			pdata ? pdata->nr_parts : 0);
 	if (r)
-- 
1.7.4.1



