Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2GUCWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 22:22:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28689 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2GUCVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 22:21:13 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=afs0JRACn38A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=GhwerxCL0HRgUY9Y1SwA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=8c6R0lurrQDSuJhA9E8A:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120721022111.667640915@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 20 Jul 2012 22:20:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 17/19] ftrace: Make ftrace_location() a nop on !DYNAMIC_FTRACE
References: <20120721021943.274162381@goodmis.org>
Content-Disposition: inline; filename=0017-ftrace-Make-ftrace_location-a-nop-on-DYNAMIC_FTRACE.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When CONFIG_DYNAMIC_FTRACE is not set, ftrace_location() is not defined.
If a user (like kprobes) references this function, it will break
the compile when CONFIG_DYNAMIC_FTRACE is not set.

Add ftrace_location() as a nop (return 0) when DYNAMIC_FTRACE
is not defined.

Link: http://lkml.kernel.org/r/20120612225426.961092717@goodmis.org

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 3e71112..a52f2f4 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -520,7 +520,7 @@ extern int skip_trace(unsigned long ip);
=20
 extern void ftrace_disable_daemon(void);
 extern void ftrace_enable_daemon(void);
-#else
+#else /* CONFIG_DYNAMIC_FTRACE */
 static inline int skip_trace(unsigned long ip) { return 0; }
 static inline int ftrace_force_update(void) { return 0; }
 static inline void ftrace_disable_daemon(void) { }
@@ -538,6 +538,10 @@ static inline int ftrace_text_reserved(void *start, vo=
id *end)
 {
 	return 0;
 }
+static inline unsigned long ftrace_location(unsigned long ip)
+{
+	return 0;
+}
=20
 /*
  * Again users of functions that have ftrace_ops may not
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQChIXAAoJEIy3vGnGbaoAq2wQAOqi+NATCxEUuyZDD3LCEU4q
eUUjiYye0GvUxFXZWJ9oSi1yURMpwfSfazTi/ygHNe71ONwO1xSqw/gkQEdgbiTh
YJEjQr6VrgL+0/mxGp8Fr4ddcm3ZBwGhlr6obIiX6pvGeBN6EhD48pdZeZpUE0IL
8ED1PbX9j1X22AIG+1FW6If6jO++CjEUwYmCGYN52zAowWdQoUux2RpHO0JyyOaj
up19cRlmYmAQBOHnrS7zlaTqyuiIfZMt/qhZrJnetbdLjLap0eX3W8cTK8xK/Yeh
/lfy3nb/qIWlr7j3iDbUMbs6UaZSK2nZxZ6tf+L+jGsOyqR72IGzSER0ylkB1YMx
LMq9mzV5qAH5awRyCVJgOIB0KJ67yH0m5gX9igU+iHOpZvar9KxaMYe+aEuveoZT
LytOJ8Wd9bMF2n+WW/3f05QmMlZgBvg0xvO/96lH5h1tpLn7Ep7fI3YHT8DMD3Fp
ENDl4GQLUYPMGgUNqG2EHmqeD/3rvv+zHEL5eJHfctyBcNZ+GkFsSbgM4C7VkEcG
qUpan78ZGAOtt3SCnm0bv+CwsEpoSBTIiVN3rI+0e4jjQYOd7nE59tKC6dq6W5oF
fXMS+LzuIpSow8+dUetEDHywz6oyPylO3gKXx8TwhcxZc0Xkbbr7kXzWFQl0FTix
+1hmV68JgP5zNB339w45
=+/D3
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
