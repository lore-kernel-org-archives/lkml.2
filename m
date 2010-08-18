Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab0HRFPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:15:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42656 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab0HRFP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:15:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cj1/qWRoBHhNykmjs3Zr0aoxadw1x8+fHgDdSj5rqwYRv0KwP6XyMreNVM3R95aDzg
         5uqbqDlBT1xFR9YbGVNgym4rvpEJCGdgl37Ettc2hhsSTIJS/YR0KRUhxtLDW7KAvi1x
         xUb/UYmOqDavCCPXyj3dqD7IqZfab7Fv44zUg=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: change a temporary variable name in ia32_signal.c
Date: Wed, 18 Aug 2010 14:15:20 +0900
Message-Id: <1282108520-8723-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes following sparse warnings:

 ia32_signal.c:240:17: warning: symbol 'tmp' shadows an earlier one
 ia32_signal.c:228:13: originally declared here
 ia32_signal.c:241:17: warning: symbol 'tmp' shadows an earlier one
 ia32_signal.c:228:13: originally declared here
 ia32_signal.c:242:17: warning: symbol 'tmp' shadows an earlier one
 ia32_signal.c:228:13: originally declared here
 ia32_signal.c:243:17: warning: symbol 'tmp' shadows an earlier one
 ia32_signal.c:228:13: originally declared here
 ia32_signal.c:249:17: warning: symbol 'tmp' shadows an earlier one
 ia32_signal.c:228:13: originally declared here
 ia32_signal.c:250:17: warning: symbol 'tmp' shadows an earlier one
 ia32_signal.c:228:13: originally declared here

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/ia32/ia32_signal.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 348928a..6db169d 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -202,9 +202,9 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 }
 
 #define GET_SEG(seg)		({			\
-	unsigned short tmp;				\
-	get_user_ex(tmp, &sc->seg);			\
-	tmp;						\
+	unsigned short __tmp;				\
+	get_user_ex(__tmp, &sc->seg);			\
+	__tmp;						\
 })
 
 #define COPY_SEG_CPL3(seg)	do {			\
-- 
1.7.0.4

