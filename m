Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2KFVzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:55:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab2KFVzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:55:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 5/8] mmc: dw_mmc: fix modular build for exynos back-end
Date: Tue,  6 Nov 2012 22:55:30 +0100
Message-Id: <1352238933-4886-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1352238933-4886-1-git-send-email-arnd@arndb.de>
References: <1352238933-4886-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:XKfFLLdcX7toRHbCArPLENZLwa5NSArGJx4Er0TTMec
 L0K4D1FEaAIX1x+G9Y+3ntmP6wYsn1vqgJcgcPIwbJLQPzTfkE
 j7juU2+wO1dOKuPtcVcthOzbNZ7FpOUq+EF+tows2xc2ijuhcQ
 fznTJwoGZ/h9SdSqzleyuM/qIwG7XLXxPP0II5OsjmjlfWEqfB
 QFSiTu37rkFHx3JHN8uvmc5vx286I+pPSWOQVrrTB1eQtquxLh
 d0Og/lkDflGdM2KCOmpqAc8ltmmXr3H2jLwA7o/fNBeqGYzGyt
 rpHPS/r0x+efUpzvD1Ud+uPq4hj5IxxjPmIk5G2oq7xMVvLyhX
 y2WmfZGQPUFvi3ZbhwFlL7DBqSOuOpEZ0Fny9I7aSqO1c0qftk
 Q+xsnTETfD5cQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MODULE_DEVICE_TABLE entry for dw_mci_exynos_match
was incorrectly copied from the platform back-end, which
causes this error when building the driver as a loadable
module:

drivers/mmc/host/dw_mmc-exynos.c: At top level:
drivers/mmc/host/dw_mmc-exynos.c:226:34: error: '__mod_of_device_table' aliased to undefined symbol 'dw_mci_pltfm_match'

This patch fixes the problem by just using the correct
string.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Will Newton <will.newton@imgtec.com>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/dw_mmc-exynos.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
index 660bbc5..0147ac3a 100644
--- a/drivers/mmc/host/dw_mmc-exynos.c
+++ b/drivers/mmc/host/dw_mmc-exynos.c
@@ -223,7 +223,7 @@ static const struct of_device_id dw_mci_exynos_match[] = {
 			.data = (void *)&exynos5250_drv_data, },
 	{},
 };
-MODULE_DEVICE_TABLE(of, dw_mci_pltfm_match);
+MODULE_DEVICE_TABLE(of, dw_mci_exynos_match);
 
 int dw_mci_exynos_probe(struct platform_device *pdev)
 {
-- 
1.7.10

