Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab2FSViw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 17:38:52 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:60186 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753799Ab2FSViv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 17:38:51 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/coh901: use clk_prepare_enable()
Date: Tue, 19 Jun 2012 23:38:32 +0200
Message-ID: <1340141912-13111-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The COH901 GPIO driver did not prepare its clock, so let us
fix it to do so.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-coh901.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 55697a5..1b5d232a 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -770,7 +770,7 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 		dev_err(gpio->dev, "could not get GPIO clock\n");
 		goto err_no_clk;
 	}
-	err = clk_enable(gpio->clk);
+	err = clk_prepare_enable(gpio->clk);
 	if (err) {
 		dev_err(gpio->dev, "could not enable GPIO clock\n");
 		goto err_no_clk_enable;
-- 
1.7.9.2

