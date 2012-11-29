Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab2K2BYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:24:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29489 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab2K2BYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:24:32 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=1760ZO6X2J0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=yMxZZsWedhkA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=z4-vK0M_khU3xeFmJKYA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Av0ydlvL0s1vSE-7gqIA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121129012431.485422281@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 28 Nov 2012 20:23:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>
Subject: [PATCH 3/3] tracing: Remove unnecessary WARN_ONCEs from
 tracing_buffers_splice_read
References: <20121129012340.602023062@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Remove-unnecessary-WARN_ONCE-s-from-tracing_.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Dave Jones <davej@redhat.com>

WARN shouldn't be used as a means of communicating failure to a userspace p=
rogrammer.

Link: http://lkml.kernel.org/r/20120725153908.GA25203@redhat.com

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 64ad9bc..5bc3590 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4275,13 +4275,11 @@ tracing_buffers_splice_read(struct file *file, loff=
_t *ppos,
 		return -ENOMEM;
=20
 	if (*ppos & (PAGE_SIZE - 1)) {
-		WARN_ONCE(1, "Ftrace: previous read must page-align\n");
 		ret =3D -EINVAL;
 		goto out;
 	}
=20
 	if (len & (PAGE_SIZE - 1)) {
-		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");
 		if (len < PAGE_SIZE) {
 			ret =3D -EINVAL;
 			goto out;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQtrlPAAoJEOdOSU1xswtMeJkH/RIU3730NKBlUq9lP5sj3tYO
SQ90DiRHQbkRVOpyVGhAC/y0dj4JQGz/cLjG6lQKX8huj3I3o/LVd9f8Ne1mCQpl
GpKDI+Ctc3pkdZhqExBI7mBtNyepU86Q7WDRtcNxjOfFBneVREeRwiSPFXNKyLU0
awitommz1/X3kbxo8EJzqGqLm096oQf/DOdLuDQI4/02ZvABp3aKI0hRVJKxWuuf
8oSIuiWu21VwmL99MBJBgnH3fF701MPZYjWPdM7xS6RnlGKXAuGnNAPDbkpMYd23
iGTHewNGfwK4k3Rz7OOluge1WCy+tFlRsP4mO4j0r/8+DWjpqn9ItY8+m2+K1W4=
=0uRv
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
