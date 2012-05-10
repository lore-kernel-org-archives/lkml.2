Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2EJFCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 01:02:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:1997 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab2EJFCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 01:02:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142177316"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        alex.shi@intel.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/7] x86/tlb: unify TLB_FLUSH_ALL definition
Date: Thu, 10 May 2012 13:00:07 +0800
Message-Id: <1336626013-28413-2-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since sizeof(long) is 4 in x86_32 mode, and it's 8 in x86_64 mode,
sizeof(long long) is also 8 byte in x86_64 mode.
use long mode can fit TLB_FLUSH_ALL defination here both in 32 or
64 bits mode.

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

