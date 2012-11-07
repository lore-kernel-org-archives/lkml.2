Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2KGP6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:58:13 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64716 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2KGP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:58:11 -0500
Message-ID: <1352303879.7614.2.camel@phoenix>
Subject: [PATCH 1/2] pinctrl: lantiq: Remove ltq_pmx_disable() function
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: John Crispin <blogic@openwrt.org>, linux-kernel@vger.kernel.org
Date: Wed, 07 Nov 2012 23:57:59 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code adds empty ltq_pmx_disable() because pinmux_check_ops() requires
this callback to be defined.

This is not required since commit 02b50ce4cb1
"pinctrl: make pinmux disable function optional".

Thus remove ltq_pmx_disable() function.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/pinctrl/pinctrl-lantiq.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-lantiq.c b/drivers/pinctrl/pinctrl-lantiq.c
index 07ba768..d670ad6 100644
--- a/drivers/pinctrl/pinctrl-lantiq.c
+++ b/drivers/pinctrl/pinctrl-lantiq.c
@@ -275,16 +275,6 @@ static int ltq_pmx_enable(struct pinctrl_dev *pctrldev,
 	return 0;
 }
 
-static void ltq_pmx_disable(struct pinctrl_dev *pctrldev,
-				unsigned func,
-				unsigned group)
-{
-	/*
-	 * Nothing to do here. However, pinconf_check_ops() requires this
-	 * callback to be defined.
-	 */
-}
-
 static int ltq_pmx_gpio_request_enable(struct pinctrl_dev *pctrldev,
 				struct pinctrl_gpio_range *range,
 				unsigned pin)
@@ -312,7 +302,6 @@ static struct pinmux_ops ltq_pmx_ops = {
 	.get_function_name	= ltq_pmx_func_name,
 	.get_function_groups	= ltq_pmx_get_groups,
 	.enable			= ltq_pmx_enable,
-	.disable		= ltq_pmx_disable,
 	.gpio_request_enable	= ltq_pmx_gpio_request_enable,
 };
 
-- 
1.7.9.5



