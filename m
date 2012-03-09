Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030393Ab2CIU1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:27:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030317Ab2CITpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:45:53 -0500
Message-Id: <20120309190203.073476305@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Stigge <stigge@antcom.de>
Subject: [ 09/95] ARM: LPC32xx: Fix interrupt controller init
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Stigge <stigge@antcom.de>

commit 35dd0a75d4a382e7f769dd0277732e7aa5235718 upstream.

This patch fixes the initialization of the interrupt controller of the LPC32xx
by correctly setting up SIC1 and SIC2 instead of (wrongly) using the same value
as for the Main Interrupt Controller (MIC).

Signed-off-by: Roland Stigge <stigge@antcom.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-lpc32xx/irq.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/arm/mach-lpc32xx/irq.c
+++ b/arch/arm/mach-lpc32xx/irq.c
@@ -389,13 +389,15 @@ void __init lpc32xx_init_irq(void)
 
 	/* Setup SIC1 */
 	__raw_writel(0, LPC32XX_INTC_MASK(LPC32XX_SIC1_BASE));
-	__raw_writel(MIC_APR_DEFAULT, LPC32XX_INTC_POLAR(LPC32XX_SIC1_BASE));
-	__raw_writel(MIC_ATR_DEFAULT, LPC32XX_INTC_ACT_TYPE(LPC32XX_SIC1_BASE));
+	__raw_writel(SIC1_APR_DEFAULT, LPC32XX_INTC_POLAR(LPC32XX_SIC1_BASE));
+	__raw_writel(SIC1_ATR_DEFAULT,
+				LPC32XX_INTC_ACT_TYPE(LPC32XX_SIC1_BASE));
 
 	/* Setup SIC2 */
 	__raw_writel(0, LPC32XX_INTC_MASK(LPC32XX_SIC2_BASE));
-	__raw_writel(MIC_APR_DEFAULT, LPC32XX_INTC_POLAR(LPC32XX_SIC2_BASE));
-	__raw_writel(MIC_ATR_DEFAULT, LPC32XX_INTC_ACT_TYPE(LPC32XX_SIC2_BASE));
+	__raw_writel(SIC2_APR_DEFAULT, LPC32XX_INTC_POLAR(LPC32XX_SIC2_BASE));
+	__raw_writel(SIC2_ATR_DEFAULT,
+				LPC32XX_INTC_ACT_TYPE(LPC32XX_SIC2_BASE));
 
 	/* Configure supported IRQ's */
 	for (i = 0; i < NR_IRQS; i++) {


