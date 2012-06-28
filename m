Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab2F1XSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 19:18:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2F1XSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 19:18:08 -0400
X-Authority-Analysis: v=2.0 cv=AtpsLZBP c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=TDDBjKH2d2oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=LtALj2ppLF2EQDAHnqMA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=RcyAP5jDCDXpr0xD-KYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120628231806.746912769@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 28 Jun 2012 19:16:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/4] tracing/selftest: Add a WARN_ON() if a tracer test fails
References: <20120628231625.869980334@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-selftest-Add-a-WARN_ON-if-a-tracer-test-fail.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Add a WARN_ON() output on test failures so that they are easier to detect
in automated tests. Although, the WARN_ON() will not print if the test
causes the system to crash, obviously.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 49249c2..748f640 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -830,6 +830,8 @@ int register_tracer(struct tracer *type)
 		current_trace =3D saved_tracer;
 		if (ret) {
 			printk(KERN_CONT "FAILED!\n");
+			/* Add the warning after printing 'FAILED' */
+			WARN_ON(1);
 			goto out;
 		}
 		/* Only reset on passing, to avoid touching corrupted buffers */
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7OYuAAoJEIy3vGnGbaoAxm0QANs9Y6zXQR4/cELkYdIFE47G
Ok27D+38fz8NQ4M+MProtzHUhkksmJbbnKuml3WWo+a0DHhTazFlS6vzw1GJM+TV
ZftnKXSEyc9oe6wkFsmf1w4nKuVq/BSw3Tyu5BtkgxCUe/2+zMSZSiJsAs67l3Vr
exnUghpOlP3lA/ps8AjIYkfiKBKsnTQYI608HlAZYunI/ylXySaSWz0mEuLBzD7K
UQ9/Nkoe3BzIPdNrQiK7AA+h7PX4HMLiRlL4PaK7bMZUjAFTPadVr9eUjJveIM4y
vVYhjNvLTOIU/PqStFEaHkNNHhe3W3GJ/8jBn80Ax6DawbZ3UfZKaM1FIF69L9Rx
AX1G8jTFYeOr3PtGXcBFekbCJYdwQ+nhksJ6XvyViJ+TbshlEmQJqbh1JpI5v63a
/+srrl9YCbOmkkLQfaQ4GcdoUthQbHBE5E4DnSGSuuomR0enjiIiGnoG5IJztjFe
n/4hbxiy5wg64G6O026jhCymUmlRuzlAOTSrSODc+mzujFlvZlSQRn5dQl3/u03L
gKO7SA1jJxH9kDnnNy0Dnh+UtLugzfvZ8GwOcZGQdUJcpo6F1+HSHlEENxoEp1mn
W2p2KNEyY1ad2vIM+yzBUZmWVoT8h2I853DRcyWU34wNDnhyhYoIzkXI1FM4+xUM
Y+N8tBPhrMeVUZ/5P0gd
=8g37
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
