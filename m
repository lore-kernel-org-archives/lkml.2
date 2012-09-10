Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2IJJTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:19:41 -0400
Received: from skyrme.org ([193.175.80.135]:56242 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab2IJJTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:19:39 -0400
Date: 10 Sep 2012 09:19:35 +0000
Message-Id: <1347268775-25253-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Uwe Kleine-Koenig" <u.kleine-koenig@pengutronix.de>
Cc: "Sascha Hauer" <kernel@pengutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH] serial/imx: fix IMX UART macro usage to reflect correct
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform dependant UART data refers to MX31 macro for MX35 machines.
For all other machines, macro usage matches machine type.

Though this compiles out to the same result, it looks much like
a typo, so fix it to use the right macros instead.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 arch/arm/plat-mxc/devices/platform-imx-uart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-mxc/devices/platform-imx-uart.c b/arch/arm/plat-mxc/devices/platform-imx-uart.c
index 2020d84..d390f00 100644
--- a/arch/arm/plat-mxc/devices/platform-imx-uart.c
+++ b/arch/arm/plat-mxc/devices/platform-imx-uart.c
@@ -87,7 +87,7 @@ const struct imx_imx_uart_1irq_data imx31_imx_uart_data[] __initconst = {
 #ifdef CONFIG_SOC_IMX35
 const struct imx_imx_uart_1irq_data imx35_imx_uart_data[] __initconst = {
 #define imx35_imx_uart_data_entry(_id, _hwid)				\
-	imx_imx_uart_1irq_data_entry(MX31, _id, _hwid, SZ_16K)
+	imx_imx_uart_1irq_data_entry(MX35, _id, _hwid, SZ_16K)
 	imx35_imx_uart_data_entry(0, 1),
 	imx35_imx_uart_data_entry(1, 2),
 	imx35_imx_uart_data_entry(2, 3),
-- 
1.7.9.5

