Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2DYSum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:50:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2926 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab2DYStc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:49:32 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=lQZUv1ZdJY8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=P0lr4AU3AVT9a5ESR-oA:9 a=Hp-3dv5qa5unzalQFzsA:7 a=QEXdDO2ut3YA:10 a=7DSvI1NPTFQA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=qZREqp8D12CGJBEWbj8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120425184930.162289353@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 25 Apr 2012 14:48:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/5] tracing: Remove an unneeded check in trace_seq_buffer()
References: <20120425184830.325105778@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Remove-an-unneeded-check-in-trace_seq_buffer.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Dan Carpenter <dan.carpenter@oracle.com>

memcpy() returns a pointer to "bug".  Hopefully, it's not NULL here or
we would already have Oopsed.

Link: http://lkml.kernel.org/r/20120420063145.GA22649@elgon.mountain

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1ab8e35..bbcde54 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -629,7 +629,6 @@ ssize_t trace_seq_to_user(struct trace_seq *s, char __u=
ser *ubuf, size_t cnt)
 static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t =
cnt)
 {
 	int len;
-	void *ret;
=20
 	if (s->len <=3D s->readpos)
 		return -EBUSY;
@@ -637,9 +636,7 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s,=
 void *buf, size_t cnt)
 	len =3D s->len - s->readpos;
 	if (cnt > len)
 		cnt =3D len;
-	ret =3D memcpy(buf, s->buffer + s->readpos, cnt);
-	if (!ret)
-		return -EFAULT;
+	memcpy(buf, s->buffer + s->readpos, cnt);
=20
 	s->readpos +=3D cnt;
 	return cnt;
--=20
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmEc6AAoJEIy3vGnGbaoAil0QAMw/r55Q+v+WLy2sj9vyvtNq
h/7k2q1IAhOVlXEvJFPB/sQHPfap9xCR72A6PRmgr23UkKaLMw8a05NsuEVWY/Iy
wAQW4xPBteI01q1LUFZx+xFYDJQa9wN7jrcEhl06JEt0aOvCVNgPU3BJFWbsYrjh
DeZ6x4IjrMgMn7qFubSNxwDcsi2EB4f/lCUDSCHNFonCjsIzwcB71ktVFuepzIP5
VHizCN8gEpu5Sf2XBE9XTzZhdRxTqR8fVTjMPX9StOF3eJOB2Ioljh4QQGxtwWSp
NTqMUnshB4RhSCEogk3Tzxt938nOhuWhXewKgtfQ2F9GQknDZvnHtzur8WUpyvzu
iaeXAkZ8QT1YcdEbuGTdjLPwfLMD4m/4jfbVNr/31FmqmYqbEn5RUjiMXgp4ps1g
gY5MWYahPvp8cMybSUECv7pSWPDFAOVg6qgMmQKIaTe9goE3HBJokQQFx71PhEPM
cmA4t5NTcLsKrbB9jzGiiX0BOy13JDqNn/UMErXov61OK4xawQgw8wRfCAqSDrxr
nH3tWGrCmZqZHM+uBGbtUUzIgkShvrbc6SEDFxmZNEQH79Wz73MmQqyKUQvquSMP
jDihmudmlF1haZjAEgXIB6+GUymZmdibzaRwlaLYagAgUrfsCHwR21iY/R5a/T/I
y6lXkxRIXUxXP5wCShu+
=BLrN
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
