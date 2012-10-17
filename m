Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2JQGVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:21:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6988 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab2JQGVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:21:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 16 Oct 2012 23:21:40 -0700
From: Pritesh Raithatha <praithatha@nvidia.com>
To: <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>,
        <swarren@nvidia.com>
CC: <stable@vger.kernel.org>, <praithatha@nvidia.com>
Subject: [PATCH] pinctrl: tegra: correct bank for pingroup and drv pingroup
Date: Wed, 17 Oct 2012 11:51:37 +0530
Message-ID: <1350454897-18110-1-git-send-email-praithatha@nvidia.com>
X-Mailer: git-send-email 1.7.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
---
 drivers/pinctrl/pinctrl-tegra30.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra30.c b/drivers/pinctrl/pinctrl-tegra30.c
index 0386fdf..7894f14 100644
--- a/drivers/pinctrl/pinctrl-tegra30.c
+++ b/drivers/pinctrl/pinctrl-tegra30.c
@@ -3345,10 +3345,10 @@ static const struct tegra_function tegra30_functions[] = {
 	FUNCTION(vi_alt3),
 };
 
-#define MUXCTL_REG_A	0x3000
-#define PINGROUP_REG_A	0x868
+#define DRV_PINGROUP_REG_A	0x868	/* bank 0 */
+#define PINGROUP_REG_A		0x3000	/* bank 1 */
 
-#define PINGROUP_REG_Y(r) ((r) - MUXCTL_REG_A)
+#define PINGROUP_REG_Y(r) ((r) - PINGROUP_REG_A)
 #define PINGROUP_REG_N(r) -1
 
 #define PINGROUP(pg_name, f0, f1, f2, f3, f_safe, r, od, ior)	\
@@ -3364,25 +3364,25 @@ static const struct tegra_function tegra30_functions[] = {
 		},						\
 		.func_safe = TEGRA_MUX_ ## f_safe,		\
 		.mux_reg = PINGROUP_REG_Y(r),			\
-		.mux_bank = 0,					\
+		.mux_bank = 1,					\
 		.mux_bit = 0,					\
 		.pupd_reg = PINGROUP_REG_Y(r),			\
-		.pupd_bank = 0,					\
+		.pupd_bank = 1,					\
 		.pupd_bit = 2,					\
 		.tri_reg = PINGROUP_REG_Y(r),			\
-		.tri_bank = 0,					\
+		.tri_bank = 1,					\
 		.tri_bit = 4,					\
 		.einput_reg = PINGROUP_REG_Y(r),		\
-		.einput_bank = 0,				\
+		.einput_bank = 1,				\
 		.einput_bit = 5,				\
 		.odrain_reg = PINGROUP_REG_##od(r),		\
-		.odrain_bank = 0,				\
+		.odrain_bank = 1,				\
 		.odrain_bit = 6,				\
 		.lock_reg = PINGROUP_REG_Y(r),			\
-		.lock_bank = 0,					\
+		.lock_bank = 1,					\
 		.lock_bit = 7,					\
 		.ioreset_reg = PINGROUP_REG_##ior(r),		\
-		.ioreset_bank = 0,				\
+		.ioreset_bank = 1,				\
 		.ioreset_bit = 8,				\
 		.drv_reg = -1,					\
 	}
@@ -3401,8 +3401,8 @@ static const struct tegra_function tegra30_functions[] = {
 		.odrain_reg = -1,				\
 		.lock_reg = -1,					\
 		.ioreset_reg = -1,				\
-		.drv_reg = ((r) - PINGROUP_REG_A),		\
-		.drv_bank = 1,					\
+		.drv_reg = ((r) - DRV_PINGROUP_REG_A),		\
+		.drv_bank = 0,					\
 		.hsm_bit = hsm_b,				\
 		.schmitt_bit = schmitt_b,			\
 		.lpmd_bit = lpmd_b,				\
-- 
1.7.1

