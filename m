Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031438Ab2CITvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:51:22 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42016 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030528Ab2CITvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:51:12 -0500
Message-Id: <20120309190215.504714676@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Stigge <stigge@antcom.de>
Subject: [ 06/68] ARM: LPC32xx: serial.c: Fixed loop limit
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Stigge <stigge@antcom.de>

commit ff424aa4c89d19082e8ae5a3351006bc8a4cd91b upstream.

This patch fixes a wrong loop limit on UART init.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-lpc32xx/serial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-lpc32xx/serial.c
+++ b/arch/arm/mach-lpc32xx/serial.c
@@ -187,7 +187,7 @@ void __init lpc32xx_serial_init(void)
 
 	/* This needs to be done after all UART clocks are setup */
 	__raw_writel(clkmodes, LPC32XX_UARTCTL_CLKMODE);
-	for (i = 0; i < ARRAY_SIZE(uartinit_data) - 1; i++) {
+	for (i = 0; i < ARRAY_SIZE(uartinit_data); i++) {
 		/* Force a flush of the RX FIFOs to work around a HW bug */
 		puart = serial_std_platform_data[i].mapbase;
 		__raw_writel(0xC1, LPC32XX_UART_IIR_FCR(puart));


