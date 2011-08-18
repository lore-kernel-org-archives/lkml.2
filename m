Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab1HRTKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:10:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47562 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1HRTKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:10:10 -0400
Date: Thu, 18 Aug 2011 20:10:09 +0100
To: richard@nod.at
Subject: Subject: [PATCH 67/91] um: merge HOST_... of registers common on
 i386 and amd64
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7yj-0007xC-RW@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/um/ptrace_32.c               |   14 +++++++-------
 arch/x86/um/ptrace_64.c               |   14 +++++++-------
 arch/x86/um/shared/sysdep/ptrace_32.h |   14 +++++++-------
 arch/x86/um/shared/sysdep/ptrace_64.h |   14 +++++++-------
 arch/x86/um/signal_32.c               |   14 +++++++-------
 arch/x86/um/signal_64.c               |   28 ++++++++++++++--------------
 arch/x86/um/user-offsets.c            |   28 ++++++++++++++--------------
 7 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/arch/x86/um/ptrace_32.c b/arch/x86/um/ptrace_32.c
index 7725fc7..3caaab9 100644
--- a/arch/x86/um/ptrace_32.c
+++ b/arch/x86/um/ptrace_32.c
@@ -51,13 +51,13 @@ int is_syscall(unsigned long addr)
 #define FLAG_MASK 0x00044dd5
 
 static const int reg_offsets[] = {
-	[EBX] = HOST_EBX,
-	[ECX] = HOST_ECX,
-	[EDX] = HOST_EDX,
-	[ESI] = HOST_ESI,
-	[EDI] = HOST_EDI,
-	[EBP] = HOST_EBP,
-	[EAX] = HOST_EAX,
+	[EBX] = HOST_BX,
+	[ECX] = HOST_CX,
+	[EDX] = HOST_DX,
+	[ESI] = HOST_SI,
+	[EDI] = HOST_DI,
+	[EBP] = HOST_BP,
+	[EAX] = HOST_AX,
 	[DS] = HOST_DS,
 	[ES] = HOST_ES,
 	[FS] = HOST_FS,
diff --git a/arch/x86/um/ptrace_64.c b/arch/x86/um/ptrace_64.c
index 67fb771..77b0289 100644
--- a/arch/x86/um/ptrace_64.c
+++ b/arch/x86/um/ptrace_64.c
@@ -30,13 +30,13 @@ static const int reg_offsets[] =
 	[R15 >> 3] = HOST_R15,
 	[RIP >> 3] = HOST_IP,
 	[RSP >> 3] = HOST_SP,
-	[RAX >> 3] = HOST_RAX,
-	[RBX >> 3] = HOST_RBX,
-	[RCX >> 3] = HOST_RCX,
-	[RDX >> 3] = HOST_RDX,
-	[RSI >> 3] = HOST_RSI,
-	[RDI >> 3] = HOST_RDI,
-	[RBP >> 3] = HOST_RBP,
+	[RAX >> 3] = HOST_AX,
+	[RBX >> 3] = HOST_BX,
+	[RCX >> 3] = HOST_CX,
+	[RDX >> 3] = HOST_DX,
+	[RSI >> 3] = HOST_SI,
+	[RDI >> 3] = HOST_DI,
+	[RBP >> 3] = HOST_BP,
 	[CS >> 3] = HOST_CS,
 	[SS >> 3] = HOST_SS,
 	[FS_BASE >> 3] = HOST_FS_BASE,
diff --git a/arch/x86/um/shared/sysdep/ptrace_32.h b/arch/x86/um/shared/sysdep/ptrace_32.h
index 967b512..6bdc7c9 100644
--- a/arch/x86/um/shared/sysdep/ptrace_32.h
+++ b/arch/x86/um/shared/sysdep/ptrace_32.h
@@ -27,13 +27,13 @@ extern int sysemu_supported;
 #define REGS_IP(r) ((r)[HOST_IP])
 #define REGS_SP(r) ((r)[HOST_SP])
 #define REGS_EFLAGS(r) ((r)[HOST_EFLAGS])
-#define REGS_EAX(r) ((r)[HOST_EAX])
-#define REGS_EBX(r) ((r)[HOST_EBX])
-#define REGS_ECX(r) ((r)[HOST_ECX])
-#define REGS_EDX(r) ((r)[HOST_EDX])
-#define REGS_ESI(r) ((r)[HOST_ESI])
-#define REGS_EDI(r) ((r)[HOST_EDI])
-#define REGS_EBP(r) ((r)[HOST_EBP])
+#define REGS_EAX(r) ((r)[HOST_AX])
+#define REGS_EBX(r) ((r)[HOST_BX])
+#define REGS_ECX(r) ((r)[HOST_CX])
+#define REGS_EDX(r) ((r)[HOST_DX])
+#define REGS_ESI(r) ((r)[HOST_SI])
+#define REGS_EDI(r) ((r)[HOST_DI])
+#define REGS_EBP(r) ((r)[HOST_BP])
 #define REGS_CS(r) ((r)[HOST_CS])
 #define REGS_SS(r) ((r)[HOST_SS])
 #define REGS_DS(r) ((r)[HOST_DS])
diff --git a/arch/x86/um/shared/sysdep/ptrace_64.h b/arch/x86/um/shared/sysdep/ptrace_64.h
index bd7b026..9b933fa 100644
--- a/arch/x86/um/shared/sysdep/ptrace_64.h
+++ b/arch/x86/um/shared/sysdep/ptrace_64.h
@@ -17,13 +17,13 @@
 #define REGS_IP(r) ((r)[HOST_IP])
 #define REGS_SP(r) ((r)[HOST_SP])
 
-#define REGS_RBX(r) ((r)[HOST_RBX])
-#define REGS_RCX(r) ((r)[HOST_RCX])
-#define REGS_RDX(r) ((r)[HOST_RDX])
-#define REGS_RSI(r) ((r)[HOST_RSI])
-#define REGS_RDI(r) ((r)[HOST_RDI])
-#define REGS_RBP(r) ((r)[HOST_RBP])
-#define REGS_RAX(r) ((r)[HOST_RAX])
+#define REGS_RBX(r) ((r)[HOST_BX])
+#define REGS_RCX(r) ((r)[HOST_CX])
+#define REGS_RDX(r) ((r)[HOST_DX])
+#define REGS_RSI(r) ((r)[HOST_SI])
+#define REGS_RDI(r) ((r)[HOST_DI])
+#define REGS_RBP(r) ((r)[HOST_BP])
+#define REGS_RAX(r) ((r)[HOST_AX])
 #define REGS_R8(r) ((r)[HOST_R8])
 #define REGS_R9(r) ((r)[HOST_R9])
 #define REGS_R10(r) ((r)[HOST_R10])
diff --git a/arch/x86/um/signal_32.c b/arch/x86/um/signal_32.c
index bcbfb0d..2eebdc0 100644
--- a/arch/x86/um/signal_32.c
+++ b/arch/x86/um/signal_32.c
@@ -160,14 +160,14 @@ static int copy_sc_from_user(struct pt_regs *regs,
 	GETREG(FS, fs);
 	GETREG(ES, es);
 	GETREG(DS, ds);
-	GETREG(EDI, di);
-	GETREG(ESI, si);
-	GETREG(EBP, bp);
+	GETREG(DI, di);
+	GETREG(SI, si);
+	GETREG(BP, bp);
 	GETREG(SP, sp);
-	GETREG(EBX, bx);
-	GETREG(EDX, dx);
-	GETREG(ECX, cx);
-	GETREG(EAX, ax);
+	GETREG(BX, bx);
+	GETREG(DX, dx);
+	GETREG(CX, cx);
+	GETREG(AX, ax);
 	GETREG(IP, ip);
 	GETREG(CS, cs);
 	GETREG(EFLAGS, flags);
diff --git a/arch/x86/um/signal_64.c b/arch/x86/um/signal_64.c
index 255b2ca..4e5b9b0 100644
--- a/arch/x86/um/signal_64.c
+++ b/arch/x86/um/signal_64.c
@@ -35,13 +35,13 @@ static int copy_sc_from_user(struct pt_regs *regs,
 	GETREG(R13, r13);
 	GETREG(R14, r14);
 	GETREG(R15, r15);
-	GETREG(RDI, di);
-	GETREG(RSI, si);
-	GETREG(RBP, bp);
-	GETREG(RBX, bx);
-	GETREG(RDX, dx);
-	GETREG(RAX, ax);
-	GETREG(RCX, cx);
+	GETREG(DI, di);
+	GETREG(SI, si);
+	GETREG(BP, bp);
+	GETREG(BX, bx);
+	GETREG(DX, dx);
+	GETREG(AX, ax);
+	GETREG(CX, cx);
 	GETREG(SP, sp);
 	GETREG(IP, ip);
 	GETREG(EFLAGS, flags);
@@ -78,18 +78,18 @@ static int copy_sc_to_user(struct sigcontext __user *to,
 
 #define PUTREG(regno, regname) sc.regname = regs->regs.gp[HOST_##regno]
 
-	PUTREG(RDI, di);
-	PUTREG(RSI, si);
-	PUTREG(RBP, bp);
+	PUTREG(DI, di);
+	PUTREG(SI, si);
+	PUTREG(BP, bp);
 	/*
 	 * Must use original RSP, which is passed in, rather than what's in
 	 * signal frame.
 	 */
 	sc.sp = sp;
-	PUTREG(RBX, bx);
-	PUTREG(RDX, dx);
-	PUTREG(RCX, cx);
-	PUTREG(RAX, ax);
+	PUTREG(BX, bx);
+	PUTREG(DX, dx);
+	PUTREG(CX, cx);
+	PUTREG(AX, ax);
 	PUTREG(R8, r8);
 	PUTREG(R9, r9);
 	PUTREG(R10, r10);
diff --git a/arch/x86/um/user-offsets.c b/arch/x86/um/user-offsets.c
index 3c19c48..88d1255 100644
--- a/arch/x86/um/user-offsets.c
+++ b/arch/x86/um/user-offsets.c
@@ -23,13 +23,13 @@ void foo(void)
 	DEFINE(HOST_IP, EIP);
 	DEFINE(HOST_SP, UESP);
 	DEFINE(HOST_EFLAGS, EFL);
-	DEFINE(HOST_EAX, EAX);
-	DEFINE(HOST_EBX, EBX);
-	DEFINE(HOST_ECX, ECX);
-	DEFINE(HOST_EDX, EDX);
-	DEFINE(HOST_ESI, ESI);
-	DEFINE(HOST_EDI, EDI);
-	DEFINE(HOST_EBP, EBP);
+	DEFINE(HOST_AX, EAX);
+	DEFINE(HOST_BX, EBX);
+	DEFINE(HOST_CX, ECX);
+	DEFINE(HOST_DX, EDX);
+	DEFINE(HOST_SI, ESI);
+	DEFINE(HOST_DI, EDI);
+	DEFINE(HOST_BP, EBP);
 	DEFINE(HOST_CS, CS);
 	DEFINE(HOST_SS, SS);
 	DEFINE(HOST_DS, DS);
@@ -38,13 +38,13 @@ void foo(void)
 	DEFINE(HOST_GS, GS);
 #else
 	DEFINE(HOST_FP_SIZE, sizeof(struct _fpstate) / sizeof(unsigned long));
-	DEFINE_LONGS(HOST_RBX, RBX);
-	DEFINE_LONGS(HOST_RCX, RCX);
-	DEFINE_LONGS(HOST_RDI, RDI);
-	DEFINE_LONGS(HOST_RSI, RSI);
-	DEFINE_LONGS(HOST_RDX, RDX);
-	DEFINE_LONGS(HOST_RBP, RBP);
-	DEFINE_LONGS(HOST_RAX, RAX);
+	DEFINE_LONGS(HOST_BX, RBX);
+	DEFINE_LONGS(HOST_CX, RCX);
+	DEFINE_LONGS(HOST_DI, RDI);
+	DEFINE_LONGS(HOST_SI, RSI);
+	DEFINE_LONGS(HOST_DX, RDX);
+	DEFINE_LONGS(HOST_BP, RBP);
+	DEFINE_LONGS(HOST_AX, RAX);
 	DEFINE_LONGS(HOST_R8, R8);
 	DEFINE_LONGS(HOST_R9, R9);
 	DEFINE_LONGS(HOST_R10, R10);
-- 
1.7.2.5


