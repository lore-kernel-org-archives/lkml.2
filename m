Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab2INDEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:04:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25278 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab2INDCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:02:34 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zSPPFXKcxAkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tcaSeXWVSlUA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=v8M3vJg45WFjYo1xzM4A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=awIrTtWpfDs902Y2jAoA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120914030232.120775554@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 13 Sep 2012 23:00:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 1/6 v2] tracing: Skip printing "OK" if failed to disable event
References: <20120914030012.315074731@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Skip-printing-OK-if-failed-to-disable-event.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Yuanhan Liu <yuanhan.liu@linux.intel.com>

No acutal case found. But logically, we should skip "OK" in case any
error met.

Link: http://lkml.kernel.org/r/1346051625-25231-1-git-send-email-yuanhan.li=
u@linux.intel.com

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 6825d83..bbb0e63 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1646,9 +1646,11 @@ static __init void event_trace_self_tests(void)
 		event_test_stuff();
=20
 		ret =3D __ftrace_set_clr_event(NULL, system->name, NULL, 0);
-		if (WARN_ON_ONCE(ret))
+		if (WARN_ON_ONCE(ret)) {
 			pr_warning("error disabling system %s\n",
 				   system->name);
+			continue;
+		}
=20
 		pr_cont("OK\n");
 	}
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQUp5IAAoJEOdOSU1xswtMzbAH+QF+maeEliuNdZ/Jrozs3lNr
1+JkRLZXiWnurp3op7KoriSgwqQsjv5GtCu5XragFljnZt4K0US/AW5E0vcF5EvL
f43Vp3+35/0Ioo189VzqJdcM1+Geit/MlRJuoQVPP/QhMHi6okzf1GJbubr9FlEa
i38gjOGJAsIB1ET3dIDnH6zd8UnnuZNDqPzX9RszKtJp8c6SPuDxFkKgzU4/XL+k
28rUJ0tQEuPuzLLN7qUaK6CvdOxGgzKpxHL2YPGXcn/OXmaEZbKj1TJvZOlsJkVZ
rVj0DtLdcHyxWj87UgVz9XJznLQ+LITwUHsXzKs604pqnMRXyCBI10KruD8kjQk=
=GYZ0
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
