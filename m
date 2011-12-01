Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab1LADw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:52:57 -0500
Received: from mail.windriver.com ([147.11.1.11]:55059 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1LADw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:52:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: nicolas.pitre@linaro.org, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: add default value for PHYS_OFFSET Kconfig setting
Date: Wed, 30 Nov 2011 22:52:37 -0500
Message-Id: <1322711557-8279-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1b9f95f8ade9efc2bd49f0e7b9dc61a038ac3eef introduced the new
Kconfig for PHYS_OFFSET but it did not specify a default value.

This has the undesired side effect of breaking an implictly used
trick for updating defconfigs on the fly for routine buildtesting
across all arch and all platforms, i.e.

  cp /path/to/somedefconfig .config ; yes "" | make oldconfig

In particular, the at91x40_defconfig will enter an infinite loop
with the above, since there is no default value, and conf will just
keep asking for one, and "yes" will keep feeding in a line return.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 44789ef..90a475e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -221,6 +221,7 @@ config NEED_MACH_MEMORY_H
 
 config PHYS_OFFSET
 	hex "Physical address of main memory"
+	default 0x00000000
 	depends on !ARM_PATCH_PHYS_VIRT && !NEED_MACH_MEMORY_H
 	help
 	  Please provide the physical address corresponding to the
-- 
1.7.7.2

