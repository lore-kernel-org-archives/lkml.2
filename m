Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab2HSDBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 23:01:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:36894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab2HSC5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 22:57:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,792,1336374000"; 
   d="scan'208";a="182422047"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/74] sections: Add __visible to powerpc sections
Date: Sat, 18 Aug 2012 19:56:02 -0700
Message-Id: <1345345030-22211-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/powerpc/include/asm/cputable.h |    2 +-
 arch/powerpc/include/asm/firmware.h |    2 +-
 arch/powerpc/include/asm/mmu.h      |    2 +-
 arch/powerpc/include/asm/synch.h    |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index 50d82c8..048f876 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -125,7 +125,7 @@ struct cpu_spec {
 
 extern struct cpu_spec		*cur_cpu_spec;
 
-extern unsigned int __start___ftr_fixup, __stop___ftr_fixup;
+extern __visible unsigned int __start___ftr_fixup, __stop___ftr_fixup;
 
 extern struct cpu_spec *identify_cpu(unsigned long offset, unsigned int pvr);
 extern void do_feature_fixups(unsigned long value, void *fixup_start,
diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
index ad0b751..fbf4834 100644
--- a/arch/powerpc/include/asm/firmware.h
+++ b/arch/powerpc/include/asm/firmware.h
@@ -128,7 +128,7 @@ extern void machine_check_fwnmi(void);
 /* This is true if we are using the firmware NMI handler (typically LPAR) */
 extern int fwnmi_active;
 
-extern unsigned int __start___fw_ftr_fixup, __stop___fw_ftr_fixup;
+extern __visible unsigned int __start___fw_ftr_fixup, __stop___fw_ftr_fixup;
 
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/include/asm/mmu.h b/arch/powerpc/include/asm/mmu.h
index e8a26db..cb0a276 100644
--- a/arch/powerpc/include/asm/mmu.h
+++ b/arch/powerpc/include/asm/mmu.h
@@ -130,7 +130,7 @@ static inline void mmu_clear_feature(unsigned long feature)
 	cur_cpu_spec->mmu_features &= ~feature;
 }
 
-extern unsigned int __start___mmu_ftr_fixup, __stop___mmu_ftr_fixup;
+extern __visible unsigned int __start___mmu_ftr_fixup, __stop___mmu_ftr_fixup;
 
 /* MMU initialization */
 extern void early_init_mmu(void);
diff --git a/arch/powerpc/include/asm/synch.h b/arch/powerpc/include/asm/synch.h
index e682a71..b13b5f7 100644
--- a/arch/powerpc/include/asm/synch.h
+++ b/arch/powerpc/include/asm/synch.h
@@ -10,7 +10,7 @@
 #endif
 
 #ifndef __ASSEMBLY__
-extern unsigned int __start___lwsync_fixup, __stop___lwsync_fixup;
+extern __visible unsigned int __start___lwsync_fixup, __stop___lwsync_fixup;
 extern void do_lwsync_fixups(unsigned long value, void *fixup_start,
 			     void *fixup_end);
 extern void do_final_fixups(void);
-- 
1.7.7.6

