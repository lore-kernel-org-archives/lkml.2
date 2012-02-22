Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab2BVOmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:42:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2BVOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:42:10 -0500
X-Authority-Analysis: v=2.0 cv=Z7xu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=IrdGxtXvW_gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=6rqHouBjAAAA:8 a=meVymXHHAAAA:8 a=x4juDkwiTz4k5SnEwtgA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=TAmEwCHjoHMA:10 a=jeBq3FmKZ4MA:10 a=SUCgy8MvhVpMuhPqhuAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120222144209.470203447@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 22 Feb 2012 09:40:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Vagin <avagin@openvz.org>
Subject: [PATCH 2/9] tracing: Dont use p->len field to determine output in __print_*()
 functions
References: <20120222144036.824378742@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Don-t-use-p-len-field-to-determine-output-in.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

If more than one __print_*() function is used in a tracepoint
(__print_flags(), __print_symbols(), etc), then the temp seq buffer will
not be zero on entry. Using the temp seq buffer's length to know if
data has been printed or not in the current function is incorrect and
may produce incorrect results.

Currently, no in-tree tracepoint causes this bug, but new ones may
be created.

Cc: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 3efd718..c5a0187 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -319,7 +319,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char =
*delim,
=20
 	/* check for left over flags */
 	if (flags) {
-		if (p->len && delim)
+		if (!first && delim)
 			trace_seq_puts(p, delim);
 		trace_seq_printf(p, "0x%lx", flags);
 	}
@@ -346,7 +346,7 @@ ftrace_print_symbols_seq(struct trace_seq *p, unsigned =
long val,
 		break;
 	}
=20
-	if (!p->len)
+	if (ret =3D=3D (const char *)(p->buffer + p->len))
 		trace_seq_printf(p, "0x%lx", val);
=20=09=09
 	trace_seq_putc(p, 0);
@@ -372,7 +372,7 @@ ftrace_print_symbols_seq_u64(struct trace_seq *p, unsig=
ned long long val,
 		break;
 	}
=20
-	if (!p->len)
+	if (ret =3D=3D (const char *)(p->buffer + p->len))
 		trace_seq_printf(p, "0x%llx", val);
=20
 	trace_seq_putc(p, 0);
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPRP7BAAoJEIy3vGnGbaoA0gcQAOHhI8/faGIAEOoecGURCAXQ
OJ3J9wtdu+LEEk+7YzO7c2FkEn2RE+R/1SkW8LN1YaveBFkgdh/UwjLTzB04sIHT
8kq2wWgXbDUkHPczVE6gDB6OzFrdJBLfet+OGzTt6kiiwrwuBmObXtbdFQaXnFww
3scwD8CPOE2j35CNLGD34TVhjjLOajqgv2m1pSIRY5p+Arz83g+novQ/yrXgl8is
uQC78Z2qz2bEjD67LKrWLDM34JThQydkQjma5oHDD/wX0bmKjL5c18gMMAfIDSQt
syZzXnX0R8HxhhhtxnJK4HfxYodidO6xY2VMMdnZqeA7IpEFCtWO6ZOlxyv+HyH3
OUWAgrjZ0estrvqKSap1ipcd1KdBkQoL2bT39oxUXwaH0QRhhRXzTIdpV/ZFRKfC
ueM4xOtPTCTz9kXRNjOw5EQbtnnSTK3uWP7hxi60TYuBw2FWH5biqC/Je7xcIztC
e5Fy/17Mf4A94UZX5xgRrF9GE51ypFIW/6Uemj8SmhWhRnyWrzIdej0cQ+tYqxFB
O8/L+BHz98vkQYyn6Cr+VGVbGR2n9kfelFFwir9UQH0q9HBcTkihRxmPJbgdndW6
z92GFSI+h4Bb1mP3hwGbkujDLvOFkivxj85qPa73zHiQWhFRBYaeuvf7Q54foqg5
Piv0N9UOmJG33Al9FnX9
=NlIW
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
