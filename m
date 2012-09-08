Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab2IHL6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:58:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab2IHL4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:56:44 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=x95JZBvoG_oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=J3mLef8YEV4A:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=oGMlB6cnAAAA:8 a=3nbZYyFuAAAA:8 a=lR2eCoyCdom3i2FEe1kA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=ssJKymMJzDmWYoVbEggA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120908115641.281841506@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 08 Sep 2012 07:55:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 6/7] ftrace/x86-64: Allow to change RIP in handlers
References: <20120908115515.211175517@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-x86-64-Allow-to-change-RIP-in-handlers.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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

iQIcBAABAgAGBQJQSzJ5AAoJEIy3vGnGbaoARLMP/0y/0sAJCFgEnKXwI+EyQNp/
WIGupmOiZQXCXA0LzO9USY3TNkrp1sKEF5WezfxkdbwfOc5ke9sIb5wYB+wWNJDO
lO7wVqiwwppLAnje/27Wr+LLPTthmUxBxRc6TTthZXg4nMc8pC/cLKTUEJi3oMxY
GZqskEo8IxYLSOeuxnKvvkzwyKllZkc/fewsAijjaL4IGM/Nig8YFR0o7BqDXWPW
g/gbHD8U1lVjKYDALVh4jgk3+7ZE9rt0xJklC70WTMw0PPtzoEBtNYf7I7xt/Y2d
TaAAugMbVg9OK5bw7WcTSIGJ5Au6jf7/hXCp3/ClGyU213oPKwMNmc0V7V5iViKo
3k5MxcX/oiQ7RABeJRYEVn5B2toDV9iNvepEDWHFqEOy59gd9B4FjZD5vTuUvVhJ
nKRzlb1X/k74RdpIxpuSwrwZ/RBLfTr1KU4+HS1nFSTBtlMs+37TeZocJwAXHKbw
12MwefUEgwPYzUE1OaT/pNYHm92u3UUlEe9WN8XOeMuC+pk6J7d86yw1yg8oHI+H
Nyshj03KqBlB3DalqXzpfZJMVGM1EH9dNMTjbqOKPw7QslB/ugbKRk0/80VMfRTv
Qx09PqgQG2KQAkRxYf6f572L7KMze9MCKQkQ7qNKCkGUI8D1WYh3ig0zH6y03DXw
T3KiauiDpi23107LGaRe
=13NA
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
