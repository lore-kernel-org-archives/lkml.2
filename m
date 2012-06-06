Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab2FFQQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:16:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40671 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934Ab2FFQQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:16:23 -0400
Date: Wed, 6 Jun 2012 09:16:10 -0700
From: tip-bot for Andi Kleen <ak@linux.intel.com>
Message-ID: <tip-1ff4d58a192aea7f245981e2579765f961f6eb9c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1338944211-28275-4-git-send-email-andi@firstfloor.org>
References: <1338944211-28275-4-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Add rdpmcl()
Git-Commit-ID: 1ff4d58a192aea7f245981e2579765f961f6eb9c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:16:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ff4d58a192aea7f245981e2579765f961f6eb9c
Gitweb:     http://git.kernel.org/tip/1ff4d58a192aea7f245981e2579765f961f6eb9c
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 5 Jun 2012 17:56:50 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:23:27 +0200

x86: Add rdpmcl()

Add a version of rdpmc() that directly reads into a u64

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338944211-28275-4-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
