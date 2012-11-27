Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643Ab2K0Ivn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:51:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57807 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758594Ab2K0Ivk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:51:40 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v5 09/12] pwm: pwm-tiehrpwm: pinctrl support
Date: Tue, 27 Nov 2012 14:18:14 +0530
Message-ID: <1354006097-25895-10-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1354006097-25895-1-git-send-email-avinashphilip@ti.com>
References: <1354006097-25895-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable pinctrl for pwm-tiehrpwm if pinctrl driver available, else
bail out with warning message.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
Changes since v4:
	- Changes warning message.

 drivers/pwm/pwm-tiehrpwm.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-tiehrpwm.c b/drivers/pwm/pwm-tiehrpwm.c
index d3194c0..e8683bc 100644
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@ -26,6 +26,7 @@
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
 #include <linux/of_device.h>
+#include <linux/pinctrl/consumer.h>
 
 #include "pwm-tipwmss.h"
 
@@ -415,6 +416,11 @@ static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 	struct clk *clk;
 	struct ehrpwm_pwm_chip *pc;
 	u16 status;
+	struct pinctrl *pinctrl;
+
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+	if (IS_ERR(pinctrl))
+		dev_warn(&pdev->dev, "unable to select pin group\n");
 
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc) {
-- 
1.7.0.4

