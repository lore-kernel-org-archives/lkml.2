Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab2FFA5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 20:57:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:10275 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab2FFA5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 20:57:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="153438747"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: eranian@google.com, a.p.zijlstra@chello.nl,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/5] x86: Add rdpmcl()
Date: Tue,  5 Jun 2012 17:56:50 -0700
Message-Id: <1338944211-28275-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a version of rdpmc() that directly reads into a u64

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/msr.h      |    2 ++
 arch/x86/include/asm/paravirt.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 084ef95..e489c14 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -237,6 +237,8 @@ do {							\
 	(high) = (u32)(_l >> 32);			\
 } while (0)
 
+#define rdpmcl(counter, val) ((val) = native_read_pmc(counter))
+
 #define rdtscp(low, high, aux)					\
 do {                                                            \
 	unsigned long long _val = native_read_tscp(&(aux));     \
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 6cbbabf..14ce05d 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -252,6 +252,8 @@ do {						\
 	high = _l >> 32;			\
 } while (0)
 
+#define rdpmcl(counter, val) ((val) = paravirt_read_pmc(counter))
+
 static inline unsigned long long paravirt_rdtscp(unsigned int *aux)
 {
 	return PVOP_CALL1(u64, pv_cpu_ops.read_tscp, aux);
-- 
1.7.7.6

