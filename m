Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762808Ab2KBNks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:40:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab2KBNfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:00 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=n9GAJlKca5MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=kgZXo9VCcP0A:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=JwPKamSbfkLzRgZ14uUA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=V2hR76fSnSewNs33FIkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133458.368323265@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:32:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 03/22] tracing: Change tracers integer flags to bool
References: <20121102133251.998500247@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Change-tracer-s-integer-flags-to-bool.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>

print_max and use_max_tr in struct tracer are "int" variables and
used like flags. This is wasteful, so change the type to "bool".

Link: http://lkml.kernel.org/r/20121002082710.9807.86393.stgit@falsita

Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h              |    4 ++--
 kernel/trace/trace_irqsoff.c      |   12 ++++++------
 kernel/trace/trace_sched_wakeup.c |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index c15f528..c56a233 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -285,8 +285,8 @@ struct tracer {
 	int			(*set_flag)(u32 old_flags, u32 bit, int set);
 	struct tracer		*next;
 	struct tracer_flags	*flags;
-	int			print_max;
-	int			use_max_tr;
+	bool			print_max;
+	bool			use_max_tr;
 };
=20
=20
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 11edebd..5ffce7b 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -604,7 +604,7 @@ static struct tracer irqsoff_tracer __read_mostly =3D
 	.reset		=3D irqsoff_tracer_reset,
 	.start		=3D irqsoff_tracer_start,
 	.stop		=3D irqsoff_tracer_stop,
-	.print_max	=3D 1,
+	.print_max	=3D true,
 	.print_header   =3D irqsoff_print_header,
 	.print_line     =3D irqsoff_print_line,
 	.flags		=3D &tracer_flags,
@@ -614,7 +614,7 @@ static struct tracer irqsoff_tracer __read_mostly =3D
 #endif
 	.open           =3D irqsoff_trace_open,
 	.close          =3D irqsoff_trace_close,
-	.use_max_tr	=3D 1,
+	.use_max_tr	=3D true,
 };
 # define register_irqsoff(trace) register_tracer(&trace)
 #else
@@ -637,7 +637,7 @@ static struct tracer preemptoff_tracer __read_mostly =3D
 	.reset		=3D irqsoff_tracer_reset,
 	.start		=3D irqsoff_tracer_start,
 	.stop		=3D irqsoff_tracer_stop,
-	.print_max	=3D 1,
+	.print_max	=3D true,
 	.print_header   =3D irqsoff_print_header,
 	.print_line     =3D irqsoff_print_line,
 	.flags		=3D &tracer_flags,
@@ -647,7 +647,7 @@ static struct tracer preemptoff_tracer __read_mostly =3D
 #endif
 	.open		=3D irqsoff_trace_open,
 	.close		=3D irqsoff_trace_close,
-	.use_max_tr	=3D 1,
+	.use_max_tr	=3D true,
 };
 # define register_preemptoff(trace) register_tracer(&trace)
 #else
@@ -672,7 +672,7 @@ static struct tracer preemptirqsoff_tracer __read_mostl=
y =3D
 	.reset		=3D irqsoff_tracer_reset,
 	.start		=3D irqsoff_tracer_start,
 	.stop		=3D irqsoff_tracer_stop,
-	.print_max	=3D 1,
+	.print_max	=3D true,
 	.print_header   =3D irqsoff_print_header,
 	.print_line     =3D irqsoff_print_line,
 	.flags		=3D &tracer_flags,
@@ -682,7 +682,7 @@ static struct tracer preemptirqsoff_tracer __read_mostl=
y =3D
 #endif
 	.open		=3D irqsoff_trace_open,
 	.close		=3D irqsoff_trace_close,
-	.use_max_tr	=3D 1,
+	.use_max_tr	=3D true,
 };
=20
 # define register_preemptirqsoff(trace) register_tracer(&trace)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_w=
akeup.c
index 2f6af78..bc64fc1 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -589,7 +589,7 @@ static struct tracer wakeup_tracer __read_mostly =3D
 	.reset		=3D wakeup_tracer_reset,
 	.start		=3D wakeup_tracer_start,
 	.stop		=3D wakeup_tracer_stop,
-	.print_max	=3D 1,
+	.print_max	=3D true,
 	.print_header	=3D wakeup_print_header,
 	.print_line	=3D wakeup_print_line,
 	.flags		=3D &tracer_flags,
@@ -599,7 +599,7 @@ static struct tracer wakeup_tracer __read_mostly =3D
 #endif
 	.open		=3D wakeup_trace_open,
 	.close		=3D wakeup_trace_close,
-	.use_max_tr	=3D 1,
+	.use_max_tr	=3D true,
 };
=20
 static struct tracer wakeup_rt_tracer __read_mostly =3D
@@ -610,7 +610,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =3D
 	.start		=3D wakeup_tracer_start,
 	.stop		=3D wakeup_tracer_stop,
 	.wait_pipe	=3D poll_wait_pipe,
-	.print_max	=3D 1,
+	.print_max	=3D true,
 	.print_header	=3D wakeup_print_header,
 	.print_line	=3D wakeup_print_line,
 	.flags		=3D &tracer_flags,
@@ -620,7 +620,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =3D
 #endif
 	.open		=3D wakeup_trace_open,
 	.close		=3D wakeup_trace_close,
-	.use_max_tr	=3D 1,
+	.use_max_tr	=3D true,
 };
=20
 __init static int init_wakeup_tracer(void)
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQk8wCAAoJEOdOSU1xswtMpoEH/1OkIOJ3ZOZIY97wuIBHiW3T
9uaH74b/nsYq5K3IM82HVp4CfD+ki9WQ2gD8KLoXzl2TBA9T+eg3cZDOm7I6EmwV
FaARZsJG/uEyz2eHi5cSeLnqazDrWqty5T82keZW0lHUCzVN99VOV4KfcsQwTdXy
mAGy59DLOZgG1M8QPmiG66oOJu5ocYNV7Z1JC3A/qlTAvoQO9uUNwKVw0j/0aaOA
PmBmNqqvmYKV2dgnt3H8Gxn88CUZOxvSencwz8oH0yhHL8g2XJ7SzcLj5MI79Tuf
QcBj0oFaY25P4blzRH8TxurIO1Z6DLe97+Ny6hD322pxVjpDgKrU+B5j2RCX0Ds=
=7dhD
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
