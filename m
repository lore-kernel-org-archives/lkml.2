Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031375Ab2I1Tfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:35:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965376Ab2I1TAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:00:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Arnd Bergmann <arnd@arndb.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [ 131/262] ARM: imx: armadillo5x0: Fix illegal register access
Date: Fri, 28 Sep 2012 11:51:00 -0700
Message-Id: <20120928183013.496925998@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/mach-armadillo5x0.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-imx/mach-armadillo5x0.c
+++ b/arch/arm/mach-imx/mach-armadillo5x0.c
@@ -526,7 +526,8 @@ static void __init armadillo5x0_init(voi
 	imx31_add_mxc_nand(&armadillo5x0_nand_board_info);
 
 	/* set NAND page size to 2k if not configured via boot mode pins */
-	__raw_writel(__raw_readl(MXC_CCM_RCSR) | (1 << 30), MXC_CCM_RCSR);
+	__raw_writel(__raw_readl(mx3_ccm_base + MXC_CCM_RCSR) |
+					(1 << 30), mx3_ccm_base + MXC_CCM_RCSR);
 
 	/* RTC */
 	/* Get RTC IRQ and register the chip */


