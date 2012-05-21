Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab2EUWwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:52:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49707 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab2EUWul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:50:41 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, u.kleine-koenig@pengutronix.de,
        richard.zhao@freescale.com, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Subject: [PATCH v5 2/7] ARM: imx: Add comments to tzic_enable_waker()
Date: Mon, 21 May 2012 17:50:25 -0500
Message-Id: <1337640630-29176-3-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337640630-29176-1-git-send-email-rob.lee@linaro.org>
References: <1337640630-29176-1-git-send-email-rob.lee@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add additional comments to the tzic_enable_wake() funciton to
clarify its intended usage.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/plat-mxc/tzic.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
index 98308ec..a45dbea 100644
--- a/arch/arm/plat-mxc/tzic.c
+++ b/arch/arm/plat-mxc/tzic.c
@@ -190,6 +190,10 @@ void __init tzic_init_irq(void __iomem *irqbase)
  * tzic_enable_wake() - enable wakeup interrupt
  *
  * @return			0 if successful; non-zero otherwise
+ *
+ * This function provides an interrupt synchronization point that is required
+ * by tzic enabled platforms before entering imx specific low power modes (ie,
+ * those low power modes beyond the WAIT_CLOCKED basic ARM WFI only mode).
  */
 int tzic_enable_wake(void)
 {
-- 
1.7.10

