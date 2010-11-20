Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0KTCR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 21:17:28 -0500
Received: from smtp-out.google.com ([216.239.44.51]:55779 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab0KTCR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 21:17:27 -0500
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Colin Cross <ccross@android.com>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Fix spinlock bad magic on disabling nonboot cpu
Date: Fri, 19 Nov 2010 18:16:53 -0800
Message-Id: <1290219413-21026-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init_mm.context.id_lock spinlock is not initialized, which
causes a spinlock bad magic warning when nonboot cpus are disabled,
either through hotplug or during suspend.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/include/asm/mmu.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/mmu.h b/arch/arm/include/asm/mmu.h
index 68870c7..1556f6a 100644
--- a/arch/arm/include/asm/mmu.h
+++ b/arch/arm/include/asm/mmu.h
@@ -13,6 +13,8 @@ typedef struct {
 
 #ifdef CONFIG_CPU_HAS_ASID
 #define ASID(mm)	((mm)->context.id & 255)
+#define INIT_MM_CONTEXT(name)                                                 \
+        .context.id_lock = __SPIN_LOCK_UNLOCKED(name.context.id_lock),
 #else
 #define ASID(mm)	(0)
 #endif
-- 
1.7.3.1

