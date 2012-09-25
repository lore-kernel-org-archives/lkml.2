Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab2IYTUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:20:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14792 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2IYTUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:20:31 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=U_mbyWwYQ7AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Vq-cWIhIvXQA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=cm27Pg_UAAAA:8 a=bNm0Aox0PFdcmLs32rUA:9 a=QEXdDO2ut3YA:10 a=lSinr4eg3GwA:10 a=MSl-tDqOz04A:10 a=zv9_9hqRWm8A:10 a=jeBq3FmKZ4MA:10 a=h_Gu6VKuNvZMsJcFuQcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120925192029.318594001@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 25 Sep 2012 15:19:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH 1/2] tracing: Add an option for disabling markers
References: <20120925191941.504217238@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-an-option-for-disabling-markers.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Mandeep Singh Baines <mandeep.baines@gmail.com>

In our application, we have trace markers spread through user-space.
We have markers in GL, X, etc. These are super handy for Chrome's
about:tracing feature (Chrome + system + kernel trace view), but
can be very distracting when you're trying to debug a kernel issue.

I normally, use "grep -v tracing_mark_write" but it would be nice
if I could just temporarily disable markers all together.

Link: http://lkml.kernel.org/r/1347066739-26285-1-git-send-email-msb@chromi=
um.org

CC: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    6 +++++-
 kernel/trace/trace.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 08acf42..1ec5c1d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -328,7 +328,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 unsigned long trace_flags =3D TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
 	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
-	TRACE_ITER_IRQ_INFO;
+	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS;
=20
 static int trace_stop_count;
 static DEFINE_RAW_SPINLOCK(tracing_start_lock);
@@ -470,6 +470,7 @@ static const char *trace_options[] =3D {
 	"overwrite",
 	"disable_on_free",
 	"irq-info",
+	"markers",
 	NULL
 };
=20
@@ -3886,6 +3887,9 @@ tracing_mark_write(struct file *filp, const char __us=
er *ubuf,
 	if (tracing_disabled)
 		return -EINVAL;
=20
+	if (!(trace_flags & TRACE_ITER_MARKERS))
+		return -EINVAL;
+
 	if (cnt > TRACE_BUF_SIZE)
 		cnt =3D TRACE_BUF_SIZE;
=20
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 593debe..63a2da0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -680,6 +680,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_OVERWRITE		=3D 0x200000,
 	TRACE_ITER_STOP_ON_FREE		=3D 0x400000,
 	TRACE_ITER_IRQ_INFO		=3D 0x800000,
+	TRACE_ITER_MARKERS		=3D 0x1000000,
 };
=20
 /*
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQYgP9AAoJEOdOSU1xswtMM1EIAKVcVxHiSahad2pT4xFS8Xmm
9ywg9xH6CebjOIan2EnKd0kOhlpGFma6DDOfWEAlH87hPzvwUef9UMXzk8xKxg9h
6HN+1zvPmILju5Y3EQzhWZsSu8+x5nXX6s5/x/Ml1IPYNT1dE+KCcYG5iM8Ha4Gg
2BYeXzh3wNeeSs6ZPDnvPdrmAj9mN03CkFaV085ySQxvYlzJeuAe8eUHi15znXsD
Z59syUTm2V8Y17RhrDQmGRH8456GVRflfxsaxACxcNwADghyNNGFVv2nfCOsu8jF
SisTGn+eQRKULaHBfVUlF7+ECM7FKTJTxbtl/soVZ34QnB0t/azlP1soBmyy6nU=
=tzdL
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
