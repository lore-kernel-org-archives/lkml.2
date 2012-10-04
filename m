Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2JDKPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:15:24 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34187 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab2JDKPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:15:21 -0400
From: Matt Porter <mporter@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, gururaja.hebbar@ti.com,
        Sekhar Nori <nsekhar@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alsa Devel List <alsa-devel@alsa-project.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Daniel Mack <zonque@gmail.com>
Subject: [PATCH 2/2] ARM: davinci: enable SRAM ping ping buffering on DA850
Date: Thu,  4 Oct 2012 06:15:45 -0400
Message-Id: <1349345745-10584-3-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349345745-10584-1-git-send-email-mporter@ti.com>
References: <1349345745-10584-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passes the DA850 shared SRAM gen_pool to the McASP driver
and enables the ping-pong buffer DMA support.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/mach-davinci/board-da850-evm.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index acc6e84..c14ca9d 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -750,16 +750,19 @@ static u8 da850_iis_serializer_direction[] = {
 };
 
 static struct snd_platform_data da850_evm_snd_data = {
-	.tx_dma_offset	= 0x2000,
-	.rx_dma_offset	= 0x2000,
-	.op_mode	= DAVINCI_MCASP_IIS_MODE,
-	.num_serializer	= ARRAY_SIZE(da850_iis_serializer_direction),
-	.tdm_slots	= 2,
-	.serial_dir	= da850_iis_serializer_direction,
-	.asp_chan_q	= EVENTQ_0,
-	.version	= MCASP_VERSION_2,
-	.txnumevt	= 1,
-	.rxnumevt	= 1,
+	.tx_dma_offset		= 0x2000,
+	.rx_dma_offset		= 0x2000,
+	.op_mode		= DAVINCI_MCASP_IIS_MODE,
+	.num_serializer		= ARRAY_SIZE(da850_iis_serializer_direction),
+	.tdm_slots		= 2,
+	.serial_dir		= da850_iis_serializer_direction,
+	.asp_chan_q		= EVENTQ_0,
+	.ram_chan_q		= EVENTQ_1,
+	.version		= MCASP_VERSION_2,
+	.txnumevt		= 1,
+	.rxnumevt		= 1,
+	.sram_size_playback	= SZ_8K,
+	.sram_size_capture	= SZ_8K,
 };
 
 static const short da850_evm_mcasp_pins[] __initconst = {
@@ -1338,6 +1341,7 @@ static __init void da850_evm_init(void)
 		pr_warning("da850_evm_init: mcasp mux setup failed: %d\n",
 				ret);
 
+	da850_evm_snd_data.sram_pool = sram_get_gen_pool();
 	da8xx_register_mcasp(0, &da850_evm_snd_data);
 
 	ret = davinci_cfg_reg_list(da850_lcdcntl_pins);
-- 
1.7.9.5

