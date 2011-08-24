Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab1HXW55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:57:57 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49892 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750751Ab1HXW54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:57:56 -0400
Date: Thu, 25 Aug 2011 01:57:52 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Michal Nazarewicz <mnazarewicz@google.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20110824225751.GC19689@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <op.v0pywi0nvgw7ix@mnazarewicz-glaptop>
 <Pine.LNX.4.44L0.1108241028370.2010-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+xNpyl7Qekk2NvDX"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1108241028370.2010-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+xNpyl7Qekk2NvDX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 24, 2011 at 10:31:27AM -0400, Alan Stern wrote:
> On Wed, 24 Aug 2011, Michal Nazarewicz wrote:
>=20
> > On Tue, 23 Aug 2011 22:49:37 +0200, Alan Stern <stern@rowland.harvard.e=
du> =20
> > wrote:
> > > Still, maybe I was wrong.  Maybe it would be better to use the fastest
> > > speed supported by at least one of the function drivers.  The user can
> > > always force a SuperSpeed-capable device to run at high speed by using
> > > a USB-2 cable to plug it in.  I'm not sure whether the user could for=
ce
> > > such a device to run at full speed, however.
> >=20
> > I'm actually wondering whether we really need to worry about it.
> > composite_driver has the =E2=80=9Cmax_speed=E2=80=9D field and I would =
just leave it as
> > composite driver's author responsibility to put correct value there.
> >=20
> > One thing that could be worth doing is iterate over all the configurati=
ons
> > and figure out if at least one supports the speed declared by =E2=80=9C=
max_speed=E2=80=9D
> > and if not, lower it.
>=20
> That's the same as what I said: Use the highest speed supported by any=20
> function driver.  There really isn't any point in allowing connections=20
> faster than that.  And as Felipe pointed out, the user always has the=20
> capability to force the connection to be slower, by using the right=20
> sorts of cables and hubs.
>=20
> > Like I've said before, as additional functionality, composite.c could
> > check if it's USB_SPEED_UNKWONW in which case it would look for the low=
est
> > speed that all the functions support.
> >=20
> > Such configuration would allow composite driver authors set the speed to
> > USB_SPEED_SUPER when they mean =E2=80=9Cchoose maximum speed at least o=
ne function
> > supports=E2=80=9D and to =E2=80=9CUSB_SPEED_UNKWONW=E2=80=9D when they =
mean =E2=80=9Cchoose maximum speed
> > all the functions support=E2=80=9D.
> >=20
> > Does that make sense?
>=20
> It's reasonable.  Just be sure to document it properly; otherwise=20
> nobody will understand or remember it!

good point. I agree with this approach.

--=20
balbi

--+xNpyl7Qekk2NvDX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOVYHvAAoJEAv8Txj19kN1PNUIAKcJ79MlqgPhSW0czhM/ioNe
/1eOf4E4nckrkzd42ads0kGu3u6aAUVsnQe/zZbU/FjPa/2usYlZS/TYOETaNupk
mxY9elZw6wgBgsiQV7d8LCBFMVco1FwoDLoIGH4QuNPjpf7fU7djGTO0grIHb02a
vRDV6GuM4f1VszFmQAk4P76hku4pGOpteAKzCbvmtiI8yPy1CHGKGsn6cT3Edpi4
VLJp9OYls5H5MIG+m8ehPC7/yyIoHog01tBNQ6iWZhBuQWnA/HzpCdHCrrFDuMFP
dEywMMsHT6V+ULGnfjop6TbMy6lXeiP5Vq8IziZ4T7VXh80pjISzGuxQA7VTCvw=
=Bbp5
-----END PGP SIGNATURE-----

--+xNpyl7Qekk2NvDX--
