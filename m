Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1HLCrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:47:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32887 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1HLCrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:47:41 -0400
Date: Fri, 12 Aug 2011 12:47:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the security-testing tree
Message-Id: <20110812124723.30fe0e364394fdd4900cb2e3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Aug_2011_12_47_23_+1000_KOxsrFhiYaQH=Fo+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Aug_2011_12_47_23_+1000_KOxsrFhiYaQH=Fo+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the security-testing tree, today's linux-next build
(powerpc ppc64_defconfig) failed like this:

init/mounts.o: In function `security_old_inode_init_security':
(.opd+0xf0): multiple definition of `security_old_inode_init_security'
init/main.o:(.opd+0x108): first defined here
init/mounts.o: In function `.security_old_inode_init_security':
(.text+0x50): multiple definition of `.security_old_inode_init_security'
init/main.o:(.text+0x110): first defined here

etc ... (lots and lots)

Casued by commit e1c9b23adbe8 ("evm: building without EVM enabled fixes").

Please, please, build test this stuff.  This is the same error that that
patch was supposed to fix but on another function ...

I have used the security-tree tree from next-20110809 again.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Aug_2011_12_47_23_+1000_KOxsrFhiYaQH=Fo+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJORJQ7AAoJEDMEi1NhKgbsaYwH/1VCA00QsdCmuJfdEsuMAC9O
UqpsrCVd0ePpVIEVIYt3vT02IqgQtWAzIru+7VbOFwR+Gd3EVN9fVUoy89EdIqC3
33hWpKjylr6HDCZdzKC+hH7o/Y6c/AyU2h85f/SeChxvNxJehy0tUFTIVxDJDMjY
UcubBgwl0e+8lvvTULB020HKF24K1p4cCbgysb+degJtpFf4TsxgFtRl1MIyCNPn
332gAuOw91hRNSHqqM/ulcw4akx7t30nEY7OW0HnY4bLBYaHAFkIyE1ykpW5XtEa
Yg0Pnb8Nb9tSQnQNSZcP1bgQl/h39vYeRh6Plcpnqw7rkjLUeSLQYnfNinBFtBk=
=eXxv
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Aug_2011_12_47_23_+1000_KOxsrFhiYaQH=Fo+--
