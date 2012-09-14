Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2INDCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:02:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29837 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2INDCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:02:34 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=hRlw7-BsCYcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=uHH_MGhAN-gA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=oGMlB6cnAAAA:8 a=OBiwKR5jmZHAFwYwkBQA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=Au_m1z0QeQneEPZj9kgA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120914030232.492254971@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 13 Sep 2012 23:00:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 3/6 v2] ftrace/x86: Adjust x86 regs.ip as like as x86-64
References: <20120914030012.315074731@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-x86-Adjust-x86-regs.ip-as-like-as-x86-64.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Adjust x86 regs.ip to ip + MCOUNT_INSN_SIZE as like as
on x86-64. This helps us to consolidate codes which use
regs->ip on both of x86/x86-64.

Link: http://lkml.kernel.org/r/20120905143100.10329.60109.stgit@localhost.l=
ocaldomain

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_32.S |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 061ac17..f438a44 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1148,7 +1148,6 @@ ENTRY(ftrace_regs_caller)
 	 * ip location, and move flags into the return ip location.
 	 */
 	pushl 4(%esp)	/* save return ip into ip slot */
-	subl $MCOUNT_INSN_SIZE, (%esp)	/* Adjust ip */
=20
 	pushl $0	/* Load 0 into orig_ax */
 	pushl %gs
@@ -1169,6 +1168,7 @@ ENTRY(ftrace_regs_caller)
 	movl $__KERNEL_CS,13*4(%esp)
=20
 	movl 12*4(%esp), %eax	/* Load ip (1st parameter) */
+	subl $MCOUNT_INSN_SIZE, %eax	/* Adjust ip */
 	movl 0x4(%ebp), %edx	/* Load parent ip (2nd parameter) */
 	leal function_trace_op, %ecx /* Save ftrace_pos in 3rd parameter */
 	pushl %esp		/* Save pt_regs as 4th parameter */
@@ -1180,7 +1180,6 @@ GLOBAL(ftrace_regs_call)
 	movl 14*4(%esp), %eax	/* Move flags back into cs */
 	movl %eax, 13*4(%esp)	/* Needed to keep addl from modifying flags */
 	movl 12*4(%esp), %eax	/* Get return ip from regs->ip */
-	addl $MCOUNT_INSN_SIZE, %eax
 	movl %eax, 14*4(%esp)	/* Put return ip back for ret */
=20
 	popl %ebx
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQUp5IAAoJEOdOSU1xswtM+2UH/RPhmrrcbyzsqCWXzruVvLL9
wtXRfnmeVY9dXaphuH18Y0Drsr6BeYGZnZyD3NTL548u3qaCtIgh2O4i52UUn2aG
lPO8CQpckzhcQwR+JszeOAoTAyDdgeomsMlVPj37r1oWdd70TO3NC2btYAYbvDCW
rxd6wfY7bSMsbEfkzkt6Cbl5YWH99cPd2D/z2DUeDTxPLMvyc1xkUT7xOvp2VVS3
LLK4GHkGEK5n5PN8rpzMJ8wIR4/XRRBo6jb90+PnW/aK8n9ligHCutfQElnzYygG
jO7FGqTY9MaBReGpwG79Nb4iRRV1CVrMD6zsNyVBQCRwBGLc9bNFB0Lw+hoU1TA=
=YEML
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
