Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab2DPELa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 00:11:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52736 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2DPEL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 00:11:29 -0400
Date: Mon, 16 Apr 2012 14:11:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: linux-next: build failure after merge of the rcu tree
Message-Id: <20120416141117.6dfcc5931400fede4e8cbe58@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Apr_2012_14_11_17_+1000_kWt7R0QzWZVtoQvE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Apr_2012_14_11_17_+1000_kWt7R0QzWZVtoQvE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the rcu tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/binfmt_misc.c: In function 'create_entry':
fs/binfmt_misc.c:314:2: error: implicit declaration of function '_copy_from=
_user' [-Werror=3Dimplicit-function-declaration]

Caused by commit d17faaa53e2e ("fs: Silence bogus copy_to_user() build
errors").  _copy_from_user() appears to only exist for the x86 and tile
architectures ...

I have used the rcu tree from next-20120413 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Apr_2012_14_11_17_+1000_kWt7R0QzWZVtoQvE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPi5vlAAoJEECxmPOUX5FEqNEP/2nsIMHNep2YHa5ZIkTQJ6cF
19xCNXv7m4LFgoJ1c2D5vav4ClqRm8HLCvnLG0DaxKTzcWhyc5SUkp4GXYkUWYj4
Kxn3Z0hqPS+qj7c1HWMlylwq6gsWRoRELjs3svs+6FPB4r83db/F12qC8aTubvUB
n3AU6FYqIb7UW3StGVY2XeXG2siXpn7j4HWaclSprnTtzRzXRa65HvwiXGdCOakn
QP9zdDJ4qfwVPBMnhTVUJX6D+HcKwsiGDPtxUGLpR4Fn+N6EBauiyzByT9zaiUde
oMzJkPzdafmpHMLBVBvWkJi4culcX9DcWKC7/yRUgawWjTCU4So7jvzn+FlnGOKI
QKL8Nn25Jy5FQcfRNqMK0sP/duxA96mgzjMr1eq8MyGQG8v4Bn5VRFKKTR8o4K+v
svm/U8CmgQTLmSNyOC7YnwE028807RQZplF8Xs2sKAVbG71XVyY8jbeX1Qou8+3Z
Va4AYlBH3dwoQu7tb4JMivj2vaiws5Pui/ImUMksD41s2mEFoUcnGEk1v+3JeU9O
fyITFG2cyOPOa2iLxVHs9k1ZiYzrybZan/FC9jQDqMvkhWogLwlgKstLuSK1w7rz
1HeVXPfLUY4eC4k9CCFmqgaQ5w/jqxCXjR0WNIefgJ1Mv1fKUWF7M3+cXKoFJmuc
IifIAcS6CuekqJv5kQFK
=IEYc
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Apr_2012_14_11_17_+1000_kWt7R0QzWZVtoQvE--
