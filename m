Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2JGXXv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:23:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38712 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515Ab2JGXX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:29 -0400
Message-Id: <20121007225838.581640179@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [ 028/108] ARM: imx: armadillo5x0: Fix illegal register access
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 35495173e1df621dff0e9a244accbe32cd28a98f upstream.

Since commit eb92044eb (ARM i.MX3: Make ccm base address a variable )
it is necessary to pass the CCM register base as a variable.

Fix the CCM register access in mach-armadillo5x0 by passing mx3_ccm_base and
avoid illegal accesses.

Also applies to v3.5

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-imx/mach-armadillo5x0.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mach-armadillo5x0.c b/arch/arm/mach-imx/mach-armadillo5x0.c
index 2c6ab32..5985ed1 100644
--- a/arch/arm/mach-imx/mach-armadillo5x0.c
+++ b/arch/arm/mach-imx/mach-armadillo5x0.c
@@ -526,7 +526,8 @@ static void __init armadillo5x0_init(void)
 	imx31_add_mxc_nand(&armadillo5x0_nand_board_info);
 
 	/* set NAND page size to 2k if not configured via boot mode pins */
-	__raw_writel(__raw_readl(MXC_CCM_RCSR) | (1 << 30), MXC_CCM_RCSR);
+	__raw_writel(__raw_readl(mx3_ccm_base + MXC_CCM_RCSR) |
+					(1 << 30), mx3_ccm_base + MXC_CCM_RCSR);
 
 	/* RTC */
 	/* Get RTC IRQ and register the chip */


