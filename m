Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2GQDpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:45:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58585 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab2GQDpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:45:16 -0400
Date: Tue, 17 Jul 2012 13:45:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20120717134506.3f3f0614ad1d5193689de334@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Jul_2012_13_45_06_+1000_JHvk3Unm/qDW_sDw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Jul_2012_13_45_06_+1000_JHvk3Unm/qDW_sDw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/tty/tty_ioctl.c: In function 'set_sgflags':
drivers/tty/tty_ioctl.c:741:9: error: request for member 'c_iflag' in somet=
hing not a structure or union
drivers/tty/tty_ioctl.c:742:9: error: request for member 'c_oflag' in somet=
hing not a structure or union
drivers/tty/tty_ioctl.c:743:9: error: request for member 'c_lflag' in somet=
hing not a structure or union
drivers/tty/tty_ioctl.c:745:10: error: request for member 'c_iflag' in some=
thing not a structure or union
drivers/tty/tty_ioctl.c:746:10: error: request for member 'c_lflag' in some=
thing not a structure or union
drivers/tty/tty_ioctl.c:749:10: error: request for member 'c_lflag' in some=
thing not a structure or union
drivers/tty/tty_ioctl.c:753:10: error: request for member 'c_oflag' in some=
thing not a structure or union
drivers/tty/tty_ioctl.c:756:10: error: request for member 'c_iflag' in some=
thing not a structure or union
drivers/tty/tty_ioctl.c:757:10: error: request for member 'c_lflag' in some=
thing not a structure or union
drivers/tty/tty_ioctl.c:759:15: error: request for member 'c_lflag' in some=
thing not a structure or union
drivers/tty/tty_ioctl.c:760:10: error: request for member 'c_cc' in somethi=
ng not a structure or union
drivers/tty/tty_ioctl.c:761:10: error: request for member 'c_cc' in somethi=
ng not a structure or union

Caused by commit adc8d746caa6 ("tty: move the termios object into the
tty").  Did anyone build test this?  :-(

I have used the tty tree from next-20120712 again for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Jul_2012_13_45_06_+1000_JHvk3Unm/qDW_sDw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQBN/CAAoJEECxmPOUX5FEUEUQAJ1UYxLisChYDIDZPOM3St9s
PCRYQcWqSbd+xgkOnzWOj3V2hTwO9G7d7nDgEk9pIwTzLK/Bj02MmPFihdBGZWt1
aZHKh+Ug5xrFyKuMtnu21JNiu+POAFqZgBcpwPyj/Lz+tKi/zb7C2f9i98EFq8o4
7mTZbdxoFssPXpQiKV2pTkJ7gn/dXNchZpmViTfoe6ce71CZIfsknulOqjplda9P
R6DCEbiQQVpZol4/caBb6zQe3upXJk71lEcVcrB/4/Z6mZIGE3Mo/5zaRA8WLcaz
hHPJhZ+ed3KE9o6DA2aFWaUaVVWRjCtGjKbvgXu63anLKZxUMtKyUQ3rSXRM0jMc
wN++/9e55blSQ3OZy+/PHZSyCeUf2AkoP/7jO7iXChiMv2rR3g2M4JwZA2EfJtMu
VorplfCQgEp6DwuSRHHhiyrZnoSIH4U1dYMZECbG24Mw94Xh1y17tC0fZKfOA+Fb
mE/IrvfW1QYDDC3faBQdC401WisZDSjdEEMckp36yvk1iAbqZDGnKfbH4kckE87W
ni+21MLqWJz1qGSURymOPBmw8CIBrEY1doorWeY7zlY4cD/c1UnFeFy+YnVuUg+4
4CwUK++NCX0ROCKxYe6tXPTzrpithkvEywuUCIAG4mJCdEABmpxpdIK6HSOTc5k3
W0UycYEyPoUR20YNvKFB
=zyj6
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Jul_2012_13_45_06_+1000_JHvk3Unm/qDW_sDw--
