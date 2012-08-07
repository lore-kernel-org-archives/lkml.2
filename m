Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab2HGTlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:41:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2HGTlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:41:01 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=QhkCUXG-H5AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=pona7K65P9ap3Zuk5UQA:9 a=QEXdDO2ut3YA:10 a=CLuxrJBrMz7ket38U1oA:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120807193845.146666357@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 15:38:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: [RFC PATCH 0/4] ftrace: Add use of -mfentry for x86_64
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


This is an RFC patch set that makes gcc use the -mfentry option with
-pg. This will set the ftrace 'hook' to the beginning of the function
and also remove the requirement that -pg enables frame pointers.

This has a couple of benefits (and probably more).

1) removal of the frame pointer requirement makes for smaller and faster co=
de.

2) Having the function trace hook at the beginning of the function instead
 of after the frame is set up, gives the function tracing callbacks access
 to the parameters. This means that kprobes can take advantage of this.
 When a kprobe is set on top of a ftrace hook (nop), it will automatically
 use the function tracing callback. This makes it into an 'optimized' probe
 as there's no need to hit a breakpoint and trigger the probe that way.
 The function tracing code can do the work for it. Note, optimized probes
 are only allowed with !PREEMPT, but a ftrace optimize probe is allowed
 in any context (another benefit).

This only implements fentry for x86_64.

Steven Rostedt (4):
      ftrace: Make recordmcount.c handle __fentry__
      ftrace: Add -mfentry to Makefile on function tracer
      ftrace: Do not test frame pointers if -mfentry is used
      ftrace/x86: Add support for -mfentry to x86_64

----
 Makefile                             |    6 +++++-
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/ftrace.h        |    7 ++++++-
 arch/x86/kernel/entry_64.S           |   18 +++++++++++++++++-
 arch/x86/kernel/x8664_ksyms_64.c     |    6 +++++-
 kernel/trace/Kconfig                 |    5 +++++
 kernel/trace/trace_functions_graph.c |    5 ++++-
 scripts/recordmcount.h               |    4 +++-
 8 files changed, 46 insertions(+), 6 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQIW9HAAoJEIy3vGnGbaoAg9MQAI5p2XE+iJ3OjWG4gkXf8bY0
0R3MZT2lVD49HcDJFiPGRuQnjdVzRW3YPqWKAWnU69FZjXFtZG2RcGXLmAW3XJ0U
cKhCwPQH5yjcUc/MbIRZY3QlFmIvyvSapGaLm+j4QbPCJ01v8WNnaXdYUcvFjbuu
Ycso27GqWsFy6spWwDhC1DEWsHoS/ke/Wr5RljI5n3Nw7RKufSy4mmEr4W4f9Gs8
QIzIlDvvE6DkkGuPW4zFk3Z109H2pF5ZDD+rzz/VRgGGbta/HySfePLeQeCG7MEr
gZlKCnAcx27vAYEElGDUANtBuDGekQAYHn842qh4ewSckr1Lk000XZKNfu+67q8/
HWz68A6bilLnwO9/eGyPb98WDcSCVX9jha/hwe7brVZ4+hehqY23Dt6GMXCg9GgC
SFfCH/buPk41j1O4rHhXyUIPgw+iFQbwBqt7jR49G9GuLDl0fG5Bbv9oHAj5qgzn
zX/jwUpJh207yc9Zn4hyTGbUSE7nKYKT7o5fiBfj7CE/vkfQDb2BTIWhrNOiiK47
wAPxAekTZxzFB1bPsg/ajj8BB/N9PtV6lCgSUb0xw5TbZJFuqfkVC58s8LxWJ/UW
Wu2MGk0WiTnpahIptDfpZ9c9qP6UslW4pVVOUStEbgSVb6ReBV6Ha51UD0FIR0QD
6GvgEAWm8me12CkQ+ZIX
=bRPu
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
