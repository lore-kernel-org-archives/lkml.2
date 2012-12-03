Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab2LCOgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:36:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43722 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755366Ab2LCOgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:14 -0500
Message-Id: <20121203143157.352464627@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Yang Wei <wei.yang@windriver.com>,
        Robert Richter <robert.richter@amd.com>,
        Jun Zhang <jun.zhang@intel.com>
Subject: [ 70/89] x86-32: Export kernel_stack_pointer() for modules
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
@@ -191,6 +192,7 @@ unsigned long kernel_stack_pointer(struc
 
 	return (unsigned long)regs;
 }
+EXPORT_SYMBOL_GPL(kernel_stack_pointer);
 
 static unsigned long *pt_regs_access(struct pt_regs *regs, unsigned long regno)
 {


