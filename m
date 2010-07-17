Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969Ab0GQNDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 09:03:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279Ab0GQNDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 09:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sCJgOw2y5lJGOHMdT3XK+fETfRC02OlaC530Ztl3CufxZqAA1EM+cmkoqd7IBw/LgU
         bGuO2wzo8hbxuw9dCvmoMAQgZ2Snazi9TuN/mnb6ZwrjHbV3cSSdFVWWaFCDbM5tge6X
         sntV7k2sChAWidrIJk2idVvuSvMKm32uG6MLQ=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: Use symbolic MSR names
Date: Sat, 17 Jul 2010 09:03:27 -0400
Message-Id: <1279371808-24804-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279371808-24804-1-git-send-email-brgerst@gmail.com>
References: <1279371808-24804-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
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
-- 
1.7.1.1

