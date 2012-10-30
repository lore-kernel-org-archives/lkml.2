Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab2J3WWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:22:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45460 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab2J3WWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:22:08 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] exynos: mmc: use correct variable for MODULE_DEVICE_TABLE
Date: Wed, 31 Oct 2012 01:21:52 +0300
Message-Id: <1351635712-17214-1-git-send-email-slyich@gmail.com>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

Found by gcc:

    linux-2.6/drivers/mmc/host/dw_mmc-exynos.c: At top level:
    linux-2.6/drivers/mmc/host/dw_mmc-exynos.c:226:1: error: '__mod_of_device_table' aliased to undefined symbol 'dw_mci_pltfm_match'

CC: Chris Ball <cjb@laptop.org>
CC: Thomas Abraham <thomas.abraham@linaro.org>
CC: Will Newton <will.newton@imgtec.com>
CC: linux-mmc@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 drivers/mmc/host/dw_mmc-exynos.c | 2 +-
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
1.7.12.4

