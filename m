Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2HGTlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:41:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9433 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2HGTlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:41:01 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=uwhVmGxDrvkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=WfulkdPnAAAA:8 a=8ssI5vCHBLmoMQwfYCYA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=l29vjEC0CZ8A:10 a=jeBq3FmKZ4MA:10 a=deaTVd96uIQTNREpzooA:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120807194059.773895870@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 15:38:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: [RFC PATCH 3/4] ftrace: Do not test frame pointers if -mfentry is used
References: <20120807193845.146666357@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Do-not-test-frame-pointers-if-mfentry-is-used.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

The function graph has a test to check if the frame pointer is
corrupted, which can happen with various options of gcc with mcount.
But this is not an issue with -mfentry as -mfentry does not need nor use
frame pointers for function graph tracing.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_func=
tions_graph.c
index ce27c8b..99b4378 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -143,7 +143,7 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace,=
 unsigned long *ret,
 		return;
 	}
=20
-#ifdef CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST
+#if defined(CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST) && !defined(CC_USING_FENTR=
Y)
 	/*
 	 * The arch may choose to record the frame pointer used
 	 * and check it here to make sure that it is what we expect it
@@ -154,6 +154,9 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace,=
 unsigned long *ret,
 	 *
 	 * Currently, x86_32 with optimize for size (-Os) makes the latest
 	 * gcc do the above.
+	 *
+	 * Note, -mfentry does not use frame pointers, and this test
+	 *  is not needed if CC_USING_FENTRY is set.
 	 */
 	if (unlikely(current->ret_stack[index].fp !=3D frame_pointer)) {
 		ftrace_graph_stop();
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQIW9LAAoJEIy3vGnGbaoA2V0P/21rdowPjHB9DfepWhywkAfT
ouUlCIOg9IW2DW/lHxAhHCgJTjGCbj2S4FED2FQswXJWMGzWJwHL6o06BQ9KwRn4
gXqheI4MJ2PxKsFjulNQuS/upcQcmIGwG0H7ws6o4s9/0gipa/Jlf14Xnr2DMSKs
KfGEwCVCkYYStwkxFbWEhz0u2QgJTB+muIHk0wmdL2XaOHAj1e53hhCwpvZxhav0
YItHwj2qG8dGRMDfRFrER08uOM7UydV87EH7rcBHwB7/oH/rKYtvK6W7B4XzLRas
faUH9w95kOIxEosn2g4l0UdPXD+1A3+PuhCTFuLli+/BclGEWTH5c3Q0QhlbKfiC
DBl0HcX0Va0dmFgqpoggm7lNDzl/y0qxlaJHuDktxjT0dgpdbcmV+U/G/Qtq3ZyQ
bLSLpv+JFYj0111R9D6HobYhDSOt1489/zQYuWAirrdDOxyIQSZB8rWrz9VwWe9O
ff46Fx86cKhJFyX/PH76shvQUevGOHwEKBAgnV+2O2BidN2Cz0mnOfpc9dnWgFNY
fxaXlKWVrRVxQzdEoe0irfPiPaNoo53cv5oejwHIZS/d9N2MPfhotb/Gywjir8/S
V0v8Rqzop6OcaFxcDBiIO+LU+oFMTO2K4McLQoShV9sO0eWF/IFj0WTfDv3uqZdt
bhcPhR0Z/kviqwnlpsfc
=8Gmq
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
