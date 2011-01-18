Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab1ARTWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:22:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42322 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867Ab1ARTWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:22:13 -0500
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net, sameo@linux.intel.com,
        rpurdie@rpsys.net, dbrownell@users.sourceforge.net
Cc: c-park@ti.com, linux-arm-kernel@lists.arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v8 09/11] davinci: add tnetv107x evm ti-ssp gpio device
Date: Tue, 18 Jan 2011 14:21:43 -0500
Message-Id: <1295378505-15221-10-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295378505-15221-1-git-send-email-cyril@ti.com>
References: <1295378505-15221-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds definitions to hook up one of the ti-ssp ports to the SSP GPIO
driver.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/board-tnetv107x-evm.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index ca23516..e3863dd 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -39,6 +39,8 @@
 #include <mach/cp_intc.h>
 #include <mach/tnetv107x.h>
 
+#define SSP_GPIO_START		128
+
 #define EVM_MMC_WP_GPIO		21
 #define EVM_MMC_CD_GPIO		24
 #define EVM_SPI_CS_GPIO		54
@@ -238,9 +240,18 @@ static struct ti_ssp_spi_data spi_master_data = {
 		  SSP_INPUT_SEL(3),
 };
 
+static struct ti_ssp_gpio_data ssp_gpio_data = {
+	.start		= SSP_GPIO_START,
+};
+
 static struct ti_ssp_data ssp_config = {
 	.out_clock	= 250 * 1000,
 	.dev_data	= {
+		[0] = {
+			.dev_name = "ti-ssp-gpio",
+			.pdata = &ssp_gpio_data,
+			.pdata_size = sizeof(ssp_gpio_data),
+		},
 		[1] = {
 			.dev_name = "ti-ssp-spi",
 			.pdata = &spi_master_data,
-- 
1.7.1

