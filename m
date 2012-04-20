Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab2DTA36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:29:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53178 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957Ab2DTA35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:29:57 -0400
Date: Thu, 19 Apr 2012 17:29:45 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-060feb650010c261fcfbae9de9348b46cedcd3cd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
In-Reply-To: <20120419171609.GH3221@aftab.osrc.amd.com>
References: <20120419171609.GH3221@aftab.osrc.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, doc: Revert "x86:
  Document rdmsr_safe restrictions"
Git-Commit-ID: 060feb650010c261fcfbae9de9348b46cedcd3cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 19 Apr 2012 17:29:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  060feb650010c261fcfbae9de9348b46cedcd3cd
Gitweb:     http://git.kernel.org/tip/060feb650010c261fcfbae9de9348b46cedcd3cd
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 19 Apr 2012 17:07:34 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Apr 2012 17:07:34 -0700

x86, doc: Revert "x86: Document rdmsr_safe restrictions"

This reverts commit ce37defc0f6673f5ca2c92ed5cfcaf290ae7dd16
"x86: Document rdmsr_safe restrictions", as these restrictions no longer apply.

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/20120419171609.GH3221@aftab.osrc.amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/msr.h |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 95203d4..084ef95 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -169,14 +169,7 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 	return native_write_msr_safe(msr, low, high);
 }
 
-/*
- * rdmsr with exception handling.
- *
- * Please note that the exception handling works only after we've
- * switched to the "smart" #GP handler in trap_init() which knows about
- * exception tables - using this macro earlier than that causes machine
- * hangs on boxes which do not implement the @msr in the first argument.
- */
+/* rdmsr with exception handling */
 #define rdmsr_safe(msr, p1, p2)					\
 ({								\
 	int __err;						\
