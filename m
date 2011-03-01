Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab1CAGya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 01:54:30 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48767 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab1CAGy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 01:54:29 -0500
Date: Tue, 1 Mar 2011 17:54:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (devicetree
 tree related)
Message-Id: <20110301175425.50296d21.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mtd/nand/pasemi_nand.c:221: error: variable 'pasemi_nand_driver' has initializer but incomplete type
drivers/mtd/nand/pasemi_nand.c:223: error: unknown field 'driver' specified in initializer
drivers/mtd/nand/pasemi_nand.c:223: error: extra brace group at end of initializer
drivers/mtd/nand/pasemi_nand.c:223: error: (near initialization for 'pasemi_nand_driver')
drivers/mtd/nand/pasemi_nand.c:227: warning: excess elements in struct initializer
drivers/mtd/nand/pasemi_nand.c:227: warning: (near initialization for 'pasemi_nand_driver')
drivers/mtd/nand/pasemi_nand.c:228: error: unknown field 'probe' specified in initializer
drivers/mtd/nand/pasemi_nand.c:228: warning: excess elements in struct initializer
drivers/mtd/nand/pasemi_nand.c:228: warning: (near initialization for 'pasemi_nand_driver')
drivers/mtd/nand/pasemi_nand.c:229: error: unknown field 'remove' specified in initializer
drivers/mtd/nand/pasemi_nand.c:229: warning: excess elements in struct initializer
drivers/mtd/nand/pasemi_nand.c:229: warning: (near initialization for 'pasemi_nand_driver')
drivers/mtd/nand/pasemi_nand.c: In function 'pasemi_nand_init':
drivers/mtd/nand/pasemi_nand.c:234: warning: passing argument 1 of 'platform_driver_register' from incompatible pointer type
include/linux/platform_device.h:124: note: expected 'struct platform_driver *' but argument is of type 'struct latform_driver *'
drivers/mtd/nand/pasemi_nand.c: In function 'pasemi_nand_exit':
drivers/mtd/nand/pasemi_nand.c:240: warning: passing argument 1 of 'platform_driver_unregister' from incompatible pointer type
include/linux/platform_device.h:125: note: expected 'struct platform_driver *' but argument is of type 'struct latform_driver *'

Caused by commit ac677e82cd5c031a010458304821bb8b1e47cf24 ("dt: Eliminate
of_platform_{,un}register_driver").  Looks like a typo to me :-)

I applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 1 Mar 2011 17:51:33 +1100
Subject: [PATCH] dt: fix typo

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mtd/nand/pasemi_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index 5a0f1cf..59efa82 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -218,7 +218,7 @@ static const struct of_device_id pasemi_nand_match[] =
 
 MODULE_DEVICE_TABLE(of, pasemi_nand_match);
 
-static struct latform_driver pasemi_nand_driver =
+static struct platform_driver pasemi_nand_driver =
 {
 	.driver = {
 		.name = (char*)driver_name,
-- 
1.7.4.1

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
