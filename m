Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768849Ab2K3TMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:12:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:59530 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992927Ab2K3TCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Yang Wei <wei.yang@windriver.com>,
        Robert Richter <robert.richter@amd.com>,
        Jun Zhang <jun.zhang@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 05/54] x86-32: Export kernel_stack_pointer() for modules
Date: Fri, 30 Nov 2012 10:55:36 -0800
Message-Id: <20121130185208.434646451@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit cb57a2b4cff7edf2a4e32c0163200e9434807e0a upstream.

Modules, in particular oprofile (and possibly other similar tools)
need kernel_stack_pointer(), so export it using EXPORT_SYMBOL_GPL().

Link: http://lkml.kernel.org/r/20120912135059.GZ8285@erda.amd.com
Cc: Yang Wei <wei.yang@windriver.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Jun Zhang <jun.zhang@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/ptrace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -21,6 +21,7 @@
 #include <linux/signal.h>
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -192,6 +193,7 @@ unsigned long kernel_stack_pointer(struc
 
 	return (unsigned long)regs;
 }
+EXPORT_SYMBOL_GPL(kernel_stack_pointer);
 
 static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 {


