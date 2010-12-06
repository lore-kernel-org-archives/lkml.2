Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0LFWEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:04:47 -0500
Received: from phlare.wyrms.net ([99.158.15.237]:41788 "EHLO phlare.wyrms.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab0LFWEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:04:46 -0500
Subject: Re: Issue with firewire from 2.6.35.9 to 2.6.36.1
From: Robin Cook <rcook@wyrms.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
        linux1394-devel <linux1394-devel@lists.sourceforge.net>
In-Reply-To: <20101206082918.6d1ccc41@stein>
References: <1291592226.7134.1.camel@pheuri.wyrms.net>
	 <1291594279.9196.2.camel@maxim-laptop>  <20101206082918.6d1ccc41@stein>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iTBIo76+C0IS8i/C1rhE"
Date: Mon, 06 Dec 2010 16:04:47 -0600
Message-ID: <1291673087.4022.2.camel@pheuri.wyrms.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iTBIo76+C0IS8i/C1rhE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-12-06 at 08:29 +0100, Stefan Richter wrote:
> > On Sun, 2010-12-05 at 17:37 -0600, Robin Cook wrote:
> > > Hello,
> > >=20
> > > I recently upgraded from 26.35.9 to 2.6.36.1 and now the /dev/fwX
> > > devices are not being created.  I have udev 164 installed.
> > >=20
> > > 2.6.35.9 dmesg firewire lines...
> > >=20
> > > firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 4=
4
> > > firewire_ohci 0000:07:00.0: setting latency timer to 64
> > > firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + =
8 IT contexts, quirks 0x1
> > > firewire_core: created device fw0: GUID 0010dc0001adc862, S400
> > > firewire_core: created device fw1: GUID 00808803072803a5, S100
> > > firewire_core: phy config: card 0, new root=3Dffc1, gap_count=3D5
> > >=20
> > > 2.6.36.1 dmesg firewire lines...
> > >=20
> > > firewire_ohci 0000:07:00.0: PCI INT A -> GSI 44 (level, low) -> IRQ 4=
4
> > > firewire_ohci 0000:07:00.0: setting latency timer to 64
> > > firewire_ohci 0000:07:00.0: irq 75 for MSI/MSI-X
> > > firewire_ohci: Added fw-ohci device 0000:07:00.0, OHCI v1.10, 4 IR + =
8 IT contexts, quirks 0x1
> > >=20
> > > I have compared the difference between the two kernel configs and the
> > > only differences that I see that may apply to the firewire are:
> > >=20
> > >  CONFIG_DNOTIFY=3Dy
> > > -CONFIG_INOTIFY=3Dy
> > >  CONFIG_INOTIFY_USER=3Dy
> > >=20
> > >  # CONFIG_IEEE1394 is not set=20
> > > +CONFIG_FIREWIRE_NOSY=3Dm =20
> > >  CONFIG_I2O=3Dm
> > >=20
> > > On the ieee1394 wiki page it says that these kernel option are expect=
ed
> > > to be on for the libraw1394:
> > >=20
> > > CONFIG_INOTIFY=3Dy
> > > CONFIG_INOTIFY_USER=3Dy
> > > CONFIG_EPOLL=3Dy
> > >=20
> > > These option are correct in the 2.6.35.9 kernel but the CONFIG_INOTIF=
Y
> > > option is missing completely in the 2.6.36.1 kernel.
> > >=20
> > > Is this a change in how the firewire works in the kernel and that ude=
v
> > > needs to be modified or is there something else wrong?
>=20
> I hadn't noticed that the INOTIFY kconfig options changed relative to
> what is documented at the wiki.  I'll update that.
>=20
> It is most likely not the cause for your issue.  Rather, MSI support
> (messages signaled interrupts, added to firewire-ohci in kernel 2.6.36)
> of your controller might be buggy.  Which controller do you have
> according to "lspci -nn"?
>=20
> Try "modprobe -r firewire-ohci", "modprobe firewire-ohci quirks=3D17".
> The unrelated quirks flag 1 is already present in firewire-ohci's
> quirks list; the additional flag 16 switches off MSI.

Output from lspci -nn on the firewire controller.

07:00.0 FireWire (IEEE 1394) [0c00]: VIA Technologies, Inc. VT6315 Series F=
irewire Controller [1106:3403]

The modprobe firewire-ohci quirks=3D17 worked to get the devices being
created again.



--=-iTBIo76+C0IS8i/C1rhE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJM/V30AAoJEDx9azGHxhuRPocP/264PbaV7FkG0L2t+dHhd6i2
beJ/BT2oq4Z+rByDz9SCJyExSYuZgI19dTxA9G465BherQsJixJocdlFdS4aoZHZ
v5Rgg4YfJOKYC6Xs/VYGnQuU6YJgaP5iUOHklqr8+6I5bsvpq0q7cptaDG9+4sGz
phx2yRcuoedGLwRV62Zjl4Y3YQaJ6zepgOqZ20YlXxDDVLZtzttYhUsOl4Wz2N2N
MIWdLkOo63CGEhE/9YaRLx3KzurrzXv5C3/wNfBGswemYrcq6VrzkQVQBnBzs2zM
GT20g2UsuHG98T8EuCkwA2+Q83KZjsKYkFBRKU70397TcOvaUYKFdhqESgxQaO+u
e8c9PxtUowdZCadEPxyxK6Ed1Guk2GAathNhezwjaGkgxr+MoR/FuvC306hc8AFk
Qo7yy7bf6rWghfrtOo90n0RR4uOrj3ws/oir+bkNJ7cdmtC9gQu2H661GTX82qkC
FCyxdbCF92HZCmx8tlz7te+3DYTk99fnULhH3u+pQ1H1BdpVj3CcSlhCnTyNPp0e
GEoQrKoY9dE+5msGztWctYeFmZdVl1uwvoXB+Lb9UZQ/93TAQO5j0U+XYEwOou5Z
Flw9HGZNR5ua0ZzqasEvVhnJ5k2Mul5Voq0TU9uFGSnM1DbjLQzvZ0Mc9XaBV8bd
loGIWBtJ+UuPAPcvlY1G
=JvKy
-----END PGP SIGNATURE-----

--=-iTBIo76+C0IS8i/C1rhE--

