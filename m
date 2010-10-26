Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158Ab0JZUTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:19:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33829 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759970Ab0JZUTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 16:19:18 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com,
        spi-devel-general@lists.sourceforge.net,
        broonie@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        dbrownell@users.sourceforge.net, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rpurdie@rpsys.net
Cc: Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v4 09/12] davinci: add tnetv107x evm ti-ssp gpio device
Date: Tue, 26 Oct 2010 16:18:25 -0400
Message-Id: <1288124308-14999-10-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1288124308-14999-1-git-send-email-cyril@ti.com>
References: <1288124308-14999-1-git-send-email-cyril@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds definitions to hook up one of the ti-ssp ports to the SSP GPIO
driver.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 arch/arm/mach-davinci/board-tnetv107x-evm.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
index 42ae20f..e0acc13 100644
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ b/arch/arm/mach-davinci/board-tnetv107x-evm.c
@@ -40,6 +40,8 @@
 #include <mach/ti_ssp.h>
 #include <mach/tnetv107x.h>
 
+#define SSP_GPIO_START		128
+
 #define EVM_MMC_WP_GPIO		21
 #define EVM_MMC_CD_GPIO		24
 #define EVM_SPI_CS_GPIO		54
@@ -236,9 +238,22 @@ static const struct ti_ssp_spi_data spi_master_data = {
 	.select		= spi_select_device,
 };
 
+static const struct ti_ssp_gpio_data ssp_gpio_data = {
+	.start		= SSP_GPIO_START,
+};
+
 static struct ti_ssp_data ssp_config = {
 	.out_clock	= 250 * 1000,
 	.dev_data	= {
+		[0] = {
+			.dev_name = "ti-ssp-gpio",
+			.iosel = SSP_PIN_SEL(0, SSP_IN) |
+				 SSP_PIN_SEL(1, SSP_IN) |
+				 SSP_PIN_SEL(2, SSP_IN) |
+				 SSP_PIN_SEL(3, SSP_IN),
+			.pdata = &ssp_gpio_data,
+			.pdata_size = sizeof(ssp_gpio_data),
+		},
 		[1] = {
 			.dev_name = "ti-ssp-spi",
 			.iosel = SSP_PIN_SEL(0, SSP_CLOCK)	|
-- 
1.7.0.4

