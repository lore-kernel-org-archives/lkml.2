Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2DEQpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:45:08 -0400
Received: from nm2-vm0.bullet.mail.ird.yahoo.com ([77.238.189.199]:46057 "HELO
	nm2-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752169Ab2DEQpG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:45:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 536265.83786.bm@omp1014.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=c/Pq9I2Sj9aI+EFyDurGICDqbCNyP9qbMLEDoDGEzS6shyoQkfXMursfWw6+OgMtzqfYb2sOkzdc2/Gz7ZpGS22bloP+nLevd35Qy+Rju8uDFGXT21PVtLnaf6Z2MQlXSzWQHwys1q9Z85RZ17qs3kpqnfzSqfgpYHvE8zX3RaE=;
X-YMail-OSG: dokZbV4VM1mVcWIFi6wmUDbWZklsXvSp9mWmAsScN_otfgv
 mCPc6cJIOso3ifTy41T62L2qODT4nEmhVkjHK2D91G1mHiQI5b0rCan7Gy6V
 _IpAQ0oQxjhlrdwtnExfIZgEZOxgoDm__65TfBj0NB1LL7Y.tteyuf68vpri
 1bMmkMQ0L5WWTEkpUvi7BvnKa9gGUJz_9L7VA8zcCqCLnHTYZ0qR_LDyDAIb
 mbe1wG46xYZh91G532SHfQbY554YJXkv.CohneOuI1Y1qHLpM_Us251GEYkp
 ak1RJI6P2v0Q6qf.BDsZIVTVJNao04x8Z8YLo5b9QM01sVN2nksJoQMrQXIH
 HZkDk5SkUN5KpJinJr4.vCh71thprUw1XXjRY8Ojk7Gvs1hJ0zBGHbi9qaPK
 3SvzdodDc7D_rJ2pzxQ8nh0zLVgO7ZYxHJpeyyQCzfHE-
X-Mailer: YahooMailClassic/15.0.5 YahooMailWebService/0.8.117.340979
Message-ID: <1333644304.97070.YahooMailClassic@web29013.mail.ird.yahoo.com>
Date: Thu, 5 Apr 2012 17:45:04 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: [PATCH 3/3] mfd: asic3: Add PCMCIA/CF support
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a set which adds PCMCIA/CF support for the hx4700.
This patch adds asic3_set_register() calls to:
1. Enable the PCMCIA/CF in asic3_probe().
2. Disable the PCMCIA/CF in asic3_remove().

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/asic3.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 1895cf9..0c083e7 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -998,6 +998,9 @@ static int __init asic3_probe(struct platform_device *pdev)
 
 	asic3_mfd_probe(pdev, pdata, mem);
 
+	asic3_set_register(asic, ASIC3_OFFSET(EXTCF, SELECT),
+		(ASIC3_EXTCF_CF0_BUF_EN|ASIC3_EXTCF_CF0_PWAIT_EN), 1);
+
 	dev_info(asic->dev, "ASIC3 Core driver\n");
 
 	return 0;
@@ -1019,6 +1022,9 @@ static int __devexit asic3_remove(struct platform_device *pdev)
 	int ret;
 	struct asic3 *asic = platform_get_drvdata(pdev);
 
+	asic3_set_register(asic, ASIC3_OFFSET(EXTCF, SELECT),
+		(ASIC3_EXTCF_CF0_BUF_EN|ASIC3_EXTCF_CF0_PWAIT_EN), 0);
+
 	asic3_mfd_remove(pdev);
 
 	ret = asic3_gpio_remove(pdev);
-- 
1.7.3.4

