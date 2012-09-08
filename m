Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2IHL6E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:58:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab2IHL4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:56:43 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=sZWjV8fAZBkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Gn1p4xn9XDUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=oGMlB6cnAAAA:8 a=3nbZYyFuAAAA:8 a=OBiwKR5jmZHAFwYwkBQA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=3M1uARLWFndmn_kUQ38A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120908115640.779471731@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 08 Sep 2012 07:55:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 4/7] ftrace/x86: Adjust x86 regs.ip as like as x86-64
References: <20120908115515.211175517@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-x86-Adjust-x86-regs.ip-as-like-as-x86-64.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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

iQIcBAABAgAGBQJQSzJ4AAoJEIy3vGnGbaoAsRAQAOs7D4LInLMf3GFUsY326JVH
jzsNrpEbEIGvd73BXzWeWkXSDoNzaUhJAuE0ACPKwn2uacoQ8pV/3aVKES8WHy97
EsZ6CSfDbJrY5BUZ25EbjLY1TiJtfaEbAL/AF36dSaTCAj/6SYWjZIOMqW9FguSL
xIbsXSgg1keZ5ohMu4Bt/dkrBGnF7y/7d7uCz2ck4Sf994HdAWPPjj29c23BlJvF
FKBqjKF+nKc6ieuK+NtDRfZaJUX2ZEPS6QmGmrFsUzhZnk9eqqwGurvdaLktYGkX
CO4VGDuaeMzbQTHPd7rJKnsKB7gn4isGzybb79JIYERDSErEXZDM7bPUdzH3AUI/
SfwohR5f4+nkGK5EaTkfzIFELA4hVXxA4/o0+N9IAep1EB/awhsboqnySN4lGHzx
L1KeAg7jIqc010akrRN3m3nTdZX07R7moQW4IteP4MWIcFq+sM4FiSdzpv5MRsgP
5w+bfDWu6Uep8R1VJY++p3oXd9d1XtO5gY1hDtDcESl0CXXDv9HsFUD84bSUDqBQ
ZUVZMYCaKfUpjYfJU3Bzyo/ZSN3M4IvQnnw7sLvXBPPsTnnObi648G3QgOrPX4tI
Nxtv8WkpsnhLzXO3RPfGdGfQwFXLgES+cIfLxiHNkFo6kuTubj8Q6kbxLzpUZUyD
K7TW5Pedj6T8N/4eTkHH
=t6zy
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
