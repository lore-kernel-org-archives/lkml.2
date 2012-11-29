Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2K2LFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:05:04 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:46553 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071Ab2K2LFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:05:02 -0500
From: Armando Visconti <armando.visconti@st.com>
To: <armando.visconti@st.com>, <linux@arm.linux.org.uk>
Cc: <hsweeten@visionengravers.com>, <swarren@nvidia.com>, <nico@linaro.org>,
        <kgene.kim@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <spear-devel@list.st.com>
Subject: [PATCH] nommu: Enable the strict alignment (CR_A) bit only if ARCH < v6
Date: Thu, 29 Nov 2012 12:04:02 +0100
Message-ID: <1354187042-28568-1-git-send-email-armando.visconti@st.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch keeps disabled the strict alignment CP15 bit for
all armv6 and armv7 processor without the mmu. This behaviour
is now same as in the mmu case.

Signed-off-by: Armando Visconti <armando.visconti@st.com>
---
 arch/arm/kernel/head-nommu.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index 278cfc1..2c228a0 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -68,7 +68,7 @@ __after_proc_init:
 	 * CP15 system control register value returned in r0 from
 	 * the CPU init function.
 	 */
-#ifdef CONFIG_ALIGNMENT_TRAP
+#if defined(CONFIG_ALIGNMENT_TRAP) && __LINUX_ARM_ARCH__ < 6
 	orr	r0, r0, #CR_A
 #else
 	bic	r0, r0, #CR_A
-- 
1.7.4.4

