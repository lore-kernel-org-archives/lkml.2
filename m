Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2GaKqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:46:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab2GaKqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:46:48 -0400
Date: Tue, 31 Jul 2012 12:46:35 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Simon Glass <sjg@chromium.org>, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120731104635.GC16155@avionic-0098.adnet.avionic-design.de>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <CAPnjgZ0H2xrJcL-ytMaX11iYrrhCg7LEM00u_NgEaveM4gHMPw@mail.gmail.com>
 <50179933.9090501@nvidia.com>
 <20120731091324.GA15557@avionic-0098.adnet.avionic-design.de>
 <5017AF5D.2010204@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96YOpH+ONegL0A3E"
Content-Disposition: inline
In-Reply-To: <5017AF5D.2010204@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:L+b4uc/DH7Ux63DkrgHT2JVPvNhkDq/r9qXIG1yp8lH
 qEWdR4U2UUGWwVPnIFrDBqGfEQUc+dogszjUoHcEsvza9P7tah
 zLay3nigyLj+Er7D6jhUuIimaPA/guGLTlJDN8YIdc4b+KRi9C
 ahfHVLnzkRDDlpZJJcIVZHVxuCm47stYEu5yHTPIrOkh0BuF2z
 wVx6Fg005cBU72dxfYeYSHiM12G/NQvA55L6cL21NIu7dWNxre
 2oE26MXGXBLjFKFh7n+//0+lDaLtlzHDSiQ6SBsvmEEp03oYT7
 HjLOn0bZ/7xzqyubRJSXMEx58NuArNitqbBISaaFEOpGCYzHid
 XGWvP5Bsc4VDMgi81KnmRtehMoKUlhI3HxkhD1VgQyiOegl4Wj
 bc8WMhT9hTXuToH7NgoROMynEs5U8qhd2+JZam2Tdzemr037Nw
 RjjdK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 31, 2012 at 07:11:41PM +0900, Alex Courbot wrote:
> On 07/31/2012 06:13 PM, Thierry Reding wrote:
> >>I don't see any need for microseconds myself - anybody sees use for
> >>finer-grained delays?
> >>
> >>Btw, I noticed I was using mdelay instead of msleep - caught and fixed =
that.
> >
> >You might want to take a look at Documentation/timers/timers-howto.txt.
> >msleep() isn't very accurate for periods shorter than 20 ms.
>=20
> Ok, looks like usleep_range is the way to go here. In that case it
> would probably not hurt to specify delays in microseconds in the DT
> and platform data as well.


>=20
> >>>>+Device tree
> >>>>+-----------
> >>>>+All the same, power sequences can be encoded as device tree nodes. T=
he following
> >>>>+properties and nodes are equivalent to the platform data defined pre=
viously:
> >>>>+
> >>>>+               power-supply =3D <&mydevice_reg>;
> >>>>+               enable-gpio =3D <&gpio 6 0>;
> >>>>+
> >>>>+               power-on-sequence {
> >>>>+                       regulator@0 {
> >>>>+                               id =3D "power";
> >>>
> >>>Is there a reason not to put the phandle here, like:
> >>>
> >>>                                    id =3D <&mydevice_reg>;
> >>>
> >>>(or maybe 'device' instead of id?)
> >>
> >>There is one reason, but it might be a bad one. On Tegra, PWM
> >>phandle uses an extra cell to encode the duty-cycle the PWM should
> >>have when we call get_pwm().
> >
> >This is not only the case on Tegra, but it is the default unless a
> >driver specifically overrides it. The second cell specifies the index of
> >the PWM device within the PWM chip.  The third cell doesn't specify the
> >duty cycle but the period of the PWM.
>=20
> Then I think there is a mistake in
> Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt:
>=20
> "the second cell is the duty cycle in nanoseconds."

Yes, that's a mistake. =3D\

> >>This makes it possible to address the
> >>same PWM with different phandles (and different duty cycles),
> >
> >How so? A phandle will always refer to a PWM chip. Paired with the
> >second cell, of_pwm_request() will resolve that into the correct PWM
> >device.
>=20
> For tegra, we can only address PWMs this way IIRC:
>=20
> pwm =3D <&pwm 2 5000000>;
>=20
> If we had <&pwm 2>, I agree that there would be no problem. But here
> the period of the PWM is also given - and in practice, we can
> request the same PWM using different phandles. For instance, if the
> above property was part of the power-on sequence, and the following
>=20
> pwm =3D <&pwm 2 0>;
>=20
> was part of power-off, how can I know that these two different
> phandles refer to the same PWM without calling pwm_get a second time
> and getting -EBUSY?

You should specify the same period regardless of the sequence. But you
are right, you still cannot request the device twice.

> Of course if the same period is specified for both, I will not have
> this issue as the phandles will be identical, but the possibility
> remains open that we are given a faulty tree here.

I think the phandle is in fact only the reference to the PWM chip, that
is: &pwm. The second cell, the PWM index, is part of the PWM specifier.

However the issue doesn't go away if you drop the period cell because
you still won't be able to request the PWM device a second time. How is
this solved for regulators and GPIOs? At least for GPIOs I'm pretty sure
that you can't request them more than once either.

> More generally speaking, wouldn't it make more sense to have the
> period/duty cycle of a PWM encoded into separate properties when
> needed and have the phandle just reference the PWM instance? This
> also seems to stand from an API point of view, since the period is
> not specified when invoking pwm_request or pwm_get, but set by its
> own pwm_set_period function?

The problem with specifying the period in a separate property is how to
map them to the correct PWM device. From a hardware description point of
view, making the period part of the specifier makes a lot of sense and
hardware description is what DT is about.

> On an unrelated note, I also don't understand why the period is also
> a parameter of pwm_config and why pwm_set_period does not do
> anything beyond setting a struct member that is returned by
> pwm_get_period (but maybe I am missing something here).

pwm_config() is the legacy API that we need to support for compatibility
reasons. Eventually this interface should probably be changed.
pwm_get_period() and pwm_set_period() were merely introduced to support
DT, but I could imagine them becoming the canonical way for configuring
PWM devices in the future, perhaps with a complementary
pwm_set_duty_cycle().

But first we need to convert drivers and users.

Thierry

--96YOpH+ONegL0A3E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQF7eLAAoJEN0jrNd/PrOhCMQP/002Zx9soqEaEr/tIEcG3wLA
Uc6bkJUOhcJPysPCKVNEHXx88E3wEf3xcUe+kXZabugGug2ZAKfRN1o2Mdwi1G7/
0h2oXGy6b109ASUDfFT1pvFM6K+hzqXK9TEhUfI3vzNNJDEUYcCv5SNGOTNJKXDL
lDBAZufpjiiDQEyZWVfQ+kml9yDrdPxTeixns9iCGLaDm5pxu+hdkHabga7JD0ln
FaDqSjxHEpJC45+xml70U7SmF7EqjQjWZvBd1OB2NLP45nfhWjlp67+Is3iLdyQE
c6CW1qGNHXVaK+qrstCurWVz7+6ttwkneXta9fCW/0/ntF3SRjDmldDLNd5nm6BC
1FkymBE2Vz+wXoFcawcSrwKiIcUceF6NiMO95mCi6WsU2yfWS+sb4qOKWSvQrIDF
IWpCACsOcOJI1UchTprMHnbgGWsdpNo8wkLNqlCm+71ibRoo0k8kIQS5uVHcnkUI
mxWPK0V2i/FJ/zJJGRhMMp18lfpGuwpjBYzC2XMsXNiLOAucVyo/k8f+xNsj++Er
Rya8SAoHSjkBE0cXAxJRmnfH0vT8e/BAMbiz0T9k5uuW/c/8Siut827ouMg2CTss
DVpRZLTvkOVKw03wMSxfLlMKc68N3eQxAixR4OOLWXbKr0ePF/KTcYpWaYmTk9hq
0Bh3uBhF9oKldlwqoNkJ
=dhtd
-----END PGP SIGNATURE-----

--96YOpH+ONegL0A3E--
