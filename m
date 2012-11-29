Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab2K2BYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:24:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9831 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab2K2BYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:24:32 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=NWE-DfuZo18A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=MOQqWvG9ABwA:10 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=5F87krKy-Ch-Y-VvF2oA:9 a=QEXdDO2ut3YA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=arzFhO6oAAAA:8 a=E0mzQjHhEipPLPF19dUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121129012431.307425107@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 28 Nov 2012 20:23:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH 2/3] tracing: Remove unneeded checks from the stack tracer
References: <20121129012340.602023062@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Remove-unneeded-checks-from-the-stack-tracer.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Anton Vorontsov <anton.vorontsov@linaro.org>

It seems that 'ftrace_enabled' flag should not be used inside the tracer
functions. The ftrace core is using this flag for internal purposes, and
the flag wasn't meant to be used in tracers' runtime checks.

stack tracer is the only tracer that abusing the flag. So stop it from
serving as a bad example.

Also, there is a local 'stack_trace_disabled' flag in the stack tracer,
which is never updated; so it can be removed as well.

Link: http://lkml.kernel.org/r/1342637761-9655-1-git-send-email-anton.voron=
tsov@linaro.org

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_stack.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 0c1b1657..42ca822 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -33,7 +33,6 @@ static unsigned long max_stack_size;
 static arch_spinlock_t max_stack_lock =3D
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
=20
-static int stack_trace_disabled __read_mostly;
 static DEFINE_PER_CPU(int, trace_active);
 static DEFINE_MUTEX(stack_sysctl_mutex);
=20
@@ -116,9 +115,6 @@ stack_trace_call(unsigned long ip, unsigned long parent=
_ip,
 {
 	int cpu;
=20
-	if (unlikely(!ftrace_enabled || stack_trace_disabled))
-		return;
-
 	preempt_disable_notrace();
=20
 	cpu =3D raw_smp_processor_id();
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQtrlPAAoJEOdOSU1xswtMVFkH/A/rU2jVlaKtLL7U68r9G+RU
pAPqK7JZc86OGFDKJtAC5RwIHBiUX4Xo5K/CyA83j0yCMPbzY60rLIUljoEY1HDO
O4v7bHjXelwsdAh+FNSfO+STTfVW+F5Dzd2QfSgbEqjW5kC2UgaztQyDdDYUPgu/
d7UXvTnlo1RmE5TbI0i1UU6JFjQFeYv++3Zg163XBTgtkaONA8xoXnEf8nVpkk12
o+ja/6DFB0m62kL+bPGAufFzXuB2JPBubwmm3dG6Q8TC5qLlmM++Z9m4b2geauvH
pJr2b/R5i6qfZ+UrqOVEiKLPN/GaEVZqYwxpz7ewZiFill34WU7F8Pn8ytt51cQ=
=KdTu
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
