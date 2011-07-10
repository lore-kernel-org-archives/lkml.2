Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1GJNxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 09:53:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56125 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1GJNxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 09:53:23 -0400
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86-64: Simplify cpu_has_invlpg
Date: Sun, 10 Jul 2011 09:53:19 -0400
Message-Id: <1310306000-2447-1-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define CONFIG_X86_INVLPG for 64-bit too, which simplifies the code.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/Kconfig.cpu              |    2 +-
 arch/x86/include/asm/cpufeature.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 6a7cfdf..d801dfe 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -350,7 +350,7 @@ config X86_WP_WORKS_OK
 
 config X86_INVLPG
 	def_bool y
-	depends on X86_32 && !M386
+	depends on !M386
 
 config X86_BSWAP
 	def_bool y
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 71cc380..102b6f0 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -289,7 +289,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
 #define cpu_has_perfctr_core	boot_cpu_has(X86_FEATURE_PERFCTR_CORE)
 
-#if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
+#ifdef CONFIG_X86_INVLPG
 # define cpu_has_invlpg		1
 #else
 # define cpu_has_invlpg		(boot_cpu_data.x86 > 3)
-- 
1.7.4.4

