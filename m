Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab2HWSRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:17:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6349 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab2HWSRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:17:07 -0400
X-Authority-Analysis: v=2.0 cv=cpwZYiEi c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=haT1h0IRoxkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=1kIqGQobiTYA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=SyI_GHdlAAAA:8 a=WfulkdPnAAAA:8 a=8koy8i6ZauEDTfhOJWcA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=UQxMgyrMzRwA:10 a=LI9Vle30uBYA:10 a=l29vjEC0CZ8A:10 a=rg0ZtJ767c2Df9aNeAsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120823181659.148123912@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 23 Aug 2012 14:15:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        John Reiser <jreiser@bitwagon.com>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/4] ftrace: Make recordmcount.c handle __fentry__
References: <20120823181537.510961094@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Make-recordmcount.c-handle-__fentry__.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

With gcc 4.6.0 the -mfentry feature places the function profiling
call at the start of the function. When this is used, the call is
to __fentry__ and not mcount.

Change recordmcount.c to record both callers to __fentry__ and
mcount.

Link: http://lkml.kernel.org/r/20120807194058.990674363@goodmis.org

Acked-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: John Reiser <jreiser@bitwagon.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 54e35c1..9d1421e 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -261,11 +261,13 @@ static unsigned get_mcountsym(Elf_Sym const *const sy=
m0,
 		&sym0[Elf_r_sym(relp)];
 	char const *symname =3D &str0[w(symp->st_name)];
 	char const *mcount =3D gpfx =3D=3D '_' ? "_mcount" : "mcount";
+	char const *fentry =3D "__fentry__";
=20
 	if (symname[0] =3D=3D '.')
 		++symname;  /* ppc64 hack */
 	if (strcmp(mcount, symname) =3D=3D 0 ||
-	    (altmcount && strcmp(altmcount, symname) =3D=3D 0))
+	    (altmcount && strcmp(altmcount, symname) =3D=3D 0) ||
+	    (strcmp(fentry, symname) =3D=3D 0))
 		mcountsym =3D Elf_r_sym(relp);
=20
 	return mcountsym;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQNnObAAoJEIy3vGnGbaoA/XQP/1OcHYuK/sHKh6mTMSGqxTmM
Xqe+K+oTfV0W7pFjm6TYFPOg7AKpcHBoFaG4ztgjSRSjkwiLV8IYONG8YvX7QvrF
Scbi4u2DEotS996gyut+Zyg+C5gCmcyccWIWkmjkaOa5CaqwqVsiMwLYaL23e6fw
cG3cG2mKFCJwybaZvlJN0Ci807+BsNiITR89jxAhqqj7p3jRSSjVTwIg6MRAAo9A
IipJxmvqNsfEbjw7Gv2AD9PyTk81q12nAgVLZxJwv4Ny1VHHWjIP/gYsqG0W+BZQ
rcOg0YEH4EtTJ8qEtE3tupqgYpt2LA/xjzsbMiLoZ5WgC/T6NPwmsRy9P9OnVd4u
xitz7P4Vm9wGWEYZ0+YXEpYAwUPvRHP2ZU6gW0OehgjjeTbZtWU0IUnfFa9rQ9Pg
bsOuaWwnSfA9uhRAwz53v/2ntU/7gC2MxDrn1qU6U17CPw7fbgTxUon4qFDYYCDl
GRZnHo2S8zPmgG7D+s6AJ9ej6uTZLXevEtun90z4vRWxXFHAnQAYBuuXDCAMx9IV
hgaEMrCitw69IQ2CvWJzRA3mfPUHWsU2Q/uEtuVdXJL32aqTsvvRyAoCteAf8GC6
sJjnN6stGhxhpvoY1uwXhcQadVN8qkvqj1BOBhUyf+NuVODAW6d6H/QJrRsjo6BO
VJc7uw7+GyT7tlakVt3Z
=dXRt
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
