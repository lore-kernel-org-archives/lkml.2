Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2AZRIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:08:38 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7349 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab2AZRIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:08:35 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Jan 2012 09:08:29 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 6/8] ARM: tegra: add support for Tegra30 powerdomains
Date: Thu, 26 Jan 2012 19:07:11 +0200
Message-Id: <1327597641-7519-7-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
References: <1327597641-7519-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the new powerdomains in Tegra30 such as extra CPU cores and
the SATA domain.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/include/mach/powergate.h |   10 ++++++++++
 arch/arm/mach-tegra/powergate.c              |    3 +++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/powergate.h b/arch/arm/mach-tegra/include/mach/powergate.h
index 0ec8ce1..ca41186 100644
--- a/arch/arm/mach-tegra/include/mach/powergate.h
+++ b/arch/arm/mach-tegra/include/mach/powergate.h
@@ -27,6 +27,16 @@
 #define TEGRA_POWERGATE_VDEC	4
 #define TEGRA_POWERGATE_L2	5
 #define TEGRA_POWERGATE_MPE	6
+#define TEGRA_POWERGATE_HEG	7
+#define TEGRA_POWERGATE_SATA	8
+#define TEGRA_POWERGATE_CPU1	9
+#define TEGRA_POWERGATE_CPU2	10
+#define TEGRA_POWERGATE_CPU3	11
+#define TEGRA_POWERGATE_CELP	12
+#define TEGRA_POWERGATE_3D1	13
+
+#define TEGRA_POWERGATE_CPU0	TEGRA_POWERGATE_CPU
+#define TEGRA_POWERGATE_3D0	TEGRA_POWERGATE_3D
 
 int tegra_powergate_is_powered(int id);
 int tegra_powergate_power_on(int id);
diff --git a/arch/arm/mach-tegra/powergate.c b/arch/arm/mach-tegra/powergate.c
index a9fd9b9..6c16681 100644
--- a/arch/arm/mach-tegra/powergate.c
+++ b/arch/arm/mach-tegra/powergate.c
@@ -167,6 +167,9 @@ int __init tegra_powergate_init(void)
 	case TEGRA20:
 		tegra_num_powerdomains = 7;
 		break;
+	case TEGRA30:
+		tegra_num_powerdomains = 14;
+		break;
 	default:
 		/* Unknown Tegra variant. Disable powergating */
 		tegra_num_powerdomains = 0;
-- 
1.7.7.rc0.72.g4b5ea.dirty

