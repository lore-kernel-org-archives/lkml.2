Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1F3LxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:53:24 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56780 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab1F3LxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:53:18 -0400
Subject: [PATCH] mtd: fsl_upm: fix a memory leak in fun_chip_init error path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 19:53:09 +0800
Message-ID: <1309434789.3256.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mtd/nand/fsl_upm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index da92fed..b4f3cc9 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -196,6 +196,8 @@ static int __devinit fun_chip_init(struct fsl_upm_nand *fun,
 	ret = mtd_device_parse_register(&fun->mtd, NULL, &ppdata, NULL, 0);
 err:
 	of_node_put(flash_np);
+	if (ret)
+		kfree(fun->mtd.name);
 	return ret;
 }
 
-- 
1.7.4.1



