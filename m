Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab1KBShU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:37:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18109 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557Ab1KBShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133707016"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 33/34] ARM: msm: fix names of UART clocks
Date: Wed,  2 Nov 2011 11:36:30 -0700
Message-Id: <1320258991-22325-34-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier code for MSM uarts had three separate drivers, one for the old
"legacy" hardware, one for the new DMA-based hardware, and a third
that used the DMA-based hardware in a legacy-compatible mode.

The current msm_serial driver handles both the older hardware and the
DMA-based hardware in non-DMA mode from the same driver.  Rename the
clocks for this device to support this usage.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock-8x60.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/clock-8x60.c b/arch/arm/mach-msm/clock-8x60.c
index 21c2472..f398bd7 100644
--- a/arch/arm/mach-msm/clock-8x60.c
+++ b/arch/arm/mach-msm/clock-8x60.c
@@ -3378,7 +3378,7 @@ static struct clk_lookup msm_clocks_8x60[] = {
 	CLK_LOOKUP("gsbi_uart_clk",	gsbi9_uart_clk.c, "msm_serial_hsl.1"),
 	CLK_LOOKUP("gsbi_uart_clk",	gsbi10_uart_clk.c,	NULL),
 	CLK_LOOKUP("gsbi_uart_clk",	gsbi11_uart_clk.c,	NULL),
-	CLK_LOOKUP("gsbi_uart_clk",	gsbi12_uart_clk.c, "msm_serial_hsl.0"),
+	CLK_LOOKUP("gsbi_uart_clk",	gsbi12_uart_clk.c, "msm_serial.0"),
 	CLK_LOOKUP("spi_clk",		gsbi1_qup_clk.c, "spi_qsd.0"),
 	CLK_LOOKUP("gsbi_qup_clk",	gsbi2_qup_clk.c,		NULL),
 	CLK_LOOKUP("gsbi_qup_clk",	gsbi3_qup_clk.c, "qup_i2c.0"),
@@ -3425,7 +3425,7 @@ static struct clk_lookup msm_clocks_8x60[] = {
 	CLK_LOOKUP("spi_pclk",		gsbi10_p_clk.c, "spi_qsd.1"),
 	CLK_LOOKUP("gsbi_pclk",		gsbi11_p_clk.c,		NULL),
 	CLK_LOOKUP("gsbi_pclk",		gsbi12_p_clk.c, "msm_dsps.0"),
-	CLK_LOOKUP("gsbi_pclk",		gsbi12_p_clk.c, "msm_serial_hsl.0"),
+	CLK_LOOKUP("gsbi_pclk",		gsbi12_p_clk.c, "msm_serial.0"),
 	CLK_LOOKUP("gsbi_pclk",		gsbi12_p_clk.c, "qup_i2c.5"),
 	CLK_LOOKUP("ppss_pclk",		ppss_p_clk.c,		NULL),
 	CLK_LOOKUP("tsif_pclk",		tsif_p_clk.c,		NULL),
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

