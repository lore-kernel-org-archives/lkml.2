Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761291Ab2EQHfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:35:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48130 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761278Ab2EQHfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:35:38 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Ryan Mallon <ryan@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "Hans J. Koch" <hjk@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 1/2] gpio/generic: initialize basic_mmio_gpio shadow variables properly
Date: Thu, 17 May 2012 15:35:02 +0800
Message-Id: <1337240103-4756-2-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337240103-4756-1-git-send-email-shawn.guo@linaro.org>
References: <1337240103-4756-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It fixes the issue in gpio-generic that commit fb14921 (gpio/mxc: add
missing initialization of basic_mmio_gpio shadow variables) manged to
fix in gpio-mxc driver, so that other platform specific drivers do not
suffer from the same problem over and over again.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/gpio/gpio-generic.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index e38dd0c..cfc9439 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -394,6 +394,10 @@ int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
 		return ret;
 
 	bgc->data = bgc->read_reg(bgc->reg_dat);
+	if (bgc->gc.set == bgpio_set_set)
+		bgc->data = bgc->read_reg(bgc->reg_set);
+	if (bgc->reg_dir)
+		bgc->dir = bgc->read_reg(bgc->reg_dir);
 
 	return ret;
 }
-- 
1.7.5.4

