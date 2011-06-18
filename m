Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1FRBkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 21:40:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65295 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1FRBkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 21:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=aIo1/lFZB3i083asP0tZtU3diIvExXZXb8Kn0Af82ojnq0Xu1xp6Y0u2tBCQpUAqW+
         zhrZuI6l4HkOZMDxAYiXdmoOSYFbXU6fPbywcgtA6vnnXWGP67g2Qhl4ZfC1Gjv7ohgU
         xI5C9+8tClqWget5Pm3T3cy12+1J3gNTemOmU=
Subject: [PATCH 2/2 v2] mtd: onenand/samsung.c: fix build error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Brian Norris <computersforpeace@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Jun 2011 09:40:00 +0800
Message-ID: <1308361200.2400.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:
  CC      drivers/mtd/onenand/samsung.o
drivers/mtd/onenand/samsung.c: In function 's3c_onenand_probe':
drivers/mtd/onenand/samsung.c:1017: error: 'info' undeclared (first use in this function)
drivers/mtd/onenand/samsung.c:1017: error: (Each undeclared identifier is reported only once
drivers/mtd/onenand/samsung.c:1017: error: for each function it appears in.)
make[3]: *** [drivers/mtd/onenand/samsung.o] Error 1
make[2]: *** [drivers/mtd/onenand] Error 2
make[1]: *** [drivers/mtd] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/onenand/samsung.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/onenand/samsung.c b/drivers/mtd/onenand/samsung.c
index 597dffc..a0ef087 100644
--- a/drivers/mtd/onenand/samsung.c
+++ b/drivers/mtd/onenand/samsung.c
@@ -1014,7 +1014,7 @@ static int s3c_onenand_probe(struct platform_device *pdev)
 	if (s3c_read_reg(MEM_CFG_OFFSET) & ONENAND_SYS_CFG1_SYNC_READ)
 		dev_info(&onenand->pdev->dev, "OneNAND Sync. Burst Read enabled\n");
 
-	err = mtd_device_parse_register(&info->mtd, NULL, 0,
+	err = mtd_device_parse_register(mtd, NULL, 0,
 			pdata ? pdata->parts : NULL,
 			pdata ? pdata->nr_parts : 0);
 
-- 
1.7.4.1



