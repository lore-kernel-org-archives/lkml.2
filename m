Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1KHBbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:31:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45548 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab1KHBal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:30:41 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=gh6EWX_rLiIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=6rqHouBjAAAA:8 a=meVymXHHAAAA:8 a=q3C-Bu-GGNQZRJV1jMMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=TAmEwCHjoHMA:10 a=jeBq3FmKZ4MA:10 a=KsbVF3TZrv8SeKRURZ0A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111108013039.749221110@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:29:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 08/10] perf: Fix parsing of __print_flags() in TP_printk()
References: <20111108012939.372220547@goodmis.org>
Content-Disposition: inline; filename=0008-perf-Fix-parsing-of-__print_flags-in-TP_printk.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

A update is made to the sched:sched_switch event that adds some
logic to the first parameter of the __print_flags() that shows the
state of tasks. This change cause perf to fail parsing the flags.

A simple fix is needed to have the parser be able to process ops
within the argument.

Cc: stable@vger.kernel.org
Reported-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/trace-event-parse.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-ev=
ent-parse.c
index 0a7ed5b..6c164dc 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1537,6 +1537,8 @@ process_flags(struct event *event, struct print_arg *=
arg, char **tok)
 	field =3D malloc_or_die(sizeof(*field));
=20
 	type =3D process_arg(event, field, &token);
+	while (type =3D=3D EVENT_OP)
+		type =3D process_op(event, field, &token);
 	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free;
=20
--=20
1.7.7



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOuIY/AAoJEIy3vGnGbaoAwCkP/3hlkHCOGAQU5xDbA27pgldN
XeE/CvUiqYO139vq709XivKUBDlrVCJ9jv6B1Waxd1spCKNrP6k2U/ykgsXWqAyZ
U+9M/eazHR39jBpzmKQ2QMI+5NIMhP0b3rc3qKXkfqv57HsmlD6s+zX7ta7Ssxz8
FAzr3hNvu2cJDn3Fjbs90pk9VKew5I/Qo2VJJ2wlqO0RB+EtxwNekdiphkhFFE9t
CJ1uBv2G+T4dxQ0u7fhrIxHEUDMoVZonjwUEhbpsgK3hUmJLCggwR/F2AxYM8Gaw
4T5KmaR7JfUCf8jh8InYUM8YOixv+s21u0BBHHeCzgvim0Zdjm/QPJiCHYRJ5M+4
bpfygDYUN3h19p0uy9uSDuTLh4arA+bGm+bKFX6J/sceXaK4abL9b25/ui9QNQj7
/zxFcOYWvoocDcvYzY5J/kY/ZkBnVSfuFnqoqGhHlx4JLGNMUWjQSNNlrpejMQw7
QcqiG0cye5DmyiWHanFnl4MWCvTmQyqjAb/HvDHzcK0cKLKhID83RHDYHoEMfxbE
vh0qgJ871EdIQgklC4DmL+aJeyFwR97O0FQNS0vfRC9DL26y51XD4u89ATEbU9Sy
N+6inEUNw/9U3Te6StoJMWexFlHMoBPGpVQJEPOXd17wVRaGGVljbRnd4rx95fCs
IP8jDwgSo7lXVSPsHMDG
=rR3G
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
