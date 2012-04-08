Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2DHIyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 04:54:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50190 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab2DHIyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 04:54:45 -0400
Date: Sun, 8 Apr 2012 11:59:20 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>
Subject: arm: CONFIG_ARM_PATCH_PHYS_VIRT=y is broken on kirkwood
Message-ID: <20120408115920.4d7d2197@sf.home>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//YkLQGNBYWvKleuMftexKFn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//YkLQGNBYWvKleuMftexKFn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russel!

I've noticed sheevaplug is not able to boot with
kirkwood_defconfig anymore. After dumb bisection
I've figured out that
    CONFIG_ARM_PATCH_PHYS_VIRT=3Dy
was the problem.

The commit in question is :
> c1becedc8871645278832fabdc6fe138082a495b is the first bad commit
> commit c1becedc8871645278832fabdc6fe138082a495b
> Author: Russell King <rmk+kernel@arm.linux.org.uk>
> Date:   Wed Aug 10 10:23:45 2011 +0100
>=20
>     ARM: enable ARM_PATCH_PHYS_VIRT by default

In order to make the box boot I had to set:
    CONFIG_EMBEDDED=3Dy
    # CONFIG_ARM_PATCH_PHYS_VIRT is not set
   CONFIG_PHYS_OFFSET=3D0x0

Do you have an idea why it does not boot anymore by default?

Thanks!

--=20

  Sergei

--Sig_//YkLQGNBYWvKleuMftexKFn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk+BU3AACgkQcaHudmEf86oR1wCdGabqs9s7ilJKXcs0jk9a91Cy
S8YAnA95aJ/vnYNOy/FMTqfoKiHzSesX
=SuPh
-----END PGP SIGNATURE-----

--Sig_//YkLQGNBYWvKleuMftexKFn--
