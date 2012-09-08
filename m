Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2IHL5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:57:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab2IHL4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:56:42 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=JqQ2eyqQkcYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1q3Gf7XPKNEA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=PtDNVHqPAAAA:8 a=drOt6m5kAAAA:8 a=UPm3pfgAAAAA:8 a=uMbGErvHagTwsCRPU3sA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=wYE_KDyynt4A:10 a=mOio7EKfaG4A:10 a=jeBq3FmKZ4MA:10 a=BXu13ANRUyYBbsypKl0A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120908115640.529406610@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 08 Sep 2012 07:55:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 3/7] trace: Stop compiling in trace_clock unconditionally
References: <20120908115515.211175517@goodmis.org>
Content-Disposition: inline; filename=0003-trace-Stop-compiling-in-trace_clock-unconditionally.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Commit 56449f437 "tracing: make the trace clocks available generally",
in April 2009, made trace_clock available unconditionally, since
CONFIG_X86_DS used it too.

Commit faa4602e47 "x86, perf, bts, mm: Delete the never used BTS-ptrace cod=
e",
in March 2010, removed CONFIG_X86_DS, and now only CONFIG_RING_BUFFER (split
out from CONFIG_TRACING for general use) has a dependency on trace_clock. S=
o,
only compile in trace_clock with CONFIG_RING_BUFFER or CONFIG_TRACING
enabled.

Link: http://lkml.kernel.org/r/20120903024513.GA19583@leaf

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/Makefile       |    2 +-
 kernel/trace/Kconfig  |    5 +++++
 kernel/trace/Makefile |    6 +-----
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index c0cc67a..29d993b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -98,7 +98,7 @@ obj-$(CONFIG_COMPAT_BINFMT_ELF) +=3D elfcore.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC) +=3D elfcore.o
 obj-$(CONFIG_FUNCTION_TRACER) +=3D trace/
 obj-$(CONFIG_TRACING) +=3D trace/
-obj-$(CONFIG_X86_DS) +=3D trace/
+obj-$(CONFIG_TRACE_CLOCK) +=3D trace/
 obj-$(CONFIG_RING_BUFFER) +=3D trace/
 obj-$(CONFIG_TRACEPOINTS) +=3D trace/
 obj-$(CONFIG_IRQ_WORK) +=3D irq_work.o
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 9301a0e..4cea4f4 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -62,8 +62,12 @@ config HAVE_C_RECORDMCOUNT
 config TRACER_MAX_TRACE
 	bool
=20
+config TRACE_CLOCK
+	bool
+
 config RING_BUFFER
 	bool
+	select TRACE_CLOCK
=20
 config FTRACE_NMI_ENTER
        bool
@@ -114,6 +118,7 @@ config TRACING
 	select NOP_TRACER
 	select BINARY_PRINTF
 	select EVENT_TRACING
+	select TRACE_CLOCK
=20
 config GENERIC_TRACER
 	bool
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 8370908..d7e2068 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -19,11 +19,7 @@ endif
=20
 CFLAGS_trace_events_filter.o :=3D -I$(src)
=20
-#
-# Make the trace clocks available generally: it's infrastructure
-# relied on by ptrace for example:
-#
-obj-y +=3D trace_clock.o
+obj-$(CONFIG_TRACE_CLOCK) +=3D trace_clock.o
=20
 obj-$(CONFIG_FUNCTION_TRACER) +=3D libftrace.o
 obj-$(CONFIG_RING_BUFFER) +=3D ring_buffer.o
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQSzJ4AAoJEIy3vGnGbaoALb8QAKxC7SXtIkxKSwPcpJvrwqUg
wntotQBCfqXiLYsJh44gmQbsrlS15OXYXfGexVwchR9n0DyCrDWoqcpbuQ2dcvFW
sS7qnnsRw1qLLuwBmZnkz5LwC4zXH1vh6cAU3OW2FVjVe8hcuS6EAKt+yuIzKosB
lc2ewsUIWTxhTJFKkrgXXv26vlhWSUDoHVRXHiWCoya/lrpJLAAlfNGsZJhiivAO
IPbNy8N5fRiMI5cRFQ2gIty0IX9n1xiFUF/7yW+TX12S6MDg1zQ5c+7XEQWKyHK7
qiuMKMNgcx+EW1+vjyYGW3AM/iDzWcqJx961gEhK08LpM/0ZMW0FXGDT27rRd391
/R6xVSogyTZQqgHEkgvdRifTpHDSyUuSfhyQ2dr8CMef4Xu20vMQMpFENVnF3JfP
Jj43rNCYMRvvR//KKf7+2KqZf69A3mLxNrBu7AIqxn6rvBG17jg6KryzOG6Ne/86
cUfJvI8ueLQBVHoYHSEtOk0zwdQKmc1Ybt610UFdYoOvk1tZAub9tGpK2BJNIBDT
uHoAUnycSfKjeZPHXK4e/Qhp3Csp4I/ZEPzFAe4ChFx4/cKFKr92T+OS6U3HhhrW
ZrawELs6ce0iCnlopxT3T5BjxDF9h3MD4Ti9/1nztrYTYKxLm7vuOGkqsHkpHVNx
wD3d5GAa2LaDqnCoLgzA
=t/Nx
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
