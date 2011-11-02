Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690Ab1KBEOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 00:14:32 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:48705 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab1KBEO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 00:14:29 -0400
Date: Wed, 2 Nov 2011 14:53:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the tmem tree with Linus' tree
Message-Id: <20111102145353.152925cdeee425109cf7882f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Nov_2011_14_53_53_+1100_fCAcSpWWBsH+dvmo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Nov_2011_14_53_53_+1100_fCAcSpWWBsH+dvmo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Today's linux-next merge of the tmem tree got a conflict in mm/swapfile.c
between commit 43362a4977e3 ("oom: fix race while temporarily setting
current's oom_score_adj") from Linus' tree and commit 6ce5607c1edf ("mm:
frontswap: core swap subsystem hooks and headers") from the tmem tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/swapfile.c
index c9d6540,9d79741..0000000
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@@ -1616,8 -1637,8 +1637,8 @@@ SYSCALL_DEFINE1(swapoff, const char __u
  	spin_unlock(&swap_lock);
 =20
  	oom_score_adj =3D test_set_oom_score_adj(OOM_SCORE_ADJ_MAX);
- 	err =3D try_to_unuse(type);
+ 	err =3D try_to_unuse(type, false, 0); /* force all pages to be unused */
 -	test_set_oom_score_adj(oom_score_adj);
 +	compare_swap_oom_score_adj(OOM_SCORE_ADJ_MAX, oom_score_adj);
 =20
  	if (err) {
  		/*

--Signature=_Wed__2_Nov_2011_14_53_53_+1100_fCAcSpWWBsH+dvmo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsL7RAAoJEECxmPOUX5FEHjIQAJtR+/nR/LUxravIx9/hLBgb
UZkMtCtLYTLwJDyAGL940+OGVu+KGQOn5dXVjR5I6GUPSV3W+Og9RLJkhhkJ/z01
i4BsBcRR7nzvpXEBd4AUEy0JwE6hil3GXwzpP7XD8Axrr3qA6jZDb2padBVcbAxv
MHUOKmGpc4t+bNcMKAVDGu6QZzSr5vOkOL65UtCcy6V5Bn5IYNEX66daszxmW4H3
K55wRCjn1nhdJ+Fb2UnrlulxJ7upQa2V3LABgEMau3Q1TleH211aN8e/64zJ/lN0
6fThz/xsSl2Xa8AhfUezToo4NxCE7MWHhpzBnDPbtNAGgKCngpBr8R1cVC0VMYDd
MbOLTbj7G/jY4zUCNFvEs4tfMMP4lmW9OFQWlWeUoVcyPMZLffo631MAa6ZTPKmv
3RddsR6Xl3lrHB/5a/29ZJ8VxHc2w1SW4lZoaqnpu3nuae3mEsj4uCXNXS6oTyej
yiaCHwD9Hqf1kYOwVsAeFOHhIjG5QeveFjntF8eXEbuodqEw9lz/0gEE5OVfqBi/
1T+zDal5lbu9sW9SWJbEeidgd76ItmmsH7AgxBG7mMnWo1aMbWs6V1b/rOGQtjtB
McJHN7DcoMFCDnyuRw1UDwJIYmEhczpajzwUftrK8Fr7acPfDVz5Z9lsdOq9H6tb
WnPiSp/OWwRAjtE95cAC
=56Yb
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Nov_2011_14_53_53_+1100_fCAcSpWWBsH+dvmo--
