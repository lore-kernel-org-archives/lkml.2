Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab2FFUuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:50:52 -0400
Received: from mail.df.lth.se ([194.47.250.12]:59613 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab2FFUuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:50:50 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/nomadik: add clk_prepare() call
Date: Wed,  6 Jun 2012 22:50:41 +0200
Message-Id: <1339015841-20900-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now strictly require clk_prepare() calls to be issued before
any clk_enable() calls.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index b26395d..ba7122f 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1246,6 +1246,7 @@ static int __devinit nmk_gpio_probe(struct platform_device *dev)
 		ret = PTR_ERR(clk);
 		goto out_unmap;
 	}
+	clk_prepare(clk);
 
 	nmk_chip = kzalloc(sizeof(*nmk_chip), GFP_KERNEL);
 	if (!nmk_chip) {
-- 
1.7.7.6

