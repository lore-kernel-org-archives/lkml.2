Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658Ab0KLNGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:06:14 -0500
Received: from smtp.nokia.com ([147.243.128.24]:36563 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab0KLNGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:06:07 -0500
From: Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm@lists.arm.linux.org.uk, linux-serial@vger.kernel.org
Subject: [PATCHv4 2/4] OMAP1: Serial: remove magic numbers for MDR1 reg
Date: Fri, 12 Nov 2010 15:04:01 +0200
Message-Id: <1289567043-6213-3-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1289567043-6213-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1289567043-6213-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>

Change magic number to ones defined in serial_reg
for omap1 serial driver

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
---
 arch/arm/mach-omap1/serial.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap1/serial.c b/arch/arm/mach-omap1/serial.c
index b78d074..c73d1b7 100644
--- a/arch/arm/mach-omap1/serial.c
+++ b/arch/arm/mach-omap1/serial.c
@@ -52,9 +52,11 @@ static inline void omap_serial_outp(struct plat_serial8250_port *p, int offset,
  */
 static void __init omap_serial_reset(struct plat_serial8250_port *p)
 {
-	omap_serial_outp(p, UART_OMAP_MDR1, 0x07);	/* disable UART */
+	omap_serial_outp(p, UART_OMAP_MDR1,
+			UART_OMAP_MDR1_DISABLE);	/* disable UART */
 	omap_serial_outp(p, UART_OMAP_SCR, 0x08);	/* TX watermark */
-	omap_serial_outp(p, UART_OMAP_MDR1, 0x00);	/* enable UART */
+	omap_serial_outp(p, UART_OMAP_MDR1,
+			UART_OMAP_MDR1_16X_MODE);	/* enable UART */
 
 	if (!cpu_is_omap15xx()) {
 		omap_serial_outp(p, UART_OMAP_SYSC, 0x01);
-- 
1.7.0.4

