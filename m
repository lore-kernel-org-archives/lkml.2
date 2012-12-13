Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab2LMOIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:08:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44597 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab2LMOIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:08:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yang Wei <wei.yang@windriver.com>, Robert Richter <robert.richter@amd.com>,
        Jun Zhang <jun.zhang@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 129/241] x86-32: Export kernel_stack_pointer() for modules
Date: Thu, 13 Dec 2012 11:58:14 -0200
Message-Id: <1355407206-17100-130-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit cb57a2b4cff7edf2a4e32c0163200e9434807e0a upstream.

Modules, in particular oprofile (and possibly other similar tools)
need kernel_stack_pointer(), so export it using EXPORT_SYMBOL_GPL().

Cc: Yang Wei <wei.yang@windriver.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Jun Zhang <jun.zhang@intel.com>
Link: http://lkml.kernel.org/r/20120912135059.GZ8285@erda.amd.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/kernel/ptrace.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 947cf90..9ee1787 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/signal.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -192,6 +193,7 @@ unsigned long kernel_stack_pointer(struct pt_regs *regs)
 
 	return (unsigned long)regs;
 }
+EXPORT_SYMBOL_GPL(kernel_stack_pointer);
 
 static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 {
-- 
1.7.9.5

