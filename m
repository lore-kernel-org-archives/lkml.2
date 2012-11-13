Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab2KMBAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:00:22 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:59731 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2KMBAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:00:18 -0500
Message-ID: <1352768407.19229.1.camel@phoenix>
Subject: [PATCH] pinctrl: imx: Fix the logic checking if not able to find
 pin reg map
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Dong Aisheng <dong.aisheng@linaro.org>,
        Devendra Naga <devendra.aaru@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 13 Nov 2012 09:00:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code sets "pin_reg = &info->pin_regs[i];" in each loop iteration,
so in the case of no-match, pin_reg is not NULL.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-imx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index f3d2384..525a2c8 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -71,7 +71,7 @@ static const struct imx_pin_reg *imx_find_pin_reg(
 			break;
 	}
 
-	if (!pin_reg) {
+	if (i == info->npin_regs) {
 		dev_err(info->dev, "Pin(%s): unable to find pin reg map\n",
 			info->pins[pin].name);
 		return NULL;
-- 
1.7.9.5



