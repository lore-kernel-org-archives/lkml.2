Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1CXUbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:31:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53932 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1CXUbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:31:15 -0400
Date: Thu, 24 Mar 2011 13:30:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Cyril Chemparathy <cyril@ti.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] regulator: fix tps6524x section mismatch
Message-Id: <20110324133059.eb17c442.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D8BAA09.0099,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch that is caused by init code calling exit code:
pmic_remove() cannot be marked as __devexit.

WARNING: drivers/regulator/tps6524x-regulator.o(.devinit.text+0x205): Section mismatch in reference from the function pmic_probe() to the function .devexit.text:pmic_remove()
The function __devinit pmic_probe() references
a function __devexit pmic_remove().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
pmic_remove() so it may be used outside an exit section.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Liam Girdwood <lrg@slimlogic.co.uk>
Cc:	Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc:	Cyril Chemparathy <cyril@ti.com>
---
 drivers/regulator/tps6524x-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.38-git13.orig/drivers/regulator/tps6524x-regulator.c
+++ linux-2.6.38-git13/drivers/regulator/tps6524x-regulator.c
@@ -596,7 +596,7 @@ static struct regulator_ops regulator_op
 	.get_current_limit	= get_current_limit,
 };
 
-static int __devexit pmic_remove(struct spi_device *spi)
+static int pmic_remove(struct spi_device *spi)
 {
 	struct tps6524x *hw = spi_get_drvdata(spi);
 	int i;
