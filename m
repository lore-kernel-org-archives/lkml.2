Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2JZARQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:17:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:53884 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab2JZAIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 53/85] pinctrl: tegra: correct bank for pingroup and drv pingroup
Date: Thu, 25 Oct 2012 17:06:11 -0700
Message-Id: <20121026000036.452359828@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pritesh Raithatha <praithatha@nvidia.com>

commit a03690e44468dcd3088f6600ab036d17bd2130ff upstream.

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-tegra30.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/pinctrl/pinctrl-tegra30.c
+++ b/drivers/pinctrl/pinctrl-tegra30.c
@@ -3345,10 +3345,10 @@ static const struct tegra_function tegra
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
@@ -3364,25 +3364,25 @@ static const struct tegra_function tegra
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
@@ -3401,8 +3401,8 @@ static const struct tegra_function tegra
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


