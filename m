Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab1JZUVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:21:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46738 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1JZUVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:21:48 -0400
Subject: Re: [Regression] Laptop screen dark when lid closed and
 reopened.with 3.1
From: Kamal Mostafa <kamal@canonical.com>
To: Keith Packard <keithp@keithp.com>
Cc: Alex Davis <alex14641@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mjg@redhat.com" <mjg@redhat.com>
In-Reply-To: <yunmxcnhjlh.fsf@aiko.keithp.com>
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com>
	 <1316868946.61433.YahooMailNeo@web130123.mail.mud.yahoo.com>
	 <yunvcsim1wk.fsf@aiko.keithp.com>
	 <1316877222.89367.YahooMailNeo@web130124.mail.mud.yahoo.com>
	 <yunsjnln8it.fsf@aiko.keithp.com>
	 <1316957004.77729.YahooMailNeo@web130108.mail.mud.yahoo.com>
	 <1317583219.81808.YahooMailNeo@web130113.mail.mud.yahoo.com>
	 <1319599156.52195.YahooMailNeo@web130106.mail.mud.yahoo.com>
	 <yunmxcnhjlh.fsf@aiko.keithp.com>
Content-Type: multipart/signed; micalg="pgp-sha256"; protocol="application/pgp-signature"; boundary="=-TyRt3KIMCmAdy4fELz7H"
Date: Wed, 26 Oct 2011 13:21:40 -0700
Message-ID: <1319660500.4206.120.camel@fourier>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TyRt3KIMCmAdy4fELz7H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-10-26 at 08:13 -0700, Keith Packard wrote:
> On Tue, 25 Oct 2011 20:19:16 -0700 (PDT), Alex Davis <alex14641@yahoo.com=
> wrote:
>=20
> > At the request of Kamal Mostafa, an Ubuntu kernel developer, I am resub=
mitting this patch which fixes my backlight issue.
> > It seem that there are a number of people with different machines that =
have this problem:
>=20
> We have a patch that should land in a 3.1 stable release that should
> resolve this issue; can you test that?
>=20
> commit f52c619a590fa75276c07dfcaf380dee53e4ea4c
> Author: Takashi Iwai <tiwai@suse.de>
> Date:   Fri Oct 14 11:45:40 2011 +0200
>=20
>     drm/i915/panel: Always record the backlight level again (but cleverly=
)

That patch (f52c619a) does not fix the problem on my Dell Studio 1558.

Alex's proposed patch -- removing the intel_panel_set_backlight(dev, 0)
call from intel_panel_disable_backlight -- does fix the problem
completely for me.

Please forgive the silly question, but why does
intel_panel_disable_backlight even want to set the brightness to 0
anyway?...  Its only caller is just about to turn off power to the
panel.

Is that call to intel_panel_{,actually_}set_backlight(dev, 0) really
necessary or useful on *any* systems?

 -Kamal


--=-TyRt3KIMCmAdy4fELz7H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJOqGvRAAoJEOf3EFVUCeQiDhoP/3XOqPvJr9zou+vWw0QN+ltH
L5g7Xl25bKBn0VCl+Wx5hzuhPHdjUqwMnkdvZiG1kI8PhqjRFb6Vnb2DZTJz2+Xf
EBrolfaeWvCrEzEkHDOnEWZoGs3HpzONcA8gCJ4fI0+5w2mL/Qnb5enLU/IjaGPe
AuKEmaA6pGrQOnjUIqmyPeoAKICBm9mLitlkyMRvXR09oa+PR+U2SJiwgQWV8QcN
dBSeX/kvaJpB32L/LnYDb52h1R1FFcKWVX8MBY5vFRgEwMmtudmwvUvd/pqI2Xw/
viRxSB6t9oB4yaQaFE1sQwfBanLH/McVCn6y/U7Rw3wX4eeROiTyoSeEI0DLwqCA
iSURSDSrJPJee/sfQlxnrBMxVydo1RVdx2EZ3kUJgwTzO5CYbxyymzFvWcJQAQb6
NFuKnUx1hUhB84pvUu/aNDmXn9ZlMOPyxoEIqPH0W9NeOxS2/A5BerLWlwiieFYb
w5Vn3BHJ75W2Pvj3q1zBu0+JHvxO0EZb0C2mT43rVwReWClKcmEYNG802PNfxqdo
LxX8SmiQb1E9i4LhTdlP1dfIplGdRPgdvdWUr04IkjAiJF6Ev+655oAbNefjDUsL
wNR2lF1L/JqsZ4DPU0ZN3x7DtNpCIrbBduyms34aTn+7KJjjRxJL7OxO1KxsKJWl
8kzy/vbQdaLEEgMINOkO
=581J
-----END PGP SIGNATURE-----

--=-TyRt3KIMCmAdy4fELz7H--

