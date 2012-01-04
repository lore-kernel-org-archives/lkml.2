Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab2ADUC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:02:56 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:46693 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755440Ab2ADUCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:02:53 -0500
Date: Wed, 4 Jan 2012 12:02:48 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Miller <davem@davemloft.net>
Cc: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org, bhelgaas@google.com,
        gregkh@suse.de, linux-pci@vger.kernel.org
Subject: Re: [PATCH] msi: fix imbalanced refcount of msi irq sysfs objects
Message-ID: <20120104120248.4f4747bf@jbarnes-desktop>
In-Reply-To: <20120104.145619.1728971973635198635.davem@davemloft.net>
References: <20120103185304.GA25184@hmsreliant.think-freely.org>
	<20120104091952.7cc5316d@jbarnes-desktop>
	<20120104195134.GB24324@hmsreliant.think-freely.org>
	<20120104.145619.1728971973635198635.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ku=tDE91o83RH.51jJMki4S"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ku=tDE91o83RH.51jJMki4S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 04 Jan 2012 14:56:19 -0500 (EST)
David Miller <davem@davemloft.net> wrote:

> From: Neil Horman <nhorman@tuxdriver.com>
> Date: Wed, 4 Jan 2012 14:51:34 -0500
>=20
> > On Wed, Jan 04, 2012 at 09:19:52AM -0800, Jesse Barnes wrote:
> >> On Tue, 3 Jan 2012 13:53:05 -0500
> >> Neil Horman <nhorman@tuxdriver.com> wrote:
> >>=20
> >> > On Tue, Jan 03, 2012 at 01:05:26PM -0500, David Miller wrote:
> >> > > From: Neil Horman <nhorman@tuxdriver.com>
> >> > > Date: Tue,  3 Jan 2012 10:29:54 -0500
> >> > >=20
> >> > > > This warning was recently reported to me:
> >> > >=20
> >> > > I've hit this too, see:
> >> > >=20
> >> > > http://marc.info/?l=3Dlinux-kernel&m=3D132458146927890&w=3D2
> >> > >=20
> >> > > and my analysis at:
> >> > >=20
> >> > > http://marc.info/?l=3Dlinux-arch&m=3D132458391128660&w=3D2
> >> > >=20
> >> > Yup, your analysis is correct. Regardless of the why behind msi enab=
lement
> >> > failing, we need to gate the kobject_del/put in free_msi_irqs on suc=
cessful
> >> > completion of kobject_init_and_add in populate_msi_sysfs.  This patc=
h does that,
> >> > using the parent pointer as a flag.
> >>=20
> >> I applied this to my -next branch; doesn't seem critical to land
> >> immediately.  If you disagree let me know and I'll pull it over to my
> >> for-linus branch instead.
> >>=20
> >> Thanks,
> > I'm ok with it waiting, but I'll defer to Dave and others who have seen=
 it
> > occur.  It sounds like its alot of log noise.
>=20
> The bug only exists in the PCI -next code I thought.

Oh yeah, looks like it.  Lost track of my -next vs master branches
there...

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/ku=tDE91o83RH.51jJMki4S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPBLBoAAoJEIEoDkX4Qk9hzHkQAL8Cvt4rQbQOc3zdhgyRAVEA
y4knKXIQmcYi7yEUfeMSupkZSDxK8LMTxWl+5aUTM4wABUCQ8sCvShR0rc0hqefq
IxXuIsStcoUsrmOlzUcCvsENaJQAD/x3XU6besPgkeHk5L6BHo7GpPNV/nzLJOhx
gtgF8VrPEHSax9nfdQnpj27mkMl2CUsApdcQJXCEbF0gBw2pzg5f9VQTNF4RzVYQ
5RT++b+BGN8+zYoAeWtAP/3m0Bo8vjKVMBXJky6KLIt1FTD9QVD1tHz/Ns7jPvXY
sd8kaRc+L2WTQ+77BlmvibSRNnDMOGyYxtl9DHiRvhVonpX+jH7ldy3+dda3Fdg7
9fbqAJln/SdcFEM1155YZQ77ehLe/9p5LuTzQhYRjqHwWZQIDEUSL1PwSVG1N+Hd
FCq4xwvtE2yQrLcaktTqodb7rNTqBgT1ajiN+dHe8YCRhe+Df/eZYtMbLS1I67ce
1vPuzFMfpv2p+3jv0WnWwSRhJ+ZdZBszd0fCe+zMZ+CFJ+tANRG/8o6Alk+db3nK
VZgqXh67/l3acB9zGaXvF6t8QWwPYxfFjNBuEewNZDCKbXGLCteV9oH7CaP2/t0n
0H9EWwqxqZ+tJEPN/q2fkIOwUTIuCYllj+CZoH3WRdjIV16tW7NbAZn2yLMC3P3H
rS4HDUX+o3Z2MKT3jFC8
=+2ZT
-----END PGP SIGNATURE-----

--Sig_/ku=tDE91o83RH.51jJMki4S--
