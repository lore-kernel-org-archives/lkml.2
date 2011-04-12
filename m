Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab1DLTtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:49:33 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1055 "HELO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756813Ab1DLTta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:49:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 11419
From: Lars-Peter Clausen <lars@metafoo.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] ARM: s3c2440: GTA02: Disable hardware ECC by default
Date: Tue, 12 Apr 2011 21:47:52 +0200
Message-Id: <1302637672-25339-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1302637672-25339-1-git-send-email-lars@metafoo.de>
References: <1302637672-25339-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Early versions of uboot used for the GTA02 flashed the NAND with ECC information
incompatible to s3c2440 hardware ECC. Disable hardware error correction by
default, unless the bootloader explicitly enables it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 arch/arm/mach-s3c2440/mach-gta02.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s3c2440/mach-gta02.c b/arch/arm/mach-s3c2440/mach-gta02.c
index 0db2411..b14d91f 100644
--- a/arch/arm/mach-s3c2440/mach-gta02.c
+++ b/arch/arm/mach-s3c2440/mach-gta02.c
@@ -445,6 +445,7 @@ static struct s3c2410_platform_nand __initdata gta02_nand_info = {
 	.twrph1		= 15,
 	.nr_sets	= ARRAY_SIZE(gta02_nand_sets),
 	.sets		= gta02_nand_sets,
+	.software_ecc	= 1,
 };
 
 
@@ -563,6 +564,14 @@ static void gta02_poweroff(void)
 	pcf50633_reg_set_bit_mask(gta02_pcf, PCF50633_REG_OOCSHDWN, 1, 1);
 }
 
+static int __init hardware_ecc_setup(char *str)
+{
+	if (str && str[0] == '1')
+		gta02_nand_info.software_ecc = 0;
+	return 1;
+}
+__setup("hardware_ecc=", hardware_ecc_setup);
+
 static void __init gta02_machine_init(void)
 {
 	/* Set the panic callback to turn AUX LED on or off. */
-- 
1.7.2.5

