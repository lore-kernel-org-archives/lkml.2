Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1JCNHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:07:34 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17912 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab1JCNH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:07:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 03 Oct 2011 06:07:02 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH] arm/tegra: select AUTO_ZRELADDR by default
Date: Mon, 3 Oct 2011 16:06:47 +0300
Message-ID: <1317647209-22303-3-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1317647209-22303-1-git-send-email-pdeschrijver@nvidia.com>
References: <1317647209-22303-1-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch causes the kernel uncompressor to determine the physical address
of the SDRAM at runtime. This allows the kernel to boot on both tegra2 and
tegra3 even though SDRAM is at different physical addresses on both SoCs.

Change-Id: I91857a590946bbc54168c04bea3a5bd576d87824
Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4fda167..9fc0678 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -600,6 +600,7 @@ config ARCH_TEGRA
 	select HAVE_CLK
 	select HAVE_SCHED_CLOCK
 	select ARCH_HAS_CPUFREQ
+	select AUTO_ZRELADDR
 	help
 	  This enables support for NVIDIA Tegra based systems (Tegra APX,
 	  Tegra 6xx and Tegra 2 series).
-- 
1.7.7.rc0.72.g4b5ea.dirty

