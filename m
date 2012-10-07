Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab2JGXiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:38:46 -0400
Received: from [216.32.181.184] ([216.32.181.184]:12026 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754144Ab2JGXik convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:38:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz9371Izz1202h1d1ah1d2ahzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441hbe9i1155h)
From: Estevam Fabio-R49496 <r49496@freescale.com>
To: Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: RE: [ 028/108] ARM: imx: armadillo5x0: Fix illegal register access
Thread-Topic: [ 028/108] ARM: imx: armadillo5x0: Fix illegal register access
Thread-Index: AQHNpOLGO9Gb2X/pR0akW5Py5SSnppeuf14m
Date: Sun, 7 Oct 2012 23:37:30 +0000
Message-ID: <86D15885F63D1143A519F161FB828EAF165AA3@039-SN2MPN1-011.039d.mgd.msft.net>
References: <20121007225834.673681075@decadent.org.uk>,<20121007225838.581640179@decadent.org.uk>
In-Reply-To: <20121007225838.581640179@decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [186.207.91.39]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, please drop it from 3.2-stable.

This one should only go to 3.5/3.6 stable trees.

Otherwise it will break 3.2-stable.

Regards,

Fabio Estevam
________________________________________
From: Ben Hutchings [ben@decadent.org.uk]
Sent: Sunday, October 07, 2012 5:59 PM
To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
Cc: akpm@linux-foundation.org; alan@lxorguk.ukuu.org.uk; Estevam Fabio-R49496; Arnd Bergmann; Sascha Hauer
Subject: [ 028/108] ARM: imx: armadillo5x0: Fix illegal register access

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
-       __raw_writel(__raw_readl(MXC_CCM_RCSR) | (1 << 30), MXC_CCM_RCSR);
+       __raw_writel(__raw_readl(mx3_ccm_base + MXC_CCM_RCSR) |
+                                       (1 << 30), mx3_ccm_base + MXC_CCM_RCSR);

        /* RTC */
        /* Get RTC IRQ and register the chip */




