Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab2CNQ2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:28:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15021 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab2CNQ1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:27:10 -0400
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=oTqng68SrWMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=y9qxmDDzVTqUmOHzw3gA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=WtEbjksQnbuKWQ758DcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314162708.960391639@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 14 Mar 2012 12:26:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rajesh Bhagat <rajesh.lnx@gmail.com>
Subject: [PATCH 4/6] ftrace: Fix function_graph for archs that test ftrace_trace_function
References: <20120314162629.118638243@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Fix-function_graph-for-archs-that-test-ftrace.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Rajesh Bhagat <rajesh.lnx@gmail.com>

When CONFIG_DYNAMIC_FTRACE is not set, some archs (ARM) test
the variable function_trace_function to determine if it should
call the function tracer. If it is not set to ftrace_stub, then
it will call the function and return, and not call the function
graph tracer.

But some of these archs (ARM) do not have the assembly code
to test if function tracing is enabled or not (quick stop of tracing)
and it calls the helper routine ftrace_test_stop_func() instead.

If function tracer is enabled and then disabled, the variable
ftrace_trace_function is still set to the helper routine
ftrace_test_stop_func(), and not to ftrace_stub. This will
prevent the function graph tracer from ever running.

Output before patch
/debug/tracing # echo function > current_tracer
/debug/tracing # echo function_graph > current_tracer
/debug/tracing # cat trace

Output after patch
/debug/tracing # echo function > current_tracer
/debug/tracing # echo function_graph > current_tracer
/debug/tracing # cat trace
0) ! 253.375 us | } /* irq_enter */
0) | generic_handle_irq() {
0) | handle_fasteoi_irq() {
0) 9.208 us | _raw_spin_lock();
0) | handle_irq_event() {
0) | handle_irq_event_percpu() {

Signed-off-by: Rajesh Bhagat <rajesh.lnx@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 867bd1d..0fa92f6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -249,7 +249,8 @@ static void update_ftrace_function(void)
 #else
 	__ftrace_trace_function =3D func;
 #endif
-	ftrace_trace_function =3D ftrace_test_stop_func;
+	ftrace_trace_function =3D
+		(func =3D=3D ftrace_stub) ? func : ftrace_test_stop_func;
 #endif
 }
=20
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPYMbdAAoJEIy3vGnGbaoAkwwQANvg94GSVwjkT7iw+M9aBg4C
RqGpU3Vhg+VPitwJH60QoOB2ENKf43WDqzF8PFbgf0ruAr9MMYWS5/utAr7iLIVZ
PLueALkq6xWe6xf8TB7evR5m+cibeORdVFXRplyDcFr214moGa2l5c5SnORefXV6
Xo/MCmEGNVFbTthO6rDVa/WoaWl44r/AMx9M2ol4DntgjmKrHqhMR8bMnLFzafWD
I/LojKGmP3xO8Vu7buox4eS3netzQ6/9IEGiFOL8jKrK+SqjMYAfC2Ve9w8yp9bW
BnEH7MfmMZMmmJNXRI9FwcuRRttTGZA39ddpvE6fJZkfXNbP5g0tAhCllR7mb6KU
VQ0XM0+8Gn+ybxX6nOjtqhc6IdxBm/guReNwIu1pN7PP5aS4UyD60RucJE5bL2qA
u4605g7MRFQNn6xOP5o0muhNvTbgTd5xsTt3tRa+93EWKV5uMOizwfD98Py/I4h1
r6Q2aS9KqGb4U05dzpYe7ot6vB9jeSU5jep+2WaA1JmjV+/Ir6R6xeFGQPJM2Ih8
ZKl6NTkPF/4kPpOnm+mjLcX4tfVjKT36bhE93ybdDRoN9vbF499mW1HAkN3WSVDH
zwKyc5psNJ7DmJeFcpNxuD/o5itgz0/WKeMqnfZMDD6gID7dcCNfk+Pc6/bBr3JA
M6INSZT6Ug66Zkq2HdLO
=NQyJ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
