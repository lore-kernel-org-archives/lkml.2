Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2KHH6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 02:58:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43859 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab2KHH63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 02:58:29 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v2 05/10] pwm: pwm-tiecap: pinctrl support
Date: Thu, 8 Nov 2012 13:23:12 +0530
Message-ID: <1352361197-27442-6-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable pinctrl for pwm-tiecap

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 0d43266... 6071f7a... M	drivers/pwm/pwm-tiecap.c
 drivers/pwm/pwm-tiecap.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
index 0d43266..6071f7a 100644
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@ -26,6 +26,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/pwm.h>
 #include <linux/of_device.h>
+#include <linux/pinctrl/consumer.h>
 
 #include "tipwmss.h"
 
@@ -210,6 +211,11 @@ static int __devinit ecap_pwm_probe(struct platform_device *pdev)
 	struct resource *r;
 	struct clk *clk;
 	struct ecap_pwm_chip *pc;
+	struct pinctrl *pinctrl;
+
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(&pdev->dev, "failed to configure pins from driver\n");
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc) {
-- 
1.7.0.4

