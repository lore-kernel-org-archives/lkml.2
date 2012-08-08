Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab2HHOrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:47:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57875 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638Ab2HHOrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:47:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 05/11] ARM: exynos: exynos_pm_add_dev_to_genpd may be unused
Date: Wed,  8 Aug 2012 16:47:22 +0200
Message-Id: <1344437248-20560-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344437248-20560-1-git-send-email-arnd@arndb.de>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/Yt2Wi6sNF2Lyg1hNWx1mU08J0YMfc2U7mxrp+kthul
 1wr6iHxKGBU8rj58GgyrNjF1gWsHDlMBgNQhqyE6WK0H7cl719
 uiH40E0+nHjIsHn2l5fQWCJnBF5z0p+LloZhBaO99Is+W8GV5T
 c6M0U8Q1byckfhqoWt+yGqq+XB9NramsfWtbxzPbDT1J5qPF7K
 Nt9pp8rfZ9KkbJHXC7o4TYGN97gf9CS22nIzhm6kFyUUD+k23y
 Cr+DshbyfXEH3QQUoNEVR6ZuRY1bDraboTp9HgybhF2eXknmkz
 uJYMd6sbNBKBG8OHcYfUvcfz41Ul9mrMe1ZmtplndwA19zifB3
 wo3ifomW66l1zTO67Oy4r4jSk0dRuhksE5kHKhBbFa/b/IdKXc
 fUJTz5kPdz2qEO1VSc+Juu543RLBGxnVBI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exynos_pm_add_dev_to_genpd is used if one or more out of a large
number of Kconfig symbols are enabled. However the new
exynos_defconfig selects none of those, so the function becomes
unused. Marking it so lets the compiler automatically discard
it.

Without this patch, building exynos_defconfig results in:

arch/arm/mach-exynos/pm_domains.c:118:123: warning: 'exynos_pm_add_dev_to_genpd' defined but not used [-Wunused-function]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/mach-exynos/pm_domains.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/pm_domains.c b/arch/arm/mach-exynos/pm_domains.c
index 373c3c0..c0bc83a 100644
--- a/arch/arm/mach-exynos/pm_domains.c
+++ b/arch/arm/mach-exynos/pm_domains.c
@@ -115,7 +115,7 @@ static __init int exynos_pm_dt_parse_domains(void)
 }
 #endif /* CONFIG_OF */
 
-static __init void exynos_pm_add_dev_to_genpd(struct platform_device *pdev,
+static __init __maybe_unused void exynos_pm_add_dev_to_genpd(struct platform_device *pdev,
 						struct exynos_pm_domain *pd)
 {
 	if (pdev->dev.bus) {
-- 
1.7.10

