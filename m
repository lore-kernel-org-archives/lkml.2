Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1CUVqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 17:46:46 -0400
Received: from mail-db3.bigfish.com ([94.245.120.74]:30929 "EHLO
	DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754330Ab1CUVqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 17:46:43 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <arnaud.patard@rtp-net.org>, <ra5478@freescale.com>,
        <xiao-lizhang@freescale.com>, <festevam@gmail.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv5 2/4] ARM: mx51: Add entry for gpc_dvfs_clk
Date: Mon, 21 Mar 2011 16:30:36 -0500
Message-ID: <1300743038-3901-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1300743038-3901-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1300743038-3901-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

For MX51 SRPG, we need to turn on the GPC clock in order to set the
SRPG registers.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/clock-mx51-mx53.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-mx5/clock-mx51-mx53.c b/arch/arm/mach-mx5/clock-mx51-mx53.c
index 652ace4..3eb1c6e 100644
--- a/arch/arm/mach-mx5/clock-mx51-mx53.c
+++ b/arch/arm/mach-mx5/clock-mx51-mx53.c
@@ -865,6 +865,13 @@ static struct clk aips_tz2_clk = {
 	.disable = _clk_ccgr_disable_inwait,
 };
 
+static struct clk gpc_dvfs_clk = {
+	.enable_reg = MXC_CCM_CCGR5,
+	.enable_shift = MXC_CCM_CCGRx_CG12_OFFSET,
+	.enable = _clk_ccgr_enable,
+	.disable = _clk_ccgr_disable,
+};
+
 static struct clk gpt_32k_clk = {
 	.id = 0,
 	.parent = &ckil_clk,
@@ -1448,6 +1455,7 @@ static struct clk_lookup mx51_lookups[] = {
 	_REGISTER_CLOCK("imx-ipuv3", NULL, ipu_clk)
 	_REGISTER_CLOCK("imx-ipuv3", "di0", ipu_di0_clk)
 	_REGISTER_CLOCK("imx-ipuv3", "di1", ipu_di1_clk)
+	_REGISTER_CLOCK(NULL, "gpc_dvfs", gpc_dvfs_clk)
 };
 
 static struct clk_lookup mx53_lookups[] = {
-- 
1.6.0.4


