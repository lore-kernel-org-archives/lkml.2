Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab1ERRHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 13:07:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17648 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab1ERRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 13:07:44 -0400
Date: Wed, 18 May 2011 10:07:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH -next] regulator: fix 88pm8607.c printk format warning
Message-Id: <20110518100722.76bd6fb6.randy.dunlap@oracle.com>
In-Reply-To: <20110518145412.f6cba4ef.sfr@canb.auug.org.au>
References: <20110518145412.f6cba4ef.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4DD3FCD6.00C5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning (seen on x86_64) and change to unsigned
output format:

drivers/regulator/88pm8607.c:417: warning: format '%d' expects type 'int', but argument 3 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/regulator/88pm8607.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20110518.orig/drivers/regulator/88pm8607.c
+++ linux-next-20110518/drivers/regulator/88pm8607.c
@@ -413,8 +413,8 @@ static int __devinit pm8607_regulator_pr
 			break;
 	}
 	if ((i < 0) || (i > PM8607_ID_RG_MAX)) {
-		dev_err(&pdev->dev, "Failed to find regulator %d\n",
-			res->start);
+		dev_err(&pdev->dev, "Failed to find regulator %llu\n",
+			(unsigned long long)res->start);
 		return -EINVAL;
 	}
 	info->i2c = (chip->id == CHIP_PM8607) ? chip->client : chip->companion;
