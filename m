Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab2DJSHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:07:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44741 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab2DJSHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:07:33 -0400
Date: Tue, 10 Apr 2012 21:12:10 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: arm: CONFIG_ARM_PATCH_PHYS_VIRT=y is broken on kirkwood
Message-ID: <20120410211210.310b65ea@sf.home>
In-Reply-To: <1334006908.12209.150.camel@dagon.hellion.org.uk>
References: <20120408115920.4d7d2197@sf.home>
	<1334006908.12209.150.camel@dagon.hellion.org.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=0p1r+=DpTzTOvjd_EFh9+9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/=0p1r+=DpTzTOvjd_EFh9+9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Apr 2012 22:28:28 +0100
Ian Campbell <ijc@hellion.org.uk> wrote:

> On Sun, 2012-04-08 at 11:59 +0300, Sergei Trofimovich wrote:
> > In order to make the box boot I had to set:
> >     CONFIG_EMBEDDED=3Dy
> >     # CONFIG_ARM_PATCH_PHYS_VIRT is not set
> >    CONFIG_PHYS_OFFSET=3D0x0
> >=20
> > Do you have an idea why it does not boot anymore by default?
>=20
> There is a u-boot commit which fixes this issue:
>=20
> commit 679530278d5a79d34e356ad2d452f4400953bfc2
> Author: Michael Walle <[michael@walle.cc]>
> Date:   Mon Feb 6 22:42:10 2012 +0530
>=20
>     arm, arm-kirkwood: disable l2c before linux boot
>    =20
>     The decompressor expects the L2 cache to be disabled. This fixes boot=
ing
>     some kernels, which have CONFIG_ARM_PATCH_PHYS_VIRT enabled.
>    =20
>     Signed-off-by: Michael Walle <michael@walle.cc>
>     Acked-by: Prafulla Wadaskar <prafulla@marvell.com>
>     Cc: Albert ARIBAUD <albert.u.boot@aribaud.net>
>     Cc: Prafulla Wadaskar <prafulla@marvell.com>
>     Cc: Wolfgang Denk <wd@denx.de>

Thank you, Ian. Updating u-boot helped!

Sorry for the noise.

--=20

  Sergei

--Sig_/=0p1r+=DpTzTOvjd_EFh9+9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk+EeAAACgkQcaHudmEf86qGNACghXyB6TuVjqFJpETqHdtH7mjB
5kAAnR0DvSRcG+DtuXfohLAjZ995PWJA
=eSlg
-----END PGP SIGNATURE-----

--Sig_/=0p1r+=DpTzTOvjd_EFh9+9--
