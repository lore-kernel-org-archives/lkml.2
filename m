Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab2AaQmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 11:42:07 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7992 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab2AaQmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 11:42:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 31 Jan 2012 08:41:57 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] ARM: tegra: export tegra_powergate_is_powered()
Date: Tue, 31 Jan 2012 18:40:43 +0200
Message-Id: <1328028051-24271-6-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
References: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export tegra_powergate_is_powered(). This function will be used by the Tegra30
code to bringup secondary CPU cores.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/include/mach/powergate.h |    1 +
 arch/arm/mach-tegra/powergate.c              |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/powergate.h b/arch/arm/mach-tegra/include/mach/powergate.h
index 36846dc..0ec8ce1 100644
--- a/arch/arm/mach-tegra/include/mach/powergate.h
+++ b/arch/arm/mach-tegra/include/mach/powergate.h
@@ -28,6 +28,7 @@
 #define TEGRA_POWERGATE_L2	5
 #define TEGRA_POWERGATE_MPE	6
 
+int tegra_powergate_is_powered(int id);
 int tegra_powergate_power_on(int id);
 int tegra_powergate_power_off(int id);
 int tegra_powergate_remove_clamping(int id);
diff --git a/arch/arm/mach-tegra/powergate.c b/arch/arm/mach-tegra/powergate.c
index 9b828f2..984bbdf 100644
--- a/arch/arm/mach-tegra/powergate.c
+++ b/arch/arm/mach-tegra/powergate.c
@@ -93,7 +93,7 @@ int tegra_powergate_power_off(int id)
 	return tegra_powergate_set(id, false);
 }
 
-static int tegra_powergate_is_powered(int id)
+int tegra_powergate_is_powered(int id)
 {
 	u32 status;
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

