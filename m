Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab1EZRQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 13:16:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31681 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab1EZRQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 13:16:39 -0400
Date: Thu, 26 May 2011 10:16:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH -next] regulator: fix 88pm8607.c printk format warning
Message-Id: <20110526101615.61d5ed27.randy.dunlap@oracle.com>
In-Reply-To: <20110526170756.GA20068@sortiz-mobl>
References: <20110518145412.f6cba4ef.sfr@canb.auug.org.au>
	<20110518100722.76bd6fb6.randy.dunlap@oracle.com>
	<20110518194311.GB5077@opensource.wolfsonmicro.com>
	<1305978663.3317.7.camel@odin>
	<20110526090522.5d8c684b.randy.dunlap@oracle.com>
	<20110526170756.GA20068@sortiz-mobl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4DDE8AEC.007C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning (seen on x86_64) and change to unsigned
output format:

drivers/regulator/88pm8607.c:417: warning: format '%d' expects type 'int', but argument 3 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
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
