Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423330Ab2LFLdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 06:33:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:37327 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423283Ab2LFLdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 06:33:52 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] x86: ptrace.c only needs export.h and not the full module.h
Date: Thu,  6 Dec 2012 06:33:42 -0500
Message-Id: <1354793622-8497-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cb57a2b4cff7edf2a4e32c0163200e9434807e0a ("x86-32: Export
kernel_stack_pointer() for modules") added an include of the
module.h header in conjunction with adding an EXPORT_SYMBOL_GPL
of kernel_stack_pointer.

But module.h should be avoided for simple exports, since it in turn
includes the world.  Swap the module.h for export.h instead.

Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 974b67e..be9b4d4 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -22,7 +22,7 @@
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/rcupdate.h>
-#include <linux/module.h>
+#include <linux/export.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-- 
1.8.0

