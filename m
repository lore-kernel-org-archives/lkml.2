Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab0EEW5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:57:11 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:59624 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab0EEW5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:57:07 -0400
From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, bryan.wu@canonical.com,
       amit.kucheria@canonical.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv1 2.6.34-rc6 2/3] mx5: change usb clock source from pll3 to pll2
Date: Wed,  5 May 2010 17:56:10 -0500
Message-Id: <1273100171-3235-3-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1273100171-3235-2-git-send-email-Dinh.Nguyen@freescale.com>
References: <1273100171-3235-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1273100171-3235-2-git-send-email-Dinh.Nguyen@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For power management reasons, pll2 should be used to source the USBOH3
clock for mx51. PLL3 can be completely gated off when USB is not used.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/clock-mx51.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
index dcca330..933c0d1 100644
--- a/arch/arm/mach-mx5/clock-mx51.c
+++ b/arch/arm/mach-mx5/clock-mx51.c
@@ -763,7 +763,7 @@ DEFINE_CLOCK(gpt_ipg_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG10_OFFSET,
 
 /* USB */
 DEFINE_CLOCK(usboh3_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG14_OFFSET,
-	NULL, NULL, &pll3_sw_clk, NULL);
+	NULL, NULL, &pll2_sw_clk, NULL);
 
 /* FEC */
 DEFINE_CLOCK(fec_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG12_OFFSET,
-- 
1.6.0.4

