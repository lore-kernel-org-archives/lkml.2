Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2FOBEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:04:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6641 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2FOBDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:03:39 -0400
X-Authority-Analysis: v=2.0 cv=T6AOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=QlFg8caRMX4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=8mR9c8h7AAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=zd2uoN0lAAAA:8 a=qAMg_Q32op5xTYuzupIA:9 a=QEXdDO2ut3YA:10 a=LdTqRQehjdcA:10 a=jEp0ucaQiEUA:10 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=lFmHPrPKd9m4kTlzslcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120615010337.333269218@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 14 Jun 2012 21:01:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        John Kacur <jkacur@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/3] ftrace: Remove a superfluous check
References: <20120615010123.722084844@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Remove-a-superfluous-check.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Borislav Petkov <bp@amd64.org>

register_ftrace_function() checks ftrace_disabled and calls
__register_ftrace_function which does it again.

Drop the first check and add the unlikely hint to the second one. Also,
drop the label as John correctly notices.

No functional change.

Link: http://lkml.kernel.org/r/20120329171140.GE6409@aftab

Cc: Borislav Petkov <bp@amd64.org>
Cc: John Kacur <jkacur@redhat.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a008663..b4f20fb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -312,7 +312,7 @@ static int remove_ftrace_list_ops(struct ftrace_ops **l=
ist,
=20
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
-	if (ftrace_disabled)
+	if (unlikely(ftrace_disabled))
 		return -ENODEV;
=20
 	if (FTRACE_WARN_ON(ops =3D=3D &global_ops))
@@ -4299,16 +4299,12 @@ int register_ftrace_function(struct ftrace_ops *ops)
=20
 	mutex_lock(&ftrace_lock);
=20
-	if (unlikely(ftrace_disabled))
-		goto out_unlock;
-
 	ret =3D __register_ftrace_function(ops);
 	if (!ret)
 		ret =3D ftrace_startup(ops, 0);
=20
-
- out_unlock:
 	mutex_unlock(&ftrace_lock);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_ftrace_function);
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP2onpAAoJEIy3vGnGbaoAbsYP/3KfEtX7/MAgxoHZ3MxyisJT
ZS0IZIyxyo+ezIqXfY3kBOQQdneCefZZu9dEqqB0hGKGDnlxUKhViQ+JdMD9Uo8k
4J1n9f3e4PjwwBGjB/+i/8vzpqbHgsdn2hel5WneNPPSs46hPgiI10rsFhDGQ3Hz
1qCjRh+2z7lVVQi11/ruCFRNn0EDF4rmODWAHC9Qj+CqyLMraOdns51gcZznCZu/
gDuzr/MgQIZLSqejiiHPpAS0MynFj2tlT2ZX8Hg0jNc7daWf62px3wgRMWuGODLc
Lipvb0+G+zHFtbxZMdP+g9nrvKDeTGN+V9EvQLe4FKzPXHVBOOd29u8P3UWk6vRO
2yLR9YZiHqw4w4BfT3Ew/aAVWjLl+UhecvzcZyGLfs7P/ov3ifMnOGkcjbZ4H1Tk
mjAWsQQFs+An2c0WmHkg/Ff5eu2zQAvzWM2c5wNDmYeIaqUmXTweqeukR9qYc377
P7lmTawevrAdTXII+uieNgl4PE8L7p4hFsINIUrV01khi+hmJ2oLGchUJzDqVqfS
+V3nvLJO3NtZKRgTXr4g3zPsvVsFeEgMVPEn8HUN3iqnkOXu1eY5IcNdeSbHFsaR
SsiR7kSW9naoNMy6WhOPC2MuPmamjL1HGx/DNdAGd1m/FS3zhbkqHFYFrp5S3TZH
yYs3ekOgZPvJ373uo2x7
=hjOv
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
