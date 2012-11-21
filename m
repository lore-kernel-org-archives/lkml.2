Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab2KUHgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:36:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48134 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2KUHgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:36:14 -0500
Date: Tue, 20 Nov 2012 23:35:40 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-cb57a2b4cff7edf2a4e32c0163200e9434807e0a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@vger.kernel.org, robert.richter@amd.com, jun.zhang@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com, wei.yang@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, robert.richter@amd.com, jun.zhang@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com, wei.yang@windriver.com
In-Reply-To: <20120912135059.GZ8285@erda.amd.com>
References: <20120912135059.GZ8285@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32: Export kernel_stack_pointer()
  for modules
Git-Commit-ID: cb57a2b4cff7edf2a4e32c0163200e9434807e0a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 20 Nov 2012 23:36:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb57a2b4cff7edf2a4e32c0163200e9434807e0a
Gitweb:     http://git.kernel.org/tip/cb57a2b4cff7edf2a4e32c0163200e9434807e0a
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 20 Nov 2012 22:21:02 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 Nov 2012 22:23:23 -0800

x86-32: Export kernel_stack_pointer() for modules

Modules, in particular oprofile (and possibly other similar tools)
need kernel_stack_pointer(), so export it using EXPORT_SYMBOL_GPL().

Cc: Yang Wei <wei.yang@windriver.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Jun Zhang <jun.zhang@intel.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20120912135059.GZ8285@erda.amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/ptrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 2484e33..5e0596b 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/rcupdate.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -193,6 +194,7 @@ unsigned long kernel_stack_pointer(struct pt_regs *regs)
 
 	return (unsigned long)regs;
 }
+EXPORT_SYMBOL_GPL(kernel_stack_pointer);
 
 static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 {
