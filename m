Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762157Ab2KBNfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 09:35:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab2KBNfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 09:35:00 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=---cRhVtk34A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=McLntpi8likA:10 a=VwQbUJbxAAAA:8 a=RsALlvvzhG05sFfqJh8A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=1SLLj1mNlTysNBE3:21 a=jWbLll6QwxU2dmjD:21 a=SM5xXyzpw0csELXsbGgA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121102133458.020968291@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 02 Nov 2012 09:32:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Walter <sahne@0x90.at>
Subject: [PATCH 01/22] tracing: Replace strict_strto* with kstrto*
References: <20121102133251.998500247@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Replace-strict_strto-with-kstrto.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Daniel Walter <sahne@0x90.at>

 * remove old string conversions with kstrto*

Link: http://lkml.kernel.org/r/20120926200838.GC1244@0x90.at

Signed-off-by: Daniel Walter <sahne@0x90.at>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c              |    2 +-
 kernel/trace/trace.c               |    2 +-
 kernel/trace/trace_events_filter.c |    4 ++--
 kernel/trace/trace_functions.c     |    2 +-
 kernel/trace/trace_kprobe.c        |    2 +-
 kernel/trace/trace_probe.c         |   14 +++++++-------
 kernel/trace/trace_uprobe.c        |    2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9dcf15d..60ad606 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4381,7 +4381,7 @@ ftrace_pid_write(struct file *filp, const char __user=
 *ubuf,
 	if (strlen(tmp) =3D=3D 0)
 		return 1;
=20
-	ret =3D strict_strtol(tmp, 10, &val);
+	ret =3D kstrtol(tmp, 10, &val);
 	if (ret < 0)
 		return ret;
=20
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 31e4f55..f6928ed 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -431,7 +431,7 @@ static int __init set_tracing_thresh(char *str)
=20
 	if (!str)
 		return 0;
-	ret =3D strict_strtoul(str, 0, &threshold);
+	ret =3D kstrtoul(str, 0, &threshold);
 	if (ret < 0)
 		return 0;
 	tracing_thresh =3D threshold * 1000;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events=
_filter.c
index c154797..e5b0ca8 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1000,9 +1000,9 @@ static int init_pred(struct filter_parse_state *ps,
 		}
 	} else {
 		if (field->is_signed)
-			ret =3D strict_strtoll(pred->regex.pattern, 0, &val);
+			ret =3D kstrtoll(pred->regex.pattern, 0, &val);
 		else
-			ret =3D strict_strtoull(pred->regex.pattern, 0, &val);
+			ret =3D kstrtoull(pred->regex.pattern, 0, &val);
 		if (ret) {
 			parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
 			return -EINVAL;
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 507a7a9..618dcf8 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -366,7 +366,7 @@ ftrace_trace_onoff_callback(struct ftrace_hash *hash,
 	 * We use the callback data field (which is a pointer)
 	 * as our counter.
 	 */
-	ret =3D strict_strtoul(number, 0, (unsigned long *)&count);
+	ret =3D kstrtoul(number, 0, (unsigned long *)&count);
 	if (ret)
 		return ret;
=20
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1a21170..5a3c533 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -444,7 +444,7 @@ static int create_trace_probe(int argc, char **argv)
 			return -EINVAL;
 		}
 		/* an address specified */
-		ret =3D strict_strtoul(&argv[1][0], 0, (unsigned long *)&addr);
+		ret =3D kstrtoul(&argv[1][0], 0, (unsigned long *)&addr);
 		if (ret) {
 			pr_info("Failed to parse address.\n");
 			return ret;
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index daa9980..412e959 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -441,7 +441,7 @@ static const struct fetch_type *find_fetch_type(const c=
har *type)
 			goto fail;
=20
 		type++;
-		if (strict_strtoul(type, 0, &bs))
+		if (kstrtoul(type, 0, &bs))
 			goto fail;
=20
 		switch (bs) {
@@ -501,8 +501,8 @@ int traceprobe_split_symbol_offset(char *symbol, unsign=
ed long *offset)
=20
 	tmp =3D strchr(symbol, '+');
 	if (tmp) {
-		/* skip sign because strict_strtol doesn't accept '+' */
-		ret =3D strict_strtoul(tmp + 1, 0, offset);
+		/* skip sign because kstrtoul doesn't accept '+' */
+		ret =3D kstrtoul(tmp + 1, 0, offset);
 		if (ret)
 			return ret;
=20
@@ -533,7 +533,7 @@ static int parse_probe_vars(char *arg, const struct fet=
ch_type *t,
 			else
 				ret =3D -EINVAL;
 		} else if (isdigit(arg[5])) {
-			ret =3D strict_strtoul(arg + 5, 10, &param);
+			ret =3D kstrtoul(arg + 5, 10, &param);
 			if (ret || param > PARAM_MAX_STACK)
 				ret =3D -EINVAL;
 			else {
@@ -579,7 +579,7 @@ static int parse_probe_arg(char *arg, const struct fetc=
h_type *t,
=20
 	case '@':	/* memory or symbol */
 		if (isdigit(arg[1])) {
-			ret =3D strict_strtoul(arg + 1, 0, &param);
+			ret =3D kstrtoul(arg + 1, 0, &param);
 			if (ret)
 				break;
=20
@@ -597,14 +597,14 @@ static int parse_probe_arg(char *arg, const struct fe=
tch_type *t,
 		break;
=20
 	case '+':	/* deref memory */
-		arg++;	/* Skip '+', because strict_strtol() rejects it. */
+		arg++;	/* Skip '+', because kstrtol() rejects it. */
 	case '-':
 		tmp =3D strchr(arg, '(');
 		if (!tmp)
 			break;
=20
 		*tmp =3D '\0';
-		ret =3D strict_strtol(arg, 0, &offset);
+		ret =3D kstrtol(arg, 0, &offset);
=20
 		if (ret)
 			break;
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 03003cd..4ff9ca4 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -252,7 +252,7 @@ static int create_trace_uprobe(int argc, char **argv)
 	if (ret)
 		goto fail_address_parse;
=20
-	ret =3D strict_strtoul(arg, 0, &offset);
+	ret =3D kstrtoul(arg, 0, &offset);
 	if (ret)
 		goto fail_address_parse;
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQk8wCAAoJEOdOSU1xswtMcAMH/i/nIiBNOI9LNjd3LqQmxabb
ox/ZOQqyqYFZOvDA74cbx7kp5sOIa1xEXxcmICXsW7GsdSPLU7TklzjB0KNMbZPF
jNU6M3P8jL75L1imGeMV8ksApD1Ljan1LIY8BGUuCNI8m0LRPoKlEMR/02L/fJ/K
DyX4aKB8KgP0FncrG6ibxir9ObhNpn297D9O0QiKXal1b9xFwesbEkQAy7NvmUbH
eN/Dy2ze/FEjrHq28aUNxl9mXc5MLMAarfxWDBAQXkGZSWKM1SPrGr8BthBYk+bO
PhijA2yZ3L6orWiXy5ef//xiboY4PCdzFwjH0jSCHLbyCbzK4PXWWlfl0o2v7+g=
=oinH
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
