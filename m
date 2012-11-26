Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756Ab2KZRge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:36:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47930 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933700Ab2KZRLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 192/270] pinctrl: tegra: correct bank for pingroup and drv pingroup
Date: Mon, 26 Nov 2012 14:58:02 -0200
Message-Id: <1353949160-26803-193-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pritesh Raithatha <praithatha@nvidia.com>

commit a03690e44468dcd3088f6600ab036d17bd2130ff upstream.

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/pinctrl/pinctrl-tegra30.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

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
1.7.9.5

