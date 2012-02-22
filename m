Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2BVOmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:42:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2BVOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:42:10 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=HmKwCyU6VAUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=6rqHouBjAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=JCgRrJU8xZlYTtQTdGEA:9 a=QEXdDO2ut3YA:10 a=L-Pl8FbaxK8A:10 a=TAmEwCHjoHMA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=5JBI9FAcGiDiLK12M40A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120222144209.163172946@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 22 Feb 2012 09:40:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Vagin <avagin@openvz.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/9] tracing: Dont print an extra separator of flags
References: <20120222144036.824378742@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Don-t-print-an-extra-separator-of-flags.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Andrey Vagin <avagin@openvz.org>

If __print_flags() is used after another __print_*() function, the
temp seq_file buffer will not be empty on entry, and the delimiter will
be printed even though there's just one field. We get something like:

	|S

instead of just:

	S

This is because the length of the temp seq buffer is used to determine
if the delimiter is printed or not. But this algorithm fails when
the seq buffer is not empty on entry, and the delimiter will be printed
because it thinks that a previous field was already printed.

Link: http://lkml.kernel.org/r/1329650167-480655-1-git-send-email-avagin@op=
envz.org

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 0d6ff355..3efd718 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -300,7 +300,7 @@ ftrace_print_flags_seq(struct trace_seq *p, const char =
*delim,
 	unsigned long mask;
 	const char *str;
 	const char *ret =3D p->buffer + p->len;
-	int i;
+	int i, first =3D 1;
=20
 	for (i =3D 0;  flag_array[i].name && flags; i++) {
=20
@@ -310,8 +310,10 @@ ftrace_print_flags_seq(struct trace_seq *p, const char=
 *delim,
=20
 		str =3D flag_array[i].name;
 		flags &=3D ~mask;
-		if (p->len && delim)
+		if (!first && delim)
 			trace_seq_puts(p, delim);
+		else
+			first =3D 0;
 		trace_seq_puts(p, str);
 	}
=20
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPRP7BAAoJEIy3vGnGbaoAkO8QAJzd5WlxfiOrT+mIp6H3X50X
wQFlIuChpyXN6ELxVKhdbuwVo5TKIvJ7lPVSz6oOp22JJjDqSpFzOweF7oPYg10q
KzUaddgYmXvKnnlfbOFFkvYVyrn6Iza+1MhJFTyVLbkzMieaC5mx802DAkil9bij
d+eB/Ix+QywRw+OIvJ5YVuQiFTEIeNbUfjF/Fa0lEEoeqK1o+LHd00xb/m1umTM1
TmSWAb05gmJGLdhW38/7nyTS5ty9/yLgLetWkaug2cKDspt6Trev+WqE+Ix7BhqZ
bgQ3Ep/fMtdT/74FPIvbl1BKmGhwKOkxnPDrtPpBYkK1xK9m7YY04hjmeppA2k9o
KlWdWXMxojfpQ0+xica+ja9mh9cZHAomWG1vfQtT6zx3ho+CZnwOtptxiwCy2VqY
o3YtfJyCBtPcFPw760xTmu/JOvHngx8HNTNfEYBEMP0V6pb5Stl5uXIdMckfL3kR
PPs+SsRe5fOkptGfScWw+SVnY94tFhWchmUiaVTpFkwAg9D/JZMKOATrcaenH1xc
aNrnHhTgORHir6lKRAOLaK7evSvIIQVc1Yc2l2QNRqcN95LzYtKXgXgiGJL6iBal
UQ7b4JBYWX6JhlMmj3Z4+tn+faw0c8xk5ge/2z1Vda0OS1+yYnMPIo2fMT97MyUb
7sA8Hs4ErhdNkbuTzzdl
=rqax
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
