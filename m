Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515Ab0HLUHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:07:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:33103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab0HLUHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:07:06 -0400
Date: Thu, 12 Aug 2010 20:06:48 GMT
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, cpw@sgi.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, cpw@sgi.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <E1OiZcw-0001Hb-2g@eag09.americas.sgi.com>
References: <E1OiZcw-0001Hb-2g@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Make kdump avoid stack dumps - fix !CONFIG_KEXEC breakage
Message-ID: <tip-1d6225e8cc5598f2bc5c992f9c88b1137763e8e1@git.kernel.org>
Git-Commit-ID: 1d6225e8cc5598f2bc5c992f9c88b1137763e8e1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 Aug 2010 20:06:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d6225e8cc5598f2bc5c992f9c88b1137763e8e1
Gitweb:     http://git.kernel.org/tip/1d6225e8cc5598f2bc5c992f9c88b1137763e8e1
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Mon, 9 Aug 2010 16:11:22 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 12 Aug 2010 12:23:55 -0700

x86, UV: Make kdump avoid stack dumps - fix !CONFIG_KEXEC breakage

This replaces Version 1 of this patch, which broke the build when
CONFIG_KEXEC and CONFIG_CRASH_DUMP were configured off.  In that case
the storage for the 'in_crash_kexec' flag was never built.

This version defines that flag as 0 if CONFIG_KEXEC is not set.
The patch is tested with all combinations of those two options.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <E1OiZcw-0001Hb-2g@eag09.americas.sgi.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/kdebug.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kdebug.h b/arch/x86/include/asm/kdebug.h
index 7a2910b..5bdfca8 100644
--- a/arch/x86/include/asm/kdebug.h
+++ b/arch/x86/include/asm/kdebug.h
@@ -33,6 +33,11 @@ extern void __show_regs(struct pt_regs *regs, int all);
 extern void show_regs(struct pt_regs *regs);
 extern unsigned long oops_begin(void);
 extern void oops_end(unsigned long, struct pt_regs *, int signr);
+#ifdef CONFIG_KEXEC
 extern int in_crash_kexec;
+#else
+/* no crash dump is ever in progress if no crash kernel can be kexec'd */
+#define in_crash_kexec 0
+#endif
 
 #endif /* _ASM_X86_KDEBUG_H */
