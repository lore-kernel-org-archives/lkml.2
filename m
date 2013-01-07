Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3AGOEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 09:04:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10865 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3AGODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 09:03:34 -0500
X-Authority-Analysis: v=2.0 cv=IsacgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=bUb7YIlAPwoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=jGLZSl7hCa8A:10 a=20KFwNOVAAAA:8 a=IpekacLhIKQ0iGG4xqEA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ooVrqe25leRlORKlfzcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130107140333.764312682@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 07 Jan 2013 09:02:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 2/2 v2] tracing: Fix sparse warning with is_signed_type() macro
References: <20130107140232.460273619@goodmis.org>
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

iQEcBAABAgAGBQJQ6tW1AAoJEOdOSU1xswtMmyUIAMQElV7CVApwuUj1mZtlBb9+
cVJ31WRmjcmniH3A+Pr6r3Zw/Vffv/Gi4PvA2om5j43HUo1QDTtZu3pmtlOJmQOa
40s/2tmxQOVw5x0vTzZ7CpJOCpwMGVFduaNnP6swp8JalVgXeSCTFamGQdG/OOFs
HwL345wN1BmpnzHiEz0sOEOJiaZ9ShKNSL6l/bCE565TZ2QXCCvFyWzatZduJZxw
AfmMvbuUaN/yBgK+iUCGIardgyVpNwVXxoVoZjezVhFPnkDAB55C44lcGbt/rxm3
MwEFfIsiiDpmDMbg6xVlM1Q9/w+v5+Oaa/3C5WJwNoHGUF/tETEzXEcFgui4RNg=
=yhRy
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
