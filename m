Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab2HVOaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:30:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59848 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab2HVOaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:30:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 2/4] ARM: allow PID_IN_CONTEXTIDR only for ARMv7
Date: Wed, 22 Aug 2012 16:29:38 +0200
Message-Id: <1345645780-2749-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1345645780-2749-1-git-send-email-arnd@arndb.de>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:39epySVFofFwEtk6U40Voqvt3hnhyvYchW/XWNhCCAJ
 Zl/1jPEETAxb1Sad7ZWmnX6Tpx5ugtDXGKz0hQDsebMblTmyDd
 kelB2ElpcCtZga+ezHp7xmDVPwtu1kI/q+5OmEA9TcXNI9c2Ae
 qiKpABXyOh/YZFp9c9OQowD8QxSNgbP3urzLl7924cFCvPqvES
 NLwKreao/RlyhXdGwfVQBVuLFXcO0xqLeH75Pe/Zcb5Vv5MtDF
 vKkCcQMaUhray8T56aVKqbEKlrKu8/1B6euHP+FvKVuEKu7Bq1
 PnlbM3BznKVhfwrmPL0z556mbbTp7bIXQP0G9fXeFqtsVTGD/L
 5hp1hgBXt4K97NURsNW+/cV5AZFmRJcjat/1P6nXqk18G08PK6
 hlaULMVZDv9iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ARMv6 is enabled, we build the kernel with -march=armv6 or
-march=armv6k, which means the bfi instruction is not available.
Instead, it only works with -march=armv6t2 or -march=armv7-a.

Without this patch, building rand-enIHAOL results in:

/tmp/ccwCsCXC.s: Assembler messages:
/tmp/ccwCsCXC.s:49: Error: selected processor does not support ARM mode `bfi r3,r2,#0,#8'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index f15f82b..11b9ff4 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -398,6 +398,7 @@ config ARM_KPROBES_TEST
 config PID_IN_CONTEXTIDR
 	bool "Write the current PID to the CONTEXTIDR register"
 	depends on CPU_COPY_V6
+	depends on CPU_V7 && !CPU_V6
 	help
 	  Enabling this option causes the kernel to write the current PID to
 	  the PROCID field of the CONTEXTIDR register, at the expense of some
-- 
1.7.10

