Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2LMLYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:24:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:9815 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab2LMLYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:24:07 -0500
X-AuditID: cbfee61b-b7f616d00000319b-cc-50c9bad53b18
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, t.figa@samsung.com,
        patches@linaro.org
Subject: [PATCH 3/3] arm: exynos: skip wakeup interrupt registration for
 exynos5250 if pinctrl is enabled
Date: Thu, 13 Dec 2012 17:24:04 +0530
Message-id: <1355399644-29417-4-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
References: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jAd2ru04GGHRtM7e4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mr4fG0lW8Fdtoq5/30aGG+xdjFyckgImEis3r6PDcIW
	k7hwbz2YLSSwiFHi7yc1CLuNSaJnaRGIzSZgIPFo4Tt2EFtEQEFic+8zoDlcHMwCKxglTnR9
	BUsIC2RLvDk3l7GLkYODRUBV4ufqbBCTV8BT4sSyZIhVShIbeo8ygdicAl4Sbcu7WCBWeUoc
	+vSJbQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwV5/Jr2DcVWDxSFGAQ5GJR7e
	wvCTAUKsiWXFlbmHGCU4mJVEeP2XA4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzNnukBAgJpCeW
	pGanphakFsFkmTg4pRoYV/W377SZuee3qM0x57JrX/aWsrSpB33OE3BYp1CmtEzy7Z4TZ24y
	ORfHyBQ5FkpY+rR5ZL8MYRfQ0gycbr6h/n/a4mT2F6cWp9THXU68+H7BXp+k7POryzQXSD19
	mPudxatW62axF9/l1Rpv3xcYVi3PLlXSuzLp9Y53n0UX9B85IX3dSXaWEktxRqKhFnNRcSIA
	xZwhVvYBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip the wakeup interrupt registration for Exynos5250 if pinctrl support
is enabled for Exynos5250.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/mach-exynos/common.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 73b940f..7ad5011 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -1019,6 +1019,7 @@ static int __init exynos_init_irq_eint(void)
 	static const struct of_device_id exynos_pinctrl_ids[] = {
 		{ .compatible = "samsung,pinctrl-exynos4210", },
 		{ .compatible = "samsung,pinctrl-exynos4x12", },
+		{ .compatible = "samsung,pinctrl-exynos5250", },
 	};
 	struct device_node *pctrl_np, *wkup_np;
 	const char *wkup_compat = "samsung,exynos4210-wakeup-eint";
-- 
1.6.6.rc2

