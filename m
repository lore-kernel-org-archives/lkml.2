Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab2LMLX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:23:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:9749 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2LMLX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:23:26 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-e3-50c9baacde58
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, t.figa@samsung.com,
        patches@linaro.org
Subject: [PATCH 2/3] gpio: samsung: skip gpiolib registration if pinctrl
 support is enabled for exynos5250
Date: Thu, 13 Dec 2012 17:24:03 +0530
Message-id: <1355399644-29417-3-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
References: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t9jAd01u04GGLz9Z2VxedccNosZ5/cx
	OTB5fN4kF8AYxWWTkpqTWZZapG+XwJXxo/Usa8Extor9by6wNzCeYO1i5OSQEDCR6J55lRnC
	FpO4cG89G4gtJLCIUaKp276LkQvIbmOS+L1xEViCTcBA4tHCd+wgtoiAgsTm3mesIEXMAisY
	JU50fQVKcHAIC+RITDtuAGKyCKhKzN7FB1LOK+Ap8f3gGahdShIbeo8ygdicAl4Sbcu7WCD2
	ekoc+vSJbQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwZ5/JrWDcWWDxSFGAQ5G
	JR7egvCTAUKsiWXFlbmHGCU4mJVEeP2XA4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzNnukBAgJ
	pCeWpGanphakFsFkmTg4pRoYXS4V3l6+8cPb5P2Tw8+9WDzZ++GDYoabM76/8tY6eCfrmc1J
	jqO60rW7FiQkR4mqrjp35sHhoxLvt/04dn2X0hXn92rLtd5s7XNn2M4UIyT1MVFgrnBpA6/D
	9ftcIRyXH7S9SMzdXxGqa7h04hm/a7t/CLzLmj/nQvH0X+8PFk++1/knyale20KJpTgj0VCL
	uag4EQB6vWbc+AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip exynos5250 gpiolib registration if pinctrl support for exynos5250
is enabled.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/gpio/gpio-samsung.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
index 01f7fe9..849c134 100644
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@ -3026,6 +3026,7 @@ static __init int samsung_gpiolib_init(void)
 	static const struct of_device_id exynos_pinctrl_ids[] = {
 		{ .compatible = "samsung,pinctrl-exynos4210", },
 		{ .compatible = "samsung,pinctrl-exynos4x12", },
+		{ .compatible = "samsung,pinctrl-exynos5250", },
 	};
 	for_each_matching_node(pctrl_np, exynos_pinctrl_ids)
 		if (pctrl_np && of_device_is_available(pctrl_np))
-- 
1.6.6.rc2

