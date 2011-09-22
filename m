Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1IVFgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 01:36:15 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:53399 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1IVFgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 01:36:12 -0400
Date: Thu, 22 Sep 2011 15:36:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the l2-mtd tree with the at91 tree
Message-Id: <20110922153609.2bed2393969ac4283dc360d6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

Today's linux-next merge of the l2-mtd tree got conflicts in
arch/arm/mach-at91/board-afeb-9260v1.c,
arch/arm/mach-at91/board-neocore926.c. arch/arm/mach-at91/board-rm9200dk.c,
arch/arm/mach-at91/board-sam9g20ek.c and
arch/arm/mach-at91/board-sam9m10g45ek.c between commit 36706ab70b26
("ARM: at91/boards: use -EINVAL for invalid gpio") from the at91 tree and
commit 1754aab9bb86 ("mtd: ATMEL, AVR32: inline nand partition table
access") from the l2-mtd tree.

Just context changes.  I fixed them up (see below) and can carry the
fixes as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-at91/board-afeb-9260v1.c
index 2d92043,a053e91..0000000
--- a/arch/arm/mach-at91/board-afeb-9260v1.c
+++ b/arch/arm/mach-at91/board-afeb-9260v1.c
@@@ -142,9 -135,9 +136,10 @@@ static struct atmel_nand_data __initdat
  	.cle		= 22,
  	.rdy_pin	= AT91_PIN_PC13,
  	.enable_pin	= AT91_PIN_PC14,
- 	.partition_info	= nand_partitions,
  	.bus_width_16	= 0,
 +	.det_pin	= -EINVAL,
+ 	.parts		= afeb9260_nand_partition,
+ 	.num_parts	= ARRAY_SIZE(afeb9260_nand_partition),
  };
  
  
diff --cc arch/arm/mach-at91/board-neocore926.c
index 0e6b86e,60f0cee..0000000
--- a/arch/arm/mach-at91/board-neocore926.c
+++ b/arch/arm/mach-at91/board-neocore926.c
@@@ -195,8 -188,8 +189,9 @@@ static struct atmel_nand_data __initdat
  	.rdy_pin		= AT91_PIN_PB19,
  	.rdy_pin_active_low	= 1,
  	.enable_pin		= AT91_PIN_PD15,
- 	.partition_info		= nand_partitions,
 +	.det_pin		= -EINVAL,
+ 	.parts			= neocore926_nand_partition,
+ 	.num_parts		= ARRAY_SIZE(neocore926_nand_partition),
  };
  
  static struct sam9_smc_config __initdata neocore926_nand_smc_config = {
diff --cc arch/arm/mach-at91/board-rm9200dk.c
index e34e84e,b5f2faf..0000000
--- a/arch/arm/mach-at91/board-rm9200dk.c
+++ b/arch/arm/mach-at91/board-rm9200dk.c
@@@ -153,8 -143,9 +147,9 @@@ static struct atmel_nand_data __initdat
  	.cle		= 21,
  	.det_pin	= AT91_PIN_PB1,
  	.rdy_pin	= AT91_PIN_PC2,
 -	// .enable_pin	= ... not there
 +	.enable_pin	= -EINVAL,
- 	.partition_info	= nand_partitions,
+ 	.parts		= dk_nand_partition,
+ 	.num_parts	= ARRAY_SIZE(dk_nand_partition),
  };
  
  #define DK_FLASH_BASE	AT91_CHIPSELECT_0
diff --cc arch/arm/mach-at91/board-sam9g20ek.c
index 757d74f,0031227..0000000
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@@ -170,8 -163,8 +164,9 @@@ static struct atmel_nand_data __initdat
  	.cle		= 22,
  	.rdy_pin	= AT91_PIN_PC13,
  	.enable_pin	= AT91_PIN_PC14,
- 	.partition_info	= nand_partitions,
 +	.det_pin	= -EINVAL,
+ 	.parts		= ek_nand_partition,
+ 	.num_parts	= ARRAY_SIZE(ek_nand_partition),
  };
  
  static struct sam9_smc_config __initdata ek_nand_smc_config = {
diff --cc arch/arm/mach-at91/board-sam9m10g45ek.c
index e3694b1,00d041c..0000000
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@@ -150,8 -143,8 +144,9 @@@ static struct atmel_nand_data __initdat
  	.cle		= 22,
  	.rdy_pin	= AT91_PIN_PC8,
  	.enable_pin	= AT91_PIN_PC14,
- 	.partition_info	= nand_partitions,
 +	.det_pin	= -EINVAL,
+ 	.parts		= ek_nand_partition,
+ 	.num_parts	= ARRAY_SIZE(ek_nand_partition),
  };
  
  static struct sam9_smc_config __initdata ek_nand_smc_config = {
