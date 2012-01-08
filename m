Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2AHEkv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 23:40:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37189 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2AHEkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 23:40:49 -0500
Date: Sat, 7 Jan 2012 20:40:33 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-72142fd4109105c6bd21658966ca5e93c1684081@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sfr@canb.auug.org.au, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sfr@canb.auug.org.au
In-Reply-To: <20111214181545.6e13bc954cb7ddce9086e861@canb.auug.org.au>
References: <20111214181545.6e13bc954cb7ddce9086e861@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/syscall] x86: Move <asm/asm-offsets.h>
  from trace_syscalls.c to asm/syscall.h
Git-Commit-ID: 72142fd4109105c6bd21658966ca5e93c1684081
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 07 Jan 2012 20:40:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72142fd4109105c6bd21658966ca5e93c1684081
Gitweb:     http://git.kernel.org/tip/72142fd4109105c6bd21658966ca5e93c1684081
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Sat, 7 Jan 2012 14:10:18 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 7 Jan 2012 14:10:18 -0800

x86: Move <asm/asm-offsets.h> from trace_syscalls.c to asm/syscall.h

This reverts commit d5e553d6e0a4bdea43adae7373e3fa144b9a1aaa, which
caused large numbers of build warnings on PowerPC.

This moves the #include <asm/asm-offsets.h> to <asm/syscall.h>, which
makes some kind of sense since NR_syscalls is syscalls related.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/20111214181545.6e13bc954cb7ddce9086e861@canb.auug.org.au
---
 arch/x86/include/asm/syscall.h |    1 +
 kernel/trace/trace_syscalls.c  |    1 -
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index c4a348f..d962e56 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -15,6 +15,7 @@
 
 #include <linux/sched.h>
 #include <linux/err.h>
+#include <asm/asm-offsets.h>	/* For NR_syscalls */
 
 extern const unsigned long sys_call_table[];
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5f35f6f..cb65454 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -6,7 +6,6 @@
 #include <linux/ftrace.h>
 #include <linux/perf_event.h>
 #include <asm/syscall.h>
-#include <asm/asm-offsets.h>
 
 #include "trace_output.h"
 #include "trace.h"
