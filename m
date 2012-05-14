Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab2ENK2C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:28:02 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18919 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab2ENK2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:28:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 14 May 2012 03:26:49 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: tegra: Fix flow controller accesses
Date: Mon, 14 May 2012 13:27:09 +0300
Message-ID: <1336991229-18859-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flowctrl_write_cpu_csr uses the cpu halt offsets and vice versa. This patch
fixes this bug.

Reported-by: Dan Willemsen <dwillemsen@nvidia.com>
Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/flowctrl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-tegra/flowctrl.c b/arch/arm/mach-tegra/flowctrl.c
index fef66a7..f07488e 100644
--- a/arch/arm/mach-tegra/flowctrl.c
+++ b/arch/arm/mach-tegra/flowctrl.c
@@ -53,10 +53,10 @@ static void flowctrl_update(u8 offset, u32 value)
 
 void flowctrl_write_cpu_csr(unsigned int cpuid, u32 value)
 {
-	return flowctrl_update(flowctrl_offset_halt_cpu[cpuid], value);
+	return flowctrl_update(flowctrl_offset_cpu_csr[cpuid], value);
 }
 
 void flowctrl_write_cpu_halt(unsigned int cpuid, u32 value)
 {
-	return flowctrl_update(flowctrl_offset_cpu_csr[cpuid], value);
+	return flowctrl_update(flowctrl_offset_halt_cpu[cpuid], value);
 }
-- 
1.7.7.rc0.72.g4b5ea.dirty

