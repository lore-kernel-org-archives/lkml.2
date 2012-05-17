Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab2EQFpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 01:45:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:19232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117Ab2EQFou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 01:44:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="141548781"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, riel@redhat.com, luto@mit.edu, alex.shi@intel.com,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, a.p.zijlstra@chello.nl,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH v6 1/7] x86/tlb: unify TLB_FLUSH_ALL definition
Date: Thu, 17 May 2012 13:42:49 +0800
Message-Id: <1337233375-840-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337233375-840-1-git-send-email-alex.shi@intel.com>
References: <1337233375-840-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32bits kernel is using ILP32 model. 64 bits kernel is using LP64 model.
So, here TLB_FLUSH_ALL can be defined as '-1UL', that fit in both
x86_32/x86_64 mode.

Thanks for Rob Landley and Peter Avin's infos

http://www.unix.org/whitepapers/64bit.html
http://www.unix.org/version2/whatsnew/lp64_wp.html

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/tlbflush.h |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index c0e108e..7e8a096 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -62,11 +62,7 @@ static inline void __flush_tlb_one(unsigned long addr)
 		__flush_tlb();
 }
 
-#ifdef CONFIG_X86_32
-# define TLB_FLUSH_ALL	0xffffffff
-#else
-# define TLB_FLUSH_ALL	-1ULL
-#endif
+#define TLB_FLUSH_ALL	-1UL
 
 /*
  * TLB flushing:
-- 
1.7.5.4

