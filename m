Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab1KHBcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:32:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62903 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab1KHBak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:30:40 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=jf4Kn9iwO44A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=meNnNuiGNmHCcrUN84QA:9 a=gIleUtFqVcTfsrRnI_0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=BMxd8oOfxGA8dQDyQvcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111108013038.842359366@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:29:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 06/10] ftrace: Remove force undef config value left for testing
References: <20111108012939.372220547@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-Remove-force-undef-config-value-left-for-test.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

A forced undef of a config value was used for testing and was
accidently left in during the final commit. This causes x86 to
run slower than needed while running function tracing as well
as causes the function graph selftest to fail when DYNMAIC_FTRACE
is not set. This is because the code in MCOUNT expects the ftrace
code to be processed with the config value set that happened to
be forced not set.

The forced config option was left in by:
    commit 6331c28c962561aee59e5a493b7556a4bb585957
    ftrace: Fix dynamic selftest failure on some archs

Link: http://lkml.kernel.org/r/20111102150255.GA6973@debian

Cc: stable@vger.kernel.org
Reported-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 077d853..0fcc6ca 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -151,7 +151,6 @@ void clear_ftrace_function(void)
 	ftrace_pid_function =3D ftrace_stub;
 }
=20
-#undef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 /*
  * For those archs that do not test ftrace_trace_stop in their
--=20
1.7.7



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIbBAABAgAGBQJOuIY/AAoJEIy3vGnGbaoA+agP91TjyYE2KZhgSJxKikS9ysPo
WJrsfB7b5i6ycWEbaoltjZwWYvp7z6IPN1sjtRVZfDlUqog4d07VgPzUqnKEmV3m
idr5oMT+Ip8StbkfjXxhNtNk9eU+KbAYuB/izdagH1wXo6tz/ApDpku8nqXuWmm2
mbe1qLOpVJ/5FuQj+r2dSG2yVeZRsMaJPp9+l5NBb/qeAk92MvC76zJAtt5ZrKoP
BQTTpnQTM3zXgdUdms6tNPrUKUHUGplUoOIXH3wgZ9xYlp6L+Qy6m4JMo/yTpFNz
diiYrs3RJwHziEniiG7gHIPdkuyb/Jdoqop2y80SYA8TYrBBpYostGWgdkmIdWtm
BkyTTwC3dIKXZZ7pKyI6tepNXEcLWeA9GyRKjXvdiyBzWPcKngdTYtuVaoOqF859
5BpqZhpKTzaserPqw/RU7t6Pt4u7PM9RvfrR8mPMnjw9WblDAHHsI6/kT8efh3Jy
TFpU8stJwr3lcmUY7I33qzjDxwNkFdCl+S6Jcyj198mI0gCDcCKZnS/lzF1nOtfE
Vdh3lqGcRt+rpmbYdsaqzNUzwsL+7ebuPS6J3lWuCJxsL3plJZW2QZBsLhjdxNq6
4+7wzvYsMOAwWgeYVyIwYFB/VBuFHfKdVUbCMTREQDhhNQJ0HC4SDlNni2i78NO9
LuZhNakFRo9bDfBvGxQ=
=Wuuz
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
