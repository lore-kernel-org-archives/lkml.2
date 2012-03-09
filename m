Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab2CIUJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:09:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031431Ab2CITvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:51:21 -0500
Message-Id: <20120309190215.722022227@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:23 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Stigge <stigge@antcom.de>
Subject: [ 09/68] ARM: LPC32xx: Fix irq on GPI_28
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Stigge <stigge@antcom.de>

commit f6737055c1c432a9628a9a731f9881ad8e0a9eee upstream.

The GPI_28 IRQ was not registered properly. The registration of
IRQ_LPC32XX_GPI_28 was added and the (wrong) IRQ_LPC32XX_GPI_11 at
LPC32XX_SIC1_IRQ(4) was replaced by IRQ_LPC32XX_GPI_28 (see manual of
LPC32xx / interrupt controller).

Signed-off-by: Roland Stigge <stigge@antcom.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-lpc32xx/include/mach/irqs.h |    2 +-
 arch/arm/mach-lpc32xx/irq.c               |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-lpc32xx/include/mach/irqs.h
+++ b/arch/arm/mach-lpc32xx/include/mach/irqs.h
@@ -61,7 +61,7 @@
  */
 #define IRQ_LPC32XX_JTAG_COMM_TX	LPC32XX_SIC1_IRQ(1)
 #define IRQ_LPC32XX_JTAG_COMM_RX	LPC32XX_SIC1_IRQ(2)
-#define IRQ_LPC32XX_GPI_11		LPC32XX_SIC1_IRQ(4)
+#define IRQ_LPC32XX_GPI_28		LPC32XX_SIC1_IRQ(4)
 #define IRQ_LPC32XX_TS_P		LPC32XX_SIC1_IRQ(6)
 #define IRQ_LPC32XX_TS_IRQ		LPC32XX_SIC1_IRQ(7)
 #define IRQ_LPC32XX_TS_AUX		LPC32XX_SIC1_IRQ(8)
--- a/arch/arm/mach-lpc32xx/irq.c
+++ b/arch/arm/mach-lpc32xx/irq.c
@@ -118,6 +118,10 @@ static const struct lpc32xx_event_info l
 		.event_group = &lpc32xx_event_pin_regs,
 		.mask = LPC32XX_CLKPWR_EXTSRC_GPI_06_BIT,
 	},
+	[IRQ_LPC32XX_GPI_28] = {
+		.event_group = &lpc32xx_event_pin_regs,
+		.mask = LPC32XX_CLKPWR_EXTSRC_GPI_28_BIT,
+	},
 	[IRQ_LPC32XX_GPIO_00] = {
 		.event_group = &lpc32xx_event_int_regs,
 		.mask = LPC32XX_CLKPWR_INTSRC_GPIO_00_BIT,


