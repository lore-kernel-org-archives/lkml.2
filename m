Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab0LQGLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 01:11:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37339 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab0LQGLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 01:11:30 -0500
Date: Fri, 17 Dec 2010 17:11:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: build failure after merge of the final tree (tty tree
 related)
Message-Id: <20101217171120.295b0c0c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Dec_2010_17_11_20_+1100_=1Hw5kPRz+hYrFiM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Dec_2010_17_11_20_+1100_=1Hw5kPRz+hYrFiM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/serial/apbuart.c:596: error: conflicting types for 'grlib_apbuart_c=
onfigure'
drivers/serial/apbuart.c:523: note: previous declaration of 'grlib_apbuart_=
configure' was here

Caused by commit 35c64e5d13c3d7d8c4ad061ad5e20498b9160c24 ("drivers:
serial: apbuart: Handle OF failures gracefully").  This build has
CONFIG_SERIAL_GRLIB_GAISLER_APBUART_CONSOLE set ...

I have reverted this commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Dec_2010_17_11_20_+1100_=1Hw5kPRz+hYrFiM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNCv8IAAoJEDMEi1NhKgbsT5kH/jCNMmjnt6J7ebSBk0jpo7JQ
QBMkShL5LghsvvPq4BiNoD5F+OZyB/7A9mvV2KjiP0hN5Iq2DU2NC2a9ClblN8wS
e2pYaMnie8AOzL9eueuO4qeU7cRKRs7D37V/tqS7FQgXwb8eTxIaZhWGh7fMJgt4
xmE6S5HdKdAvER5kSQFO5lhtb6mHSBPvzBIV2ElYv7QIOLYIey0xNhO9fYn9v2K8
KSUVjpOb/VTvrRotzwlcbVEHYxPekEt3m+AmbbIow30KILYbNdyhRlHLRbp6E8RN
lzvLTJ4tfxXXziASg6oJ5pCQ44I+6j6II4fk2X1py8Y8RPbsxIgxTwGG6gU62CM=
=etMZ
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Dec_2010_17_11_20_+1100_=1Hw5kPRz+hYrFiM--
