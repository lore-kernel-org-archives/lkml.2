Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934774Ab2KBSQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:16:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933602Ab2KBSOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:14:35 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=LTVknAiBGWoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PsjSUhCDCwAA:10 a=VwQbUJbxAAAA:8 a=yJ_xBFoeKshuyOfMLuQA:9 a=QEXdDO2ut3YA:10 a=tcl5Gpyx7pQA:10 a=jeBq3FmKZ4MA:10 a=DdeVZVigcTp2WaYiCrcA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102181431.775441110@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 14:13:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michal Hocko <mhocko@suse.cz>
Subject: [PATCH 11/19] linux/kernel.h: Remove duplicate trace_printk declaration
References: <20121102181331.513782854@goodmis.org>
Content-Disposition: inline; filename=0011-linux-kernel.h-Remove-duplicate-trace_printk-declara.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Michal Hocko <mhocko@suse.cz>

!CONFIG_TRACING both declares and defines (empty) trace_printk.
The first one is not redundant so it can be removed.

Link: http://lkml.kernel.org/r/1351172511-18125-1-git-send-email-mhocko@sus=
e.cz

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/kernel.h |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index a123b13..7785d5d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -527,9 +527,6 @@ __ftrace_vprintk(unsigned long ip, const char *fmt, va_=
list ap);
=20
 extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
 #else
-static inline __printf(1, 2)
-int trace_printk(const char *fmt, ...);
-
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
@@ -539,8 +536,8 @@ static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }
 static inline int tracing_is_on(void) { return 0; }
=20
-static inline int
-trace_printk(const char *fmt, ...)
+static inline __printf(1, 2)
+int trace_printk(const char *fmt, ...)
 {
 	return 0;
 }
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQlA2HAAoJEOdOSU1xswtM+GwH/R7a44YcSAWU/mzu8t8drhlb
J1gahcDEa+m9z9oV4yM5Xsu4/OIi/bhLoAf9m+sX6bG/XiUrBjKDAMfZ7v1zlvqj
I4fx112QW5JlMSrvVpSX3Ew2D8rK74XuYtr7/gPkLb3s6WDwyiNbTW0f03LWMLvS
m+NlAv/10bV6GC2rejk4lTRFKU5WQsW9Zb7P/HiI2eNoBU9g33Tiqb3X8aHk7wbN
tJuBn/LLSefTRAefSZ/L1AI39+Vb+1eaC8OVgkanRrmFL4qAIRVU1xAhpF9o5LgH
FQ0HCfv4GaUdoiA8Ar6CEOmTjypBpGP3uTepgbSsUX2AoqduySzJYuwQ2Z3j94Y=
=03+t
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
