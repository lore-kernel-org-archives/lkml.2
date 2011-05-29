Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab1E2NtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 09:49:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54282 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab1E2NtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 09:49:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Jb0OdSkytaFLbywKHG4BW8vDQjC1WVLt7/ieYEyddcEfwStaXiQXy/z9+VXmADBMfl
         eizO1/BHcQ+drZpITCkoI4enwkICU8AwbzH1aP56iY/yU/7ggxeHwCfnNE7jroTUwi0Z
         zb4o8Fa9Lyo+Vsqqg3sg66rPAAWbS5jiTViNU=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] ATMEL, AVR32: inline nand partition table access
Date: Sun, 29 May 2011 17:49:22 +0400
Message-Id: <1306676962-22308-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently atmel_nand driver used by AT91 and AVR32 calls a special callback
which return nand partition table and number of partitions. However in all
boards this callback returns just static data. So drop this callback and
make atmel_nand use partition table provided statically via platform_data.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 arch/arm/mach-at91/board-afeb-9260v1.c      |    9 ++-------
 arch/arm/mach-at91/board-cam60.c            |    9 ++-------
 arch/arm/mach-at91/board-cap9adk.c          |    9 ++-------
 arch/arm/mach-at91/board-kb9202.c           |    9 ++-------
 arch/arm/mach-at91/board-neocore926.c       |    9 ++-------
 arch/arm/mach-at91/board-qil-a9260.c        |    9 ++-------
 arch/arm/mach-at91/board-rm9200dk.c         |    9 ++-------
 arch/arm/mach-at91/board-sam9-l9260.c       |    9 ++-------
 arch/arm/mach-at91/board-sam9260ek.c        |    9 ++-------
 arch/arm/mach-at91/board-sam9261ek.c        |    9 ++-------
 arch/arm/mach-at91/board-sam9263ek.c        |    9 ++-------
 arch/arm/mach-at91/board-sam9g20ek.c        |    9 ++-------
 arch/arm/mach-at91/board-sam9m10g45ek.c     |    9 ++-------
 arch/arm/mach-at91/board-sam9rlek.c         |    9 ++-------
 arch/arm/mach-at91/board-snapper9260.c      |   10 ++--------
 arch/arm/mach-at91/board-usb-a9260.c        |    9 ++-------
 arch/arm/mach-at91/board-usb-a9263.c        |    9 ++-------
 arch/arm/mach-at91/board-yl-9200.c          |    9 ++-------
 arch/arm/mach-at91/include/mach/board.h     |    3 ++-
 arch/avr32/boards/atngw100/setup.c          |    8 ++------
 arch/avr32/boards/atstk1000/atstk1002.c     |    9 ++-------
 arch/avr32/mach-at32ap/include/mach/board.h |    3 ++-
 drivers/mtd/nand/atmel_nand.c               |    7 ++++---
 23 files changed, 48 insertions(+), 145 deletions(-)

diff --git a/arch/arm/mach-at91/board-afeb-9260v1.c b/arch/arm/mach-at91/board-afeb-9260v1.c
index a4924de..78c77fc 100644
--- a/arch/arm/mach-at91/board-afeb-9260v1.c
+++ b/arch/arm/mach-at91/board-afeb-9260v1.c
@@ -136,19 +136,14 @@ static struct mtd_partition __initdata afeb9260_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(afeb9260_nand_partition);
-	return afeb9260_nand_partition;
-}
-
 static struct atmel_nand_data __initdata afeb9260_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 	.rdy_pin	= AT91_PIN_PC13,
 	.enable_pin	= AT91_PIN_PC14,
-	.partition_info	= nand_partitions,
 	.bus_width_16	= 0,
+	.parts		= afeb9260_nand_partition,
+	.num_parts	= ARRAY_SIZE(afeb9260_nand_partition),
 };
 
 
diff --git a/arch/arm/mach-at91/board-cam60.c b/arch/arm/mach-at91/board-cam60.c
index 148fccb..eefae5b 100644
--- a/arch/arm/mach-at91/board-cam60.c
+++ b/arch/arm/mach-at91/board-cam60.c
@@ -138,19 +138,14 @@ static struct mtd_partition __initdata cam60_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(cam60_nand_partition);
-	return cam60_nand_partition;
-}
-
 static struct atmel_nand_data __initdata cam60_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 	// .det_pin	= ... not there
 	.rdy_pin	= AT91_PIN_PA9,
 	.enable_pin	= AT91_PIN_PA7,
-	.partition_info	= nand_partitions,
+	.parts		= cam60_nand_partition,
+	.num_parts	= ARRAY_SIZE(cam60_nand_partition),
 };
 
 static struct sam9_smc_config __initdata cam60_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-cap9adk.c b/arch/arm/mach-at91/board-cap9adk.c
index 1904fdf..8aaa6e6 100644
--- a/arch/arm/mach-at91/board-cap9adk.c
+++ b/arch/arm/mach-at91/board-cap9adk.c
@@ -175,19 +175,14 @@ static struct mtd_partition __initdata cap9adk_nand_partitions[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(cap9adk_nand_partitions);
-	return cap9adk_nand_partitions;
-}
-
 static struct atmel_nand_data __initdata cap9adk_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
 //	.rdy_pin	= ... not connected
 	.enable_pin	= AT91_PIN_PD15,
-	.partition_info	= nand_partitions,
+	.parts		= cap9adk_nand_partitions,
+	.num_parts	= ARRAY_SIZE(cap9adk_nand_partitions),
 };
 
 static struct sam9_smc_config __initdata cap9adk_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-kb9202.c b/arch/arm/mach-at91/board-kb9202.c
index a813a74..0cac9d3 100644
--- a/arch/arm/mach-at91/board-kb9202.c
+++ b/arch/arm/mach-at91/board-kb9202.c
@@ -102,19 +102,14 @@ static struct mtd_partition __initdata kb9202_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(kb9202_nand_partition);
-	return kb9202_nand_partition;
-}
-
 static struct atmel_nand_data __initdata kb9202_nand_data = {
 	.ale		= 22,
 	.cle		= 21,
 	// .det_pin	= ... not there
 	.rdy_pin	= AT91_PIN_PC29,
 	.enable_pin	= AT91_PIN_PC28,
-	.partition_info	= nand_partitions,
+	.parts		= kb9202_nand_partition,
+	.num_parts	= ARRAY_SIZE(kb9202_nand_partition),
 };
 
 static void __init kb9202_board_init(void)
diff --git a/arch/arm/mach-at91/board-neocore926.c b/arch/arm/mach-at91/board-neocore926.c
index 961e805..a63a4c9 100644
--- a/arch/arm/mach-at91/board-neocore926.c
+++ b/arch/arm/mach-at91/board-neocore926.c
@@ -188,19 +188,14 @@ static struct mtd_partition __initdata neocore926_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(neocore926_nand_partition);
-	return neocore926_nand_partition;
-}
-
 static struct atmel_nand_data __initdata neocore926_nand_data = {
 	.ale			= 21,
 	.cle			= 22,
 	.rdy_pin		= AT91_PIN_PB19,
 	.rdy_pin_active_low	= 1,
 	.enable_pin		= AT91_PIN_PD15,
-	.partition_info		= nand_partitions,
+	.parts			= neocore926_nand_partition,
+	.num_parts		= ARRAY_SIZE(neocore926_nand_partition),
 };
 
 static struct sam9_smc_config __initdata neocore926_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-qil-a9260.c b/arch/arm/mach-at91/board-qil-a9260.c
index d1a6001..86c163f 100644
--- a/arch/arm/mach-at91/board-qil-a9260.c
+++ b/arch/arm/mach-at91/board-qil-a9260.c
@@ -136,19 +136,14 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(ek_nand_partition);
-	return ek_nand_partition;
-}
-
 static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
 	.rdy_pin	= AT91_PIN_PC13,
 	.enable_pin	= AT91_PIN_PC14,
-	.partition_info	= nand_partitions,
+	.parts		= ek_nand_partition,
+	.num_parts	= ARRAY_SIZE(ek_nand_partition),
 };
 
 static struct sam9_smc_config __initdata ek_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-rm9200dk.c b/arch/arm/mach-at91/board-rm9200dk.c
index aef9627..7c9af30 100644
--- a/arch/arm/mach-at91/board-rm9200dk.c
+++ b/arch/arm/mach-at91/board-rm9200dk.c
@@ -143,19 +143,14 @@ static struct mtd_partition __initdata dk_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(dk_nand_partition);
-	return dk_nand_partition;
-}
-
 static struct atmel_nand_data __initdata dk_nand_data = {
 	.ale		= 22,
 	.cle		= 21,
 	.det_pin	= AT91_PIN_PB1,
 	.rdy_pin	= AT91_PIN_PC2,
 	// .enable_pin	= ... not there
-	.partition_info	= nand_partitions,
+	.parts		= dk_nand_partition,
+	.num_parts	= ARRAY_SIZE(dk_nand_partition),
 };
 
 #define DK_FLASH_BASE	AT91_CHIPSELECT_0
diff --git a/arch/arm/mach-at91/board-sam9-l9260.c b/arch/arm/mach-at91/board-sam9-l9260.c
index aaf1bf0..3646c2b 100644
--- a/arch/arm/mach-at91/board-sam9-l9260.c
+++ b/arch/arm/mach-at91/board-sam9-l9260.c
@@ -137,19 +137,14 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(ek_nand_partition);
-	return ek_nand_partition;
-}
-
 static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
 	.rdy_pin	= AT91_PIN_PC13,
 	.enable_pin	= AT91_PIN_PC14,
-	.partition_info	= nand_partitions,
+	.parts		= ek_nand_partition,
+	.num_parts	= ARRAY_SIZE(ek_nand_partition),
 };
 
 static struct sam9_smc_config __initdata ek_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-sam9260ek.c b/arch/arm/mach-at91/board-sam9260ek.c
index d600dc1..d6d9b21 100644
--- a/arch/arm/mach-at91/board-sam9260ek.c
+++ b/arch/arm/mach-at91/board-sam9260ek.c
@@ -179,19 +179,14 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(ek_nand_partition);
-	return ek_nand_partition;
-}
-
 static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
 	.rdy_pin	= AT91_PIN_PC13,
 	.enable_pin	= AT91_PIN_PC14,
-	.partition_info	= nand_partitions,
+	.parts		= ek_nand_partition,
+	.num_parts	= ARRAY_SIZE(ek_nand_partition),
 };
 
 static struct sam9_smc_config __initdata ek_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
index f897f84..b4a3e18 100644
--- a/arch/arm/mach-at91/board-sam9261ek.c
+++ b/arch/arm/mach-at91/board-sam9261ek.c
@@ -185,19 +185,14 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(ek_nand_partition);
-	return ek_nand_partition;
-}
-
 static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 22,
 	.cle		= 21,
 //	.det_pin	= ... not connected
 	.rdy_pin	= AT91_PIN_PC15,
 	.enable_pin	= AT91_PIN_PC14,
-	.partition_info	= nand_partitions,
+	.parts		= ek_nand_partition,
+	.num_parts	= ARRAY_SIZE(ek_nand_partition),
 };
 
 static struct sam9_smc_config __initdata ek_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-sam9263ek.c b/arch/arm/mach-at91/board-sam9263ek.c
index 605b26f..4e6d586 100644
--- a/arch/arm/mach-at91/board-sam9263ek.c
+++ b/arch/arm/mach-at91/board-sam9263ek.c
@@ -186,19 +186,14 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(ek_nand_partition);
-	return ek_nand_partition;
-}
-
 static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
 	.rdy_pin	= AT91_PIN_PA22,
 	.enable_pin	= AT91_PIN_PD15,
-	.partition_info	= nand_partitions,
+	.parts		= ek_nand_partition,
+	.num_parts	= ARRAY_SIZE(ek_nand_partition),
 };
 
 static struct sam9_smc_config __initdata ek_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-sam9g20ek.c b/arch/arm/mach-at91/board-sam9g20ek.c
index 7624cf0..b0488b1 100644
--- a/arch/arm/mach-at91/board-sam9g20ek.c
+++ b/arch/arm/mach-at91/board-sam9g20ek.c
@@ -163,19 +163,14 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(ek_nand_partition);
-	return ek_nand_partition;
-}
-
 /* det_pin is not connected */
 static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 	.rdy_pin	= AT91_PIN_PC13,
 	.enable_pin	= AT91_PIN_PC14,
-	.partition_info	= nand_partitions,
+	.parts		= ek_nand_partition,
+	.num_parts	= ARRAY_SIZE(ek_nand_partition),
 };
 
 static struct sam9_smc_config __initdata ek_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 063c95d..0bb3468 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -143,19 +143,14 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(ek_nand_partition);
-	return ek_nand_partition;
-}
-
 /* det_pin is not connected */
 static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 	.rdy_pin	= AT91_PIN_PC8,
 	.enable_pin	= AT91_PIN_PC14,
-	.partition_info	= nand_partitions,
+	.parts		= ek_nand_partition,
+	.num_parts	= ARRAY_SIZE(ek_nand_partition),
 };
 
 static struct sam9_smc_config __initdata ek_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index effb399..7aee8ab 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -94,19 +94,14 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	},
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(ek_nand_partition);
-	return ek_nand_partition;
-}
-
 static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
 	.rdy_pin	= AT91_PIN_PD17,
 	.enable_pin	= AT91_PIN_PB6,
-	.partition_info	= nand_partitions,
+	.parts		= ek_nand_partition,
+	.num_parts	= ARRAY_SIZE(ek_nand_partition),
 };
 
 static struct sam9_smc_config __initdata ek_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
index 3eb0a11..a481451 100644
--- a/arch/arm/mach-at91/board-snapper9260.c
+++ b/arch/arm/mach-at91/board-snapper9260.c
@@ -102,18 +102,12 @@ static struct mtd_partition __initdata snapper9260_nand_partitions[] = {
 	},
 };
 
-static struct mtd_partition * __init
-snapper9260_nand_partition_info(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(snapper9260_nand_partitions);
-	return snapper9260_nand_partitions;
-}
-
 static struct atmel_nand_data __initdata snapper9260_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 	.rdy_pin	= AT91_PIN_PC13,
-	.partition_info	= snapper9260_nand_partition_info,
+	.parts		= snapper9260_nand_partitions,
+	.num_parts	= ARRAY_SIZE(snapper9260_nand_partitions),
 	.bus_width_16	= 0,
 };
 
diff --git a/arch/arm/mach-at91/board-usb-a9260.c b/arch/arm/mach-at91/board-usb-a9260.c
index 0e784e6..43f40ef 100644
--- a/arch/arm/mach-at91/board-usb-a9260.c
+++ b/arch/arm/mach-at91/board-usb-a9260.c
@@ -110,19 +110,14 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	}
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(ek_nand_partition);
-	return ek_nand_partition;
-}
-
 static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
 	.rdy_pin	= AT91_PIN_PC13,
 	.enable_pin	= AT91_PIN_PC14,
-	.partition_info	= nand_partitions,
+	.parts		= ek_nand_partition,
+	.num_parts	= ARRAY_SIZE(ek_nand_partition),
 };
 
 static struct sam9_smc_config __initdata ek_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-usb-a9263.c b/arch/arm/mach-at91/board-usb-a9263.c
index cf626dd..288d764 100644
--- a/arch/arm/mach-at91/board-usb-a9263.c
+++ b/arch/arm/mach-at91/board-usb-a9263.c
@@ -123,19 +123,14 @@ static struct mtd_partition __initdata ek_nand_partition[] = {
 	}
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(ek_nand_partition);
-	return ek_nand_partition;
-}
-
 static struct atmel_nand_data __initdata ek_nand_data = {
 	.ale		= 21,
 	.cle		= 22,
 //	.det_pin	= ... not connected
 	.rdy_pin	= AT91_PIN_PA22,
 	.enable_pin	= AT91_PIN_PD15,
-	.partition_info	= nand_partitions,
+	.parts		= ek_nand_partition,
+	.num_parts	= ARRAY_SIZE(ek_nand_partition),
 };
 
 static struct sam9_smc_config __initdata ek_nand_smc_config = {
diff --git a/arch/arm/mach-at91/board-yl-9200.c b/arch/arm/mach-at91/board-yl-9200.c
index c208cc3..9ebc1ed 100644
--- a/arch/arm/mach-at91/board-yl-9200.c
+++ b/arch/arm/mach-at91/board-yl-9200.c
@@ -178,19 +178,14 @@ static struct mtd_partition __initdata yl9200_nand_partition[] = {
 	}
 };
 
-static struct mtd_partition * __init nand_partitions(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(yl9200_nand_partition);
-	return yl9200_nand_partition;
-}
-
 static struct atmel_nand_data __initdata yl9200_nand_data = {
 	.ale		= 6,
 	.cle		= 7,
 	// .det_pin	= ... not connected
 	.rdy_pin	= AT91_PIN_PC14,	/* R/!B (Sheet10) */
 	.enable_pin	= AT91_PIN_PC15,	/* !CE  (Sheet10) */
-	.partition_info	= nand_partitions,
+	.parts		= yl9200_nand_partition,
+	.num_parts	= ARRAY_SIZE(yl9200_nand_partition),
 };
 
 /*
diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index ed544a0..6643531 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -112,7 +112,8 @@ struct atmel_nand_data {
 	u8		ale;		/* address line number connected to ALE */
 	u8		cle;		/* address line number connected to CLE */
 	u8		bus_width_16;	/* buswidth is 16 bit */
-	struct mtd_partition* (*partition_info)(int, int*);
+	struct mtd_partition *parts;
+	unsigned int	num_parts;
 };
 extern void __init at91_add_device_nand(struct atmel_nand_data *data);
 
diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
index fafed4c..1f17bde 100644
--- a/arch/avr32/boards/atngw100/setup.c
+++ b/arch/avr32/boards/atngw100/setup.c
@@ -90,11 +90,6 @@ static struct mtd_partition nand_partitions[] = {
 	},
 };
 
-static struct mtd_partition *nand_part_info(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(nand_partitions);
-	return nand_partitions;
-}
 
 static struct atmel_nand_data atngw100mkii_nand_data __initdata = {
 	.cle		= 21,
@@ -102,7 +97,8 @@ static struct atmel_nand_data atngw100mkii_nand_data __initdata = {
 	.rdy_pin	= GPIO_PIN_PB(28),
 	.enable_pin	= GPIO_PIN_PE(23),
 	.bus_width_16	= true,
-	.partition_info	= nand_part_info,
+	.parts		= nand_partitions,
+	.num_parts	= ARRAY_SIZE(nand_partitions),
 };
 #endif
 
diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index 6ce30fb..4643ff5 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -90,18 +90,13 @@ static struct mtd_partition nand_partitions[] = {
 	},
 };
 
-static struct mtd_partition *nand_part_info(int size, int *num_partitions)
-{
-	*num_partitions = ARRAY_SIZE(nand_partitions);
-	return nand_partitions;
-}
-
 static struct atmel_nand_data atstk1006_nand_data __initdata = {
 	.cle		= 21,
 	.ale		= 22,
 	.rdy_pin	= GPIO_PIN_PB(30),
 	.enable_pin	= GPIO_PIN_PB(29),
-	.partition_info	= nand_part_info,
+	.parts		= nand_partitions,
+	.num_parts	= ARRAY_SIZE(num_partitions),
 };
 #endif
 
diff --git a/arch/avr32/mach-at32ap/include/mach/board.h b/arch/avr32/mach-at32ap/include/mach/board.h
index 679458d..5d7ffca 100644
--- a/arch/avr32/mach-at32ap/include/mach/board.h
+++ b/arch/avr32/mach-at32ap/include/mach/board.h
@@ -128,7 +128,8 @@ struct atmel_nand_data {
 	u8	ale;		/* address line number connected to ALE */
 	u8	cle;		/* address line number connected to CLE */
 	u8	bus_width_16;	/* buswidth is 16 bit */
-	struct mtd_partition *(*partition_info)(int size, int *num_partitions);
+	struct mtd_partition *parts;
+	unsigned int	num_parts;
 };
 struct platform_device *
 at32_add_device_nand(unsigned int id, struct atmel_nand_data *data);
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index b300705..10605ed 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -659,9 +659,10 @@ static int __init atmel_nand_probe(struct platform_device *pdev)
 	num_partitions = parse_mtd_partitions(mtd, part_probes,
 					      &partitions, 0);
 #endif
-	if (num_partitions <= 0 && host->board->partition_info)
-		partitions = host->board->partition_info(mtd->size,
-							 &num_partitions);
+	if (num_partitions <= 0 && host->board->parts) {
+		partitions = host->board->parts;
+		num_partitions = host->board->num_parts;
+	}
 
 	if ((!partitions) || (num_partitions == 0)) {
 		printk(KERN_ERR "atmel_nand: No partitions defined, or unsupported device.\n");
-- 
1.7.4.4

