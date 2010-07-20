Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab0GTXzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:55:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:38835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952Ab0GTXzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:55:41 -0400
Date: Tue, 20 Jul 2010 23:54:42 GMT
From: tip-bot for Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andi@firstfloor.org, akpm@linux-foundation.org, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, akpm@linux-foundation.org, ak@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <201007202219.o6KMJme6021066@imap1.linux-foundation.org>
References: <201007202219.o6KMJme6021066@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/gcc46] x86, gcc-4.6: Avoid unused by set variables in rdmsr
Message-ID: <tip-5f755293ca61520b70b11afe1b1d6e1635cb6c00@git.kernel.org>
Git-Commit-ID: 5f755293ca61520b70b11afe1b1d6e1635cb6c00
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 23:54:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f755293ca61520b70b11afe1b1d6e1635cb6c00
Gitweb:     http://git.kernel.org/tip/5f755293ca61520b70b11afe1b1d6e1635cb6c00
Author:     Andi Kleen <andi@firstfloor.org>
AuthorDate: Tue, 20 Jul 2010 15:19:48 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 Jul 2010 15:38:18 -0700

x86, gcc-4.6: Avoid unused by set variables in rdmsr

Avoids quite a lot of warnings with a gcc 4.6 -Wall build
because this happens in a commonly used header file (apic.h)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <201007202219.o6KMJme6021066@imap1.linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/msr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index c5bc4c2..084ef95 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -148,8 +148,8 @@ static inline unsigned long long native_read_pmc(int counter)
 #define rdmsr(msr, val1, val2)					\
 do {								\
 	u64 __val = native_read_msr((msr));			\
-	(val1) = (u32)__val;					\
-	(val2) = (u32)(__val >> 32);				\
+	(void)((val1) = (u32)__val);				\
+	(void)((val2) = (u32)(__val >> 32));			\
 } while (0)
 
 static inline void wrmsr(unsigned msr, unsigned low, unsigned high)
