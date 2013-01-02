Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3ACAmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 19:42:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24949 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3ACAmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:42:14 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=vBVzjnvoTXgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ox_Hzu_a_IwA:10 a=20KFwNOVAAAA:8 a=IpekacLhIKQ0iGG4xqEA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=VGAgJYzDW5Ves0dBJhYA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130103004212.500173947@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 02 Jan 2013 17:50:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 2/3] tracing: Fix sparse warning with is_signed_type() macro
References: <20130102225035.140076434@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-sparse-warning-with-is_signed_type-macro.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Sparse complains when is_signed_type() is used on a pointer.
This macro is needed for the format output used for ftrace
and perf, to know if a binary field is a signed type or not.
The is_signed_type() macro is used against all fields that are
recorded by events to automate the operation.

The problem sparse has is with the current way is_signed_type()
works:

  ((type)-1 < 0)

If "type" is a poiner, than sparse does not like it being compared
to an integer (zero). The simple fix is to just give zero the
same type. The runtime result stays the same.

Reported-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 642928c..cc87955 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -266,7 +266,7 @@ extern int trace_define_field(struct ftrace_event_call =
*call, const char *type,
 extern int trace_add_event_call(struct ftrace_event_call *call);
 extern void trace_remove_event_call(struct ftrace_event_call *call);
=20
-#define is_signed_type(type)	(((type)(-1)) < 0)
+#define is_signed_type(type)	(((type)(-1)) < (type)0)
=20
 int trace_set_clr_event(const char *system, const char *event, int set);
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQ5NPkAAoJEOdOSU1xswtMGtkH/AzM6c3uUz0cNCRXdxnMyMI1
F31/9r3ft866/yLFLyZrJHnrU+kjU0ku7+iaBeALY+XJuQ7UcFgEMaGpfZYQ+2Q9
KE19rfH9Eh177JY49S6nB85DcBzbw/vUp2KYeleF/Z9v/LcNMMwV7YbMho+WD4Ke
QyR0zsDL4+uY4Rh5wBQZvmcTohWAsXiFZBuMPM6qMULorbEzOxv37h0b7AoWh8/s
pSw1xejKcgV61EfBNj1sSBqJJHxBV7XEu9VMbww328A/YWWahYxQKHDq7qDlZGXo
g26LR9SZomNP1dJeCSfL5ZXIRuipyiG+kWI88ipAva1AvupmTSatPoLUKMMl8Bs=
=rjkU
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
