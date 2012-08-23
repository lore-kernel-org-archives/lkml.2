Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab2HWSRO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:17:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab2HWSRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:17:01 -0400
X-Authority-Analysis: v=2.0 cv=cpwZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=83F0lROKfGsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=zX0gvU8keR8A:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=WfulkdPnAAAA:8 a=8ssI5vCHBLmoMQwfYCYA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=l29vjEC0CZ8A:10 a=1Wy5nXbt1Apt5BJImcMA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120823181659.584532686@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 23 Aug 2012 14:15:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 3/4] ftrace: Do not test frame pointers if -mfentry is used
References: <20120823181537.510961094@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Do-not-test-frame-pointers-if-mfentry-is-used.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The function graph has a test to check if the frame pointer is
corrupted, which can happen with various options of gcc with mcount.
But this is not an issue with -mfentry as -mfentry does not need nor use
frame pointers for function graph tracing.

Link: http://lkml.kernel.org/r/20120807194059.773895870@goodmis.org

Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
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

iQIcBAABAgAGBQJQNnObAAoJEIy3vGnGbaoAGUsP/jxujdjxfWFBihYUSZdb0t6T
q+Tj79TrhxMErT4BIbtq0olWTyeRdqB/X0qk+jgkP9CpwUniOHceKHdu3kHoeSyp
GOMdRbyWK4J5dIck/6CPcaCo7HPwKxXQDlw2mCypDSgt0GlCzwx++tdb2cIBDljY
HD/Lfcnt78LlrLQGbjhvaC2eOBcJaJl8yxQcmZ5hWYkiQyPDXowW4sFU+LCmICh9
hBJkCXRdXsU2KkhFeBj5Gb556u2MboVY2R5T1gVa/x59FtgIgM9kkpoFdsoAuBKc
/qfXKPqob/gssLysnqmEb4rwUXcThogw0o2UwBmoLaD+ZYm4ifcwZp1br38xHFXb
A9+fyEBDmdbXHpzoFqcHiQmXhtj3MCmW0JnnXOIIG6LO1v2sdoQd754XdXo95/pE
/GpzfnoWZRGyzxBWCRNI3QtEtlFK45x6877+0FVRgcxp+6krl5sdlc0uOkXsmuc3
cyjAp0GCtNGrY5GZCDPfn/TkMfp8ZOUFtHsoGyeHSxOFU6tvHUXPYWfKWG5LK7Um
42qLIW0xCJFN3iNBIRdxrCAYUgudO9uandScSlu36ylji42PbY9GY/KJZXWpywsy
JiifHa78tttph6abHyq1LaTwXOBHwtnGKVdi4Ay/l+MufYwkZo2zVmfj8hmGNU+f
RrRu+ZiNJFJWTaxBsCe6
=uDdk
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
