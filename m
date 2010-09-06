Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab0IFCOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 22:14:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46716 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab0IFCOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 22:14:18 -0400
Date: Mon, 6 Sep 2010 12:14:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Brown <neilb@suse.de>
Subject: linux-next: build warning after merge of the rcu tree
Message-Id: <20100906121408.33946fbe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__6_Sep_2010_12_14_08_+1000_kbic0tRelF_CNZ46"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Sep_2010_12_14_08_+1000_kbic0tRelF_CNZ46
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the rcu tree, today's linux-next build
(powerpc ppc64_defconfig) produced this warning:

drivers/md/raid1.c: In function 'read_balance':
drivers/md/raid1.c:445: warning: operation on 'new_disk' may be undefined

I am picking on the rcu tree because the line above has not changed since
2005.  The line is:

                for (rdev =3D rcu_dereference(conf->mirrors[new_disk].rdev);
                     r1_bio->bios[new_disk] =3D=3D IO_BLOCKED ||
                     !rdev || !test_bit(In_sync, &rdev->flags)
                             || test_bit(WriteMostly, &rdev->flags);
                     rdev =3D rcu_dereference(conf->mirrors[++new_disk].rde=
v)) {

Where new_disk is being updated in the parameter to the last
rcu_dereference.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__6_Sep_2010_12_14_08_+1000_kbic0tRelF_CNZ46
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMhE5wAAoJEDMEi1NhKgbsfTQH/3vbqHfUp9bdRp+1WXe80ovn
AWhVr6Iir1Bbi1p4pd4wKppmnfc3sCvwjYgRlvHxg2HpMf8tlWAYcTorkuC2AM5l
nealWmV5HEksTYglBNSJfV41alzMsTadhRsWhcC+bwhYOa1/8zI4zakDlI8ObFkt
8GvYlss7R0VipsNiS4ULZb9gvEqPjFCGFKr2108N165cL9YOLln/tg03mlyHVXwb
WCGo1pX5COEjZXyYU3K+LZMy9qZEFG0PMSw+WqxZOe/e2Zme161Hs20r0HX19sql
LW7SyGa6S0dVY9nZavLscFnX0GOlHRfXsnMnqbekskFW6Zlc3n09NhCZplCVSC4=
=6wPi
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Sep_2010_12_14_08_+1000_kbic0tRelF_CNZ46--
