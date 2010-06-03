Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab0FCEy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:54:26 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59429 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab0FCEyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:54:19 -0400
Message-Id: <201006030452.o534qPZa022225@www262.sakura.ne.jp>
Subject: [PATCH] x86, cpufeature: Suppress compiler warning with gcc 3.x
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: hpa@linux.intel.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Jun 2010 13:52:25 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 02062010 #3951585, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gcc 3.x generates a warning

  arch/x86/include/asm/cpufeature.h: In function `__static_cpu_has':
  arch/x86/include/asm/cpufeature.h:315: warning: asm operand 1 probably doesn't match constraints

on each file.
But static_cpu_has() for gcc 3.x does not need __static_cpu_has().

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.35-rc1.orig/arch/x86/include/asm/cpufeature.h
+++ linux-2.6.35-rc1/arch/x86/include/asm/cpufeature.h
@@ -285,6 +285,7 @@ extern const char * const x86_power_flag
 
 #endif /* CONFIG_X86_64 */
 
+#if __GNUC__ >= 4
 /*
  * Static testing of CPU features.  Used the same as boot_cpu_has().
  * These are only valid after alternatives have run, but will statically
@@ -332,7 +333,6 @@ static __always_inline __pure bool __sta
 #endif
 }
 
-#if __GNUC__ >= 4
 #define static_cpu_has(bit)					\
 (								\
 	__builtin_constant_p(boot_cpu_has(bit)) ?		\
