Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2HPJxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 05:53:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2HPJxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 05:53:07 -0400
Date: Thu, 16 Aug 2012 11:52:51 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Message-ID: <20120816095251.GA30646@avionic-0098.mockup.avionic-design.de>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
 <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
 <20120816074232.GA17917@avionic-0098.mockup.avionic-design.de>
 <502CBB0C.70102@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <502CBB0C.70102@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:DwLR06w6L9S9blL+JF4+PgYRlGxKWWH/w4ZLgBDF5Lb
 k3fflNo2+HdA2XM3ZdaIyr+L8yD/GJxsTRk9pTIL41m+v2krrY
 T8HlNP/H0huR2AN2M0c0ovpBiimWDRwFIZA4IARnudvBebx3rs
 2s0PAxFl6dEvo/sr/zXuO+p6Rq9ymj6MnOSME7VUAV3fyEM/Ih
 MYjyEX6+0l6Mn0RPi98PCv8JvXsjpFpGBsWARVvq93YhVVpRY3
 jX9xjzaDzZWPPj9F1sD1ntQfxbJuW7vOl4+mhuVX3YicZzAHID
 kqzSvzyvIEBSUlY30oZsRiSxvBT627eZo1zGx6MUsCkHIAVAeT
 MYW6ZLvvAb1rutaIRl+2kc1SlIwfY9tbXHROw5Bf3dZaQEHzEL
 TovBQ++joX2Pv3mll30wUyhV8em8wa6JXA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 16, 2012 at 06:19:08PM +0900, Alex Courbot wrote:
> On 08/16/2012 04:42 PM, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Thu, Aug 16, 2012 at 03:08:55PM +0900, Alexandre Courbot wrote:
[...]
> >>+Usage by Drivers and Resources Management
> >>+-----------------------------------------
> >>+Power sequences make use of resources that must be properly allocated =
and
> >>+managed. The power_seq_build() function builds a power sequence from t=
he
> >>+platform data. It also takes care of resolving and allocating the reso=
urces
> >>+referenced by the sequence if needed:
> >>+
> >>+  struct power_seq *power_seq_build(struct device *dev, struct list_he=
ad *ress,
> >>+                                    struct platform_power_seq *pseq);
> >>+
> >>+The 'dev' argument is the device in the name of which the resources ar=
e to be
> >>+allocated.
> >>+
> >>+The 'ress' argument is a list to which the resolved resources are appe=
nded. This
> >>+avoids allocating a resource referenced in several power sequences mul=
tiple
> >>+times.
> >>+
> >>+On success, the function returns a devm allocated resolved sequence th=
at is
> >>+ready to be passed to power_seq_run(). In case of failure, and error c=
ode is
> >>+returned.
> >>+
> >>+A resolved power sequence returned by power_seq_build can be run by
> >>+power_run_run():
> >>+
> >>+  int power_seq_run(power_seq *seq);
> >>+
> >>+It returns 0 if the sequence has successfully been run, or an error co=
de if a
> >>+problem occured.
> >>+
> >>+There is no need to explicitly free the resources used by the sequence=
 as they
> >>+are devm-allocated.
> >
> >I had some comments about this particular interface for creating
> >sequences in the last series. My point was that explicitly requiring
> >drivers to manage a list of already allocated resources may be too much
> >added complexity. Power sequences should be easy to use, and I find the
> >requirement for a separately managed list of resources cumbersome.
> >
> >What I proposed last time was to collect all power sequences under a
> >common parent object, which in turn would take care of managing the
> >resources.
>=20
> Yes, I remember that. While I see why you don't like this list,
> having a common parent object to all sequences will not reduce the
> number of arguments to pass to power_seq_build() (which is the only
> function that has to handle this list now). Also having the list of
> resources at hand is needed for some drivers: for instance,
> pwm-backlight needs to check that exactly one PWM has been
> allocated, and takes a reference to it from this list in order to
> control the brightness.

I'm not complaining about the additional argument to power_seq_build()
but about the missing encapsulation. I just think that keeping a list
external to the power sequencing code is error-prone. Drivers could do
just about anything with it between calls to power_seq_build(). If you
do all of this internally, then you don't depend on the driver at all
and power sequencing code can just do the right thing.

Obtaining a reference to the PWM, or any other resource for that matter,
=66rom the power sequence could be done via an explicit API.

> Ideally we could embed the list into the device structure, but I
> don't see how we can do that without modifying it (and we don't want
> to modify it). Another solution would be to keep a static mapping
> table that associates a device to its power_seq related resources
> within power_seq.c. If we protect it for concurrent access this
> should make it possible to make resources management transparent.
> How does this sound? Only drawback I see is that we would need to
> explicitly clean it up through a dedicated function when the driver
> exits.

I don't think that's much better. Since the power sequences will be very
tightly coupled to a specific device, tying the sequences and their
resources to the device makes a lot of sense. Keeping a global list of
resources doesn't in my opinion.

> >>+static int power_seq_step_run(struct power_seq_step *step)
> >>+{
> >>+     struct platform_power_seq_step *pdata =3D &step->pdata;
> >>+     int err =3D 0;
> >>+
> >>+     switch (pdata->type) {
> >>+     case POWER_SEQ_DELAY:
> >>+             usleep_range(pdata->delay.delay_us,
> >>+                          pdata->delay.delay_us + 1000);
> >>+             break;
> >>+#ifdef CONFIG_REGULATOR
> >>+     case POWER_SEQ_REGULATOR:
> >>+             if (pdata->regulator.enable)
> >>+                     err =3D regulator_enable(step->resource->regulato=
r);
> >>+             else
> >>+                     err =3D regulator_disable(step->resource->regulat=
or);
> >>+             break;
> >>+#endif
> >>+#ifdef CONFIG_PWM
> >>+     case POWER_SEQ_PWM:
> >>+             if (pdata->gpio.enable)
> >>+                     err =3D pwm_enable(step->resource->pwm);
> >>+             else
> >>+                     pwm_disable(step->resource->pwm);
> >>+             break;
> >>+#endif
> >>+#ifdef CONFIG_GPIOLIB
> >>+     case POWER_SEQ_GPIO:
> >>+             gpio_set_value_cansleep(pdata->gpio.gpio, pdata->gpio.ena=
ble);
> >>+             break;
> >>+#endif
> >>+     /*
> >>+      * should never happen unless the sequence includes a step which
> >>+      * type does not have support compiled in
> >
> >I think this should be "whose type"? I also remember commenting on the
> >whole #ifdef'ery here. I really don't think it is necessary. At least
> >for regulators I know that the functions can be used even if the
> >subsystem itself isn't supported. The same seems to hold for GPIO and we
> >can probably add something similar for PWM.
>=20
> Actually I kept them because I don't really like the empty function
> definitions in the regulator framework. They all return 0 as if the
> function completed successfully - here we should at least warn the
> user that proper support for that resource is missing.
>=20
> >
> >It might also be a good idea to just skip unsupported resource types
> >when the sequence is built, accompanied by runtime warnings that the
> >type is not supported.
>=20
> Agreed.

If you do this, then I think the above #ifdef'ery becomes obsolete
because any errors that could potentially be hidden have already been
caught when the list was built.

Thierry

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQLMLzAAoJEN0jrNd/PrOhgLEP/AwkfHRlQ/IFdAYFDDhQuhI5
u7L2DLROBm7fIQpu2muXBbI+mfzPPN7fnQRrWbqWICAAsuKEEAlqDctfK2HfKBtC
N4TCaSp2oJ9AfhKJXuqaGfScYGOIAT0/cuGC5RFmLVfj9A/POSXrnE/darZqPJJq
O+AR2+nSdsIr7ms3rDfH8xOLLof7DqcLiIyiOWrlX7T+4JXiZiqQ2imzQ1GRRndO
9PySg0D2Q+BcNS6qyXMjDhtEBH/UHl1Bc5+aregtFCbHCuwq6R50l+1LSNDGRFhX
zaHRRB3UySu3Z3EQHTORcQOdgZIJfEuvYdOVgdajMYYL6ibw9l2gL/anzVYhxEy6
7AaOwIud0w/avyQr/ZTKHxEi0V8U1DqMtFBg9PW0KpJvGo0aHZThhn6lfUC5MZCn
YAyvYgj7UVVXXggKmEh+UI4t9/nw3Y269iEwhQmIna0+yKolPXjt5Kc/mNzjJ5iD
Pa0q7H99pmRZ0c0enc2iRj/5CAJYu1j5klR3hFcpGvinkjQefHVUec7JrLcgg7Nb
RU1KgRi2qaSjU5xoVXINYndl7klrK+JC33dodMOCZ0t4HUuMO7KJXfQjXA7RddK7
k7p/5Pd9LlKBPz8i4SAQ+I5XxrD+v1dH27w4n4oieF0rLrbf9G80Es12o/P5INtx
QJL4mf9cC8zuXYnT0Uwx
=ZgR6
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
