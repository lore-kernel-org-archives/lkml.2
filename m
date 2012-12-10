Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab2LJBfb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 20:35:31 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63545 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2LJBf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 20:35:28 -0500
Message-ID: <1355103317.4166.1.camel@phoenix>
Subject: [PATCH] gpio: samsung: Add terminating entry for exynos_pinctrl_ids
From: Axel Lin <axel.lin@ingics.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Date: Mon, 10 Dec 2012 09:35:17 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/gpio/gpio-samsung.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 01f7fe9..9e251be 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -3026,6 +3026,7 @@ static __init int samsung_gpiolib_init(void)
 	static const struct of_device_id exynos_pinctrl_ids[] = {
 		{ .compatible = "samsung,pinctrl-exynos4210", },
 		{ .compatible = "samsung,pinctrl-exynos4x12", },
+		{ }
 	};
 	for_each_matching_node(pctrl_np, exynos_pinctrl_ids)
 		if (pctrl_np && of_device_is_available(pctrl_np))
-- 
1.7.9.5



