Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab2H0KGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 06:06:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51770 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2H0KGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 06:06:38 -0400
From: Vaibhav Hiremath <hvaibhav@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Tony Lindgren <tony@atomide.com>,
        Paul Walmsley <paul@pwsan.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Subject: [PATCH] ARM: AM33XX: clock: Add dcan clock aliases for device-tree
Date: Mon, 27 Aug 2012 15:34:02 +0530
Message-ID: <1346061842-28714-1-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the device names for the dcan module follows the
format "dcan.X", where 'X' is the dcan instance number.
On other side, driver may request for clock with/without con_id
and dev_id, and it is expected that platform should respect this
request and return the requested clock handle.

Now, when using device tree, the format of the device name created
by OF layer is different, "<reg-address>.<device-name>",
assuming that the device-tree "reg" property is specified.
This causes the look-up failure for clock node in dcan driver

To fix this add new dcan clock alias for using device-tree.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>
---
 arch/arm/mach-omap2/clock33xx_data.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock33xx_data.c b/arch/arm/mach-omap2/clock33xx_data.c
index ae27de8..a4006b2 100644
--- a/arch/arm/mach-omap2/clock33xx_data.c
+++ b/arch/arm/mach-omap2/clock33xx_data.c
@@ -1027,7 +1027,9 @@ static struct omap_clk am33xx_clks[] = {
 	CLK(NULL,	"cefuse_fck",		&cefuse_fck,	CK_AM33XX),
 	CLK(NULL,	"clkdiv32k_ick",	&clkdiv32k_ick,	CK_AM33XX),
 	CLK(NULL,	"dcan0_fck",		&dcan0_fck,	CK_AM33XX),
+	CLK("481cc000.d_can",	NULL,		&dcan0_fck,	CK_AM33XX),
 	CLK(NULL,	"dcan1_fck",		&dcan1_fck,	CK_AM33XX),
+	CLK("481d0000.d_can",	NULL,		&dcan1_fck,	CK_AM33XX),
 	CLK(NULL,	"debugss_ick",		&debugss_ick,	CK_AM33XX),
 	CLK(NULL,	"pruss_ocp_gclk",	&pruss_ocp_gclk,	CK_AM33XX),
 	CLK("davinci-mcasp.0",  NULL,           &mcasp0_fck,    CK_AM33XX),
-- 
1.7.0.4

