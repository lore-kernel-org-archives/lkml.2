Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2IHL6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:58:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab2IHL4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:56:42 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=in5UxLDv2m0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=vbAMjfb65vIA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=v8M3vJg45WFjYo1xzM4A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=CwMIyUwNGw08THadDrEA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120908115640.286137505@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 08 Sep 2012 07:55:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 2/7] tracing: Skip printing "OK" if failed to disable event
References: <20120908115515.211175517@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Skip-printing-OK-if-failed-to-disable-event.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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

iQIcBAABAgAGBQJQSzJ4AAoJEIy3vGnGbaoAGCUQAJ0B2App0UJIugzs+LDgzMxl
LxU8F1NjrjFeVrXQygy2/5x4yJb4uoxs/KbC6vSsg/sWO3e/obzem6JFDk2nVx62
BH1pGiVi0YFIzeJsDluxhorJpOB7/KJgbVnTN0ocmOUVp6z48Clr8A6gJQwIuNoa
MQFhaILQdm5mNrchMpeAGn8d2kdnMZ600+Ieb3xtG3bMgTiVIaQfUXXrKgya5qIX
q5sr1U7XtWf9Cu35vU9LDnkZN66qEsUl/Emua5cGzb9BT3rWf4rTtmfYuIKjYsE8
vjFnv5oE2QUF+uTYwTg0/dtNFkfaCFRTIN27xZKV/opKpwmyZ8ZS/RSrCMsSYiVK
bbwhDrpPUUGWbFb9/VQUqLPtI/MXtX6sLM55+DayHOCm9eN72kAL9NM2cJg5XFM4
boEyUn08Iy0QI/t1ZD6tSybjbuZmTcj1KDR26Pv0lRPeT/cshXh58/iZ1PnquaD5
1Bp42y/D6mvWH3HKEk8mF6ewbZlYgv8jEL5RZn1/jVncEcIzTzsiWbtJNh4Aq9Do
8WWKZKAdybPcFX8m0P0hG11MGZoyYMlcA9yEtrfuXFN2bA04jH7Hb95N6YS8E+vI
RVElUirl0M0yqk8fp0NgI1+PfTk4PckB2Hpz+XUVRvLtYlXldUoX+PXJWYy+EXb6
1N1dDxy8cbQFJch2wnVK
=N0BU
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
