Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab0GVFBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:01:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:37205 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab0GVFBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:01:42 -0400
Date: Thu, 22 Jul 2010 05:01:05 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        penberg@cs.helsinki.fi, brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@cs.helsinki.fi, tglx@linutronix.de
In-Reply-To: <1279371808-24804-2-git-send-email-brgerst@gmail.com>
References: <1279371808-24804-2-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Use symbolic MSR names
Message-ID: <tip-cfaa71ee9794472598d3966c3315cd6bd8f953d3@git.kernel.org>
Git-Commit-ID: cfaa71ee9794472598d3966c3315cd6bd8f953d3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Jul 2010 05:01:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfaa71ee9794472598d3966c3315cd6bd8f953d3
Gitweb:     http://git.kernel.org/tip/cfaa71ee9794472598d3966c3315cd6bd8f953d3
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Sat, 17 Jul 2010 09:03:27 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 21 Jul 2010 21:23:40 -0700

x86: Use symbolic MSR names

Use symbolic MSR names instead of hardcoding the MSR index.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1279371808-24804-2-git-send-email-brgerst@gmail.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/acpi/realmode/wakeup.S |    2 +-
 arch/x86/kernel/verify_cpu_64.S        |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/realmode/wakeup.S b/arch/x86/kernel/acpi/realmode/wakeup.S
index 580b4e2..28595d6 100644
--- a/arch/x86/kernel/acpi/realmode/wakeup.S
+++ b/arch/x86/kernel/acpi/realmode/wakeup.S
@@ -104,7 +104,7 @@ _start:
 	movl	%eax, %ecx
 	orl	%edx, %ecx
 	jz	1f
-	movl	$0xc0000080, %ecx
+	movl	$MSR_EFER, %ecx
 	wrmsr
 1:
 
diff --git a/arch/x86/kernel/verify_cpu_64.S b/arch/x86/kernel/verify_cpu_64.S
index 45b6f8a..56a8c2a 100644
--- a/arch/x86/kernel/verify_cpu_64.S
+++ b/arch/x86/kernel/verify_cpu_64.S
@@ -31,6 +31,7 @@
  */
 
 #include <asm/cpufeature.h>
+#include <asm/msr-index.h>
 
 verify_cpu:
 	pushfl				# Save caller passed flags
@@ -88,7 +89,7 @@ verify_cpu_sse_test:
 	je	verify_cpu_sse_ok
 	test	%di,%di
 	jz	verify_cpu_no_longmode	# only try to force SSE on AMD
-	movl	$0xc0010015,%ecx	# HWCR
+	movl	$MSR_K7_HWCR,%ecx
 	rdmsr
 	btr	$15,%eax		# enable SSE
 	wrmsr
