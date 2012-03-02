Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608Ab2CBU6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:58:39 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42922 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965108Ab2CBU6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:58:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of alan@signal11.us designates 10.236.153.104 as permitted sender) smtp.mail=alan@signal11.us
MIME-Version: 1.0
From: Alan Ott <alan@signal11.us>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Ott <alan@signal11.us>
Subject: [PATCH v2 4/6] ARM: tegra: work around tegra THUMB2_KERNEL bug
Date: Fri,  2 Mar 2012 15:58:35 -0500
Message-Id: <1330721915-8739-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The tegra smp code cannot currently be built for t2, so
disable that combination for now, as a workaround.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alan Ott <alan@signal11.us>
---
 arch/arm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index a48aecc..ea1d59b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1598,6 +1598,7 @@ config HZ
 config THUMB2_KERNEL
 	bool "Compile the kernel in Thumb-2 mode (EXPERIMENTAL)"
 	depends on CPU_V7 && !CPU_V6 && !CPU_V6K && EXPERIMENTAL
+	depends on !SMP || !ARCH_TEGRA
 	select AEABI
 	select ARM_ASM_UNIFIED
 	select ARM_UNWIND
-- 
1.7.0.4

