Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab1LFBm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:42:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827Ab1LFBm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:42:27 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=L9sZ2hmJvwgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=6rqHouBjAAAA:8 a=meVymXHHAAAA:8 a=99Y-uqNR8mB0EZV1OAoA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=TAmEwCHjoHMA:10 a=jeBq3FmKZ4MA:10 a=tPmz-VCQcDQgGgvFN-MA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111206014224.614543275@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 20:41:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Andrew Vagin <avagin@openvz.org>
Subject: [PATCH 5/6] perf: Fix parsing of __print_flags() in TP_printk()
References: <20111206014110.079874115@goodmis.org>
Content-Disposition: inline; filename=0005-perf-Fix-parsing-of-__print_flags-in-TP_printk.patch
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
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3XMAAAoJEIy3vGnGbaoA2mgP/2BUefc3p6juCSoGEYdkWTLJ
CDrhbNFP21+qP/qSbfz6boQEgztApLU7grj+oVhOJqJnxRSAo9b1cOLqJVXfCLcc
GttcxkOrvxiQxKeyOA5Nr1ezeFK4lSrkOReTT6rDQaq6kKZKmaVZEUn2fYItv0m0
BkPaLb7fiQvzVG7ql0C1mPF5hFtC2SxLUBnJTAxgyvM5Rl8ygbl3Ymxv0jJNle2Q
KhSXaUQ+ePtlcgdQVh6aoAKdGbywfCeN//q4ZgPLWdRCh0oQ1p/L7tHHBMjF1b5X
WQYa/xPXN/fn5TJDmqggehWsgOCz1S8H6u9cAHrz/O0QL05u6gcQAYMeDxUaIlU6
R4J+GQCaRIxBYXNNwqkfJRJBvlfT5IpcNzxBlxtPStbhgI3m/AHEyk/8YyuZO7t7
RwK1LJbr2mDYpEgGbRtJx+ynmE5ALPmKd4IuyGe/EG2o55veg6R38V14hT/vJbeI
XW3hbEfv6jE4j+1ISQuPiqWKfJ7l+hzJRrC0gnUj6hb/v4u2AMocvH+NNjueY3nx
EFOIUhORAlcZi28//2kjUSB6jdd10xJM6dNg1OSM6QS1nvb5qx4trVyVI2ZSE5Ae
NV59RF1PWwSBlR7ZIA/9Eyj+9/MbWw600M7F95zNGUqgjITPJstJ3UDjLUJ3eRfu
5ae/m7iv/FyiG5uDx05q
=LhxY
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
