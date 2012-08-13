Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2HMUZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:25:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2HMUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:25:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [ 70/82] ARM: imx: enable emi_slow_gate clock for imx5
Date: Mon, 13 Aug 2012 13:19:46 -0700
Message-Id: <20120813201752.592776005@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit 68b0562df90a76ba964423986b2472c7e791729a upstream.

The imx5 common clock migration causes a regression with smsc911x
driver on imx53-ard board, where a smsc lan9220 controller gets
connected on imx53 with EIM interface.  EIM needs clock emi_slow_gate
to be functional.  In the new imx5 clock driver, there is no use count
incremented for the clock by enabling it, so the framework closes the
clock at late init time and makes EIM stop working then.

Enable emi_slow_gate in clock driver initialization to fix the
regression.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx51-imx53.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-imx/clk-imx51-imx53.c
+++ b/arch/arm/mach-imx/clk-imx51-imx53.c
@@ -293,6 +293,7 @@ static void __init mx5_clocks_common_ini
 	clk_prepare_enable(clk[aips_tz2]); /* fec */
 	clk_prepare_enable(clk[spba]);
 	clk_prepare_enable(clk[emi_fast_gate]); /* fec */
+	clk_prepare_enable(clk[emi_slow_gate]); /* eim */
 	clk_prepare_enable(clk[tmax1]);
 	clk_prepare_enable(clk[tmax2]); /* esdhc2, fec */
 	clk_prepare_enable(clk[tmax3]); /* esdhc1, esdhc4 */


