Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762766Ab2ERKuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:50:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab2ERKun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:50:43 -0400
Date: Fri, 18 May 2012 03:50:34 -0700
From: tip-bot for Alex Shi <alex.shi@intel.com>
Message-ID: <tip-evv5bekiipi2pmyzdsy8lkkw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, alex.shi@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/tlb: Clean up and unify TLB_FLUSH_ALL definition
Git-Commit-ID: 3e7f3db001de6133db1c385c92eec944409a8b4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:50:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e7f3db001de6133db1c385c92eec944409a8b4f
Gitweb:     http://git.kernel.org/tip/3e7f3db001de6133db1c385c92eec944409a8b4f
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 10 May 2012 18:01:59 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 10:13:37 +0200

x86/tlb: Clean up and unify TLB_FLUSH_ALL definition

Since sizeof(long) is 4 in x86_32 mode, and it's 8 in x86_64
mode, sizeof(long long) is also 8 byte in x86_64 mode.
use long mode can fit TLB_FLUSH_ALL defination here both in 32
or 64 bits mode.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Link: http://lkml.kernel.org/n/tip-evv5bekiipi2pmyzdsy8lkkw@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/tlbflush.h |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 169be89..63af909 100644
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
