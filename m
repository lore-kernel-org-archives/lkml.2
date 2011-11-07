Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1KGOUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:20:49 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19659 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab1KGOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:20:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 07 Nov 2011 06:20:30 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v3 5/8] arm/tegra: add new fields to struct tegra_pingroup_desc
Date: Mon, 7 Nov 2011 16:20:12 +0200
Message-ID: <1320675617-20751-6-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
References: <1320675617-20751-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new fields to struct tegra_pingroup_desc to support new hardware features
introduced in the tegra30 SoC. The pinmux driver won't use those fields yet,
but the tegra30 pinmux tables will already provide the necessary data.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/include/mach/pinmux.h   |   10 ++++++++++
 arch/arm/mach-tegra/pinmux-tegra20-tables.c |    4 ++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/pinmux.h b/arch/arm/mach-tegra/include/mach/pinmux.h
index 35999ce..988c6c5 100644
--- a/arch/arm/mach-tegra/include/mach/pinmux.h
+++ b/arch/arm/mach-tegra/include/mach/pinmux.h
@@ -2,6 +2,7 @@
  * linux/arch/arm/mach-tegra/include/mach/pinmux.h
  *
  * Copyright (C) 2010 Google, Inc.
+ * Copyright (C) 2010,2011 Nvidia, Inc.
  *
  * This software is licensed under the terms of the GNU General Public
  * License version 2, as published by the Free Software Foundation, and
@@ -99,6 +100,11 @@ enum tegra_tristate {
 	TEGRA_TRI_TRISTATE = 1,
 };
 
+enum tegra_pin_io {
+	TEGRA_PIN_OUTPUT = 0,
+	TEGRA_PIN_INPUT = 1,
+};
+
 enum tegra_vddio {
 	TEGRA_VDDIO_BB = 0,
 	TEGRA_VDDIO_LCD,
@@ -202,6 +208,7 @@ struct tegra_pingroup_desc {
 	int funcs[4];
 	int func_safe;
 	int vddio;
+	enum tegra_pin_io io_default;
 	s16 tri_bank;	/* Register bank the tri_reg exists within */
 	s16 mux_bank;	/* Register bank the mux_reg exists within */
 	s16 pupd_bank;	/* Register bank the pupd_reg exists within */
@@ -211,6 +218,9 @@ struct tegra_pingroup_desc {
 	s8 tri_bit; 	/* offset into the TRISTATE_REG_* register bit */
 	s8 mux_bit;	/* offset into the PIN_MUX_CTL_* register bit */
 	s8 pupd_bit;	/* offset into the PULL_UPDOWN_REG_* register bit */
+	s8 lock_bit;	/* offset of the LOCK bit into mux register bit */
+	s8 od_bit;	/* offset of the OD bit into mux register bit */
+	s8 ioreset_bit;	/* offset of the IO_RESET bit into mux register bit */
 };
 
 typedef void (*pinmux_init) (const struct tegra_pingroup_desc **pg,
diff --git a/arch/arm/mach-tegra/pinmux-tegra20-tables.c b/arch/arm/mach-tegra/pinmux-tegra20-tables.c
index de9d0df..e469229 100644
--- a/arch/arm/mach-tegra/pinmux-tegra20-tables.c
+++ b/arch/arm/mach-tegra/pinmux-tegra20-tables.c
@@ -106,6 +106,10 @@ static const struct tegra_drive_pingroup_desc tegra_soc_drive_pingroups[TEGRA_MA
 		.pupd_bank = 2,				\
 		.pupd_reg = ((pupd_r) - PULLUPDOWN_REG_A),	\
 		.pupd_bit = pupd_b,				\
+		.lock_bit = -1,					\
+		.od_bit = -1,					\
+		.ioreset_bit = -1,				\
+		.io_default = -1,				\
 	}
 
 static const struct tegra_pingroup_desc tegra_soc_pingroups[TEGRA_MAX_PINGROUP] = {
-- 
1.7.7.rc0.72.g4b5ea.dirty

