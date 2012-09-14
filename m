Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab2INDCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:02:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5263 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2INDCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:02:38 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3qvk-dB0IBQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Dgzw98E_iesA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=oGMlB6cnAAAA:8 a=3nbZYyFuAAAA:8 a=lR2eCoyCdom3i2FEe1kA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=EvKJbDF4Ut8A:10 a=GkBNViQGmD32vGxRvvsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120914030232.866901397@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 13 Sep 2012 23:00:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 5/6 v2] ftrace/x86-64: Allow to change RIP in handlers
References: <20120914030012.315074731@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-x86-64-Allow-to-change-RIP-in-handlers.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <rostedt@goodmis.org>

Allow ftrace handlers to change RIP register (regs->ip)
in handlers. This will allow handlers to call another
function instead of original function.

Link: http://lkml.kernel.org/r/20120905143118.10329.5078.stgit@localhost.lo=
caldomain

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index ed767b7..e9cc2b3 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -165,6 +165,10 @@ GLOBAL(ftrace_regs_call)
 	movq EFLAGS(%rsp), %rax
 	movq %rax, SS(%rsp)
=20
+	/* Handlers can change the RIP */
+	movq RIP(%rsp), %rax
+	movq %rax, SS+8(%rsp)
+
 	/* restore the rest of pt_regs */
 	movq R15(%rsp), %r15
 	movq R14(%rsp), %r14
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQUp5IAAoJEOdOSU1xswtMTvQIAINghza9ztTl/Ho8fYKnRYpZ
lD1KdZI2lCM2ZkJK5rmFfWqnW/sZ1W80wxb+nsRRwO0HWPkgGNSU0Em4u2c7k0SF
N0ndz4zUx2ZRDPHtd3immlxa+AC147ibj9sfdaYZvqQB4lRF069ezyaBfdl+/e2P
QJQny+vvkXB3VA+7KknFj3wyH1a3NX/eWCVmT/N05szypK78EH3e+DhN002nHVlY
KwFbHPqO+X6KfqmEREHDTCDkRNbdwbg9GXTrfyq+91nMPyBfq5EAf75wxvv0E3az
+0EijVCp9GTE2S8dyDHn2eNlS7T0A7xGrVQXy8xqNTwdsmBC6ieHJtbm3/HG4JU=
=JhIn
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
