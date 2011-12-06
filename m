Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab1LFBnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:43:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55290 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab1LFBmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:42:23 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=UU2JxhQS6l0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=meNnNuiGNmHCcrUN84QA:9 a=gIleUtFqVcTfsrRnI_0A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=3YCOppZcYubRXGmWz5oA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111206014221.007066295@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 20:41:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 3/6] ftrace: Remove force undef config value left for testing
References: <20111206014110.079874115@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Remove-force-undef-config-value-left-for-test.patch
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
index 900b409..1276b3c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -152,7 +152,6 @@ void clear_ftrace_function(void)
 	ftrace_pid_function =3D ftrace_stub;
 }
=20
-#undef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 #ifndef CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST
 /*
  * For those archs that do not test ftrace_trace_stop in their
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3XL9AAoJEIy3vGnGbaoAaboQALR/7jaA6RCNF9o/9Utdx2ux
8snOn/1w4TiO0wp/nkhAyhN1vyP4D+OgTNm98TawPgI0NaiunvbPMBMVPlIiBKRG
rrpj7HDyb9uw44GSNZMFba0V2KvljJ2dyVE77Ba6kwScrSh1xFvTjiZYJ1cRZu+8
6KD99uxz/w8TfEuwEZ/bIHQ1l/EFueOo/KEKzSqnOu3T/Vfx9a2MAzVxjSQTC/gx
g15Gr0yq+VA9db2nv4SvlCeGIXv40pZVEqwodngSoSGChcc7WpRO5OCTzf42zS//
sSNEUunIi+boO51IzitTcY2bbxqTCxteTcmWkh6pqFXMSGcks1SsMc4jpTYkOUCc
HpI7IwjRqx5wH0lG4PqLuK3jq12lluhQ1uqsiWVVs2zZ+YjkptAryBEMRSTASFWW
Bqhmpxht6gLewbZ3FkWGQvppZzZbFS4f4FHMKnReSE4OpgbiNmUYOWpzHm+9g8QR
YU0zXJ6bDLYT34VT0tJm8LKUG8+M7NJtUWJJCJl1I1YKf1JmhFUN1wAf+gkHgU/9
O1KrTI3otAPB+YXcoPUfdRJG6R6QxiSGsIaI2Lh0vEkN4wjtlkCiU+htPDUUFQps
oR9U+ax0UNNh75LpP8lTusFgyGxdqEFTMbNEZk72DrPChe4yqTin/ANoRnElfZ9r
/Wx/YyH9XbNt0GELQV2o
=iZNE
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
