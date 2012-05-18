Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946070Ab2ERNNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:13:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589Ab2ERNKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:50 -0400
X-Authority-Analysis: v=2.0 cv=OMylLFmB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=Fep0UMWbpGgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=L-xCe1PZlkLG07FEycMA:9 a=B1Do4glftBB25AtcZ7IA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=bJjW3cpPg_2HvmEfSDAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518131048.651237500@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:09:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 05/15] ring-buffer: Reset head page before running self test
References: <20120518130858.392919640@goodmis.org>
Content-Disposition: inline; filename=0005-ring-buffer-Reset-head-page-before-running-self-test.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

When the ring buffer does its consistency test on itself, it
removes the head page, runs the tests, and then adds it back
to what the "head_page" pointer was. But because the head_page
pointer may lack behind the real head page (held by the link
list pointer). The reset may be incorrect.

Instead, if the head_page exists (it does not on first allocation)
reset it back to the real head page before running the consistency
tests. Then it will be put back to its original location after
the tests are complete.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ring_buffer.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index e0573c5..68388f8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -945,6 +945,10 @@ static int rb_check_pages(struct ring_buffer_per_cpu *=
cpu_buffer)
 	struct list_head *head =3D cpu_buffer->pages;
 	struct buffer_page *bpage, *tmp;
=20
+	/* Reset the head page if it exists */
+	if (cpu_buffer->head_page)
+		rb_set_head_page(cpu_buffer);
+
 	rb_head_page_deactivate(cpu_buffer);
=20
 	if (RB_WARN_ON(cpu_buffer, head->next->prev !=3D head))
--=20
1.7.10



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpYAAoJEIy3vGnGbaoA0hwQAORcEvkieI1MG6LOcfs1pBSj
ij582rYWHFMZ5a9Jb/ywV6ZNdtsLHLnZYXdbCTVCt0bLCby2VfDZy2bN2lAR8Ixc
onRvXT67wYzeVgs3kc3A2Fnl8yUosePVZbKWB9woFL3ICJEKwEnYlj0DpcrFke2J
NQvr6gT3bdJJYN3I1czuVpu0WOQAJHBtpiHfG9pe3vvMiW//aWTBpH3T8VAmUpkO
2X/GuDop1f3oi0lsmd/IJlmcdKKzeP0IuacKOw2oYCXAmEGK5zayeZfzhQiy11kP
2PSEUiO3AiLQX6r+g3tV1KzxBCgMHm1K1g90TeiTZmgSojtDwyW9s+F0TvbndXx6
ok2yqS3Y19sb1J+N0uB+mJu93+x6jar9LO0uGri9/jFZSX2N2zj5cCjxdey7mlEE
GiAip7AW1jydFx7qlgI0SmED5ySrZK+9Y6kLuE/8XhvxLtQB7VqqJ7Ny9DyFCSZI
By1z0cWmF9NF0z5dICP6CFR5CnrZ5d1l76z+i/pEIQrkD8dpMmOXm2NN8xst3n36
G2ABzC65JO5bbpuVGEeILWMDF/qfPkuG8fnTtoiFOe594DndfE0hNyjmeNzciCFV
PyVH6rt4qnlAJuWiul2UntpUM5qQKyw4S7sPTdaJcRns6vNAkFmnGILka4/TmDcv
iGkzo+C3EgT2ZeKpStrS
=Fv7z
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
