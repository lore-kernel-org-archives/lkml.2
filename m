Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab0HaCON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:14:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53884 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab0HaCOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:14:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q0MnzcEcNeA3Bsdfe7c538gP63ToM+3HV2JqVO+OKzfellEa7TBg4cifTtskNQVIEc
         RW9CjByeixU3hMQMlxkXlIjmNmEyaHA4dSQ7WkHK/8xoQQEsKuTgRV9hRDo0b1sOeHtZ
         hu1+0AfBYMkGfGE4Z2xcQAIKMckN/ppXYV06k=
From: "Mark F. Brown" <mark.brown314@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Mark F. Brown" <mark.brown314@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "Mark F. Brown" <mark.brown314@gmail.com>
Subject: [PATCH] ARM: pxa3xx: fix build error when CONFIG_MTD_PARTITIONS is not defined
Date: Thu, 26 Aug 2010 04:56:51 -0400
Message-Id: <1282813011-6187-2-git-send-email-mark.brown314@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282813011-6187-1-git-send-email-mark.brown314@gmail.com>
References: <1282813011-6187-1-git-send-email-mark.brown314@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
---
 drivers/mtd/nand/pxa3xx_nand.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/nand/pxa3xx_nand.c b/drivers/mtd/nand/pxa3xx_nand.c
index 4d89f37..4d01cda 100644
--- a/drivers/mtd/nand/pxa3xx_nand.c
+++ b/drivers/mtd/nand/pxa3xx_nand.c
@@ -1320,6 +1320,7 @@ static int pxa3xx_nand_probe(struct platform_device *pdev)
 		goto fail_free_irq;
 	}
 
+#ifdef CONFIG_MTD_PARTITIONS
 	if (mtd_has_cmdlinepart()) {
 		static const char *probes[] = { "cmdlinepart", NULL };
 		struct mtd_partition *parts;
@@ -1332,6 +1333,9 @@ static int pxa3xx_nand_probe(struct platform_device *pdev)
 	}
 
 	return add_mtd_partitions(mtd, pdata->parts, pdata->nr_parts);
+#else
+	return 0;
+#endif
 
 fail_free_irq:
 	free_irq(irq, info);
@@ -1364,7 +1368,9 @@ static int pxa3xx_nand_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 
 	del_mtd_device(mtd);
+#ifdef CONFIG_MTD_PARTITIONS
 	del_mtd_partitions(mtd);
+#endif
 	irq = platform_get_irq(pdev, 0);
 	if (irq >= 0)
 		free_irq(irq, info);
-- 
1.7.0.4

