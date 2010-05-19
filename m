Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0ESRM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:12:29 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:6017 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab0ESRM2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ksrinivasan@novell.com:4:1>);
	Wed, 19 May 2010 13:12:28 -0400
X-Greylist: delayed 1085 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2010 13:12:28 EDT
Message-Id: <4BF3C7970200003000085602@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 19 May 2010 11:12:23 -0600
From: "Ky Srinivasan" <ksrinivasan@novell.com>
To: <hpa@zytor.com>
Cc: <greg@kroah.com>, <hjanssen@microsoft.com>, <mingo@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] Hyperv detection - code cleanup
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: K. Y. Srinivasan <ksrinivasan@novell.com>
Subject: Code cleanup - consolidate all hyperv related definitions into one
header file.


Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>

Index: linux.trees.git/arch/x86/include/asm/hyperv.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/hyperv.h	2010-05-18 10:14:02.000000000 -0600
+++ linux.trees.git/arch/x86/include/asm/hyperv.h	2010-05-18 14:11:55.000000000 -0600
@@ -190,4 +190,11 @@
 #define HV_STATUS_INVALID_HYPERCALL_INPUT	3
 #define HV_STATUS_INVALID_ALIGNMENT		4
 
+struct ms_hyperv_info {
+	u32 features;
+	u32 hints;
+};
+
+extern struct ms_hyperv_info ms_hyperv;
+
 #endif
Index: linux.trees.git/arch/x86/include/asm/mshyperv.h
===================================================================
--- linux.trees.git.orig/arch/x86/include/asm/mshyperv.h	2010-05-18 10:14:02.000000000 -0600
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,14 +0,0 @@
-#ifndef _ASM_X86_MSHYPER_H
-#define _ASM_X86_MSHYPER_H
-
-#include <linux/types.h>
-#include <asm/hyperv.h>
-
-struct ms_hyperv_info {
-	u32 features;
-	u32 hints;
-};
-
-extern struct ms_hyperv_info ms_hyperv;
-
-#endif
Index: linux.trees.git/arch/x86/kernel/cpu/mshyperv.c
===================================================================
--- linux.trees.git.orig/arch/x86/kernel/cpu/mshyperv.c	2010-05-18 12:46:50.000000000 -0600
+++ linux.trees.git/arch/x86/kernel/cpu/mshyperv.c	2010-05-18 14:11:55.000000000 -0600
@@ -15,7 +15,6 @@
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
 #include <asm/hyperv.h>
-#include <asm/mshyperv.h>
 
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL(ms_hyperv);










