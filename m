Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2JHNuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 09:50:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52932 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab2JHNuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 09:50:17 -0400
Date: Mon, 8 Oct 2012 15:50:08 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: Re: [PATCH 2/2] pwm: pwm-tiehrpwm: Add device-tree binding support
 for EHRPWM driver
Message-ID: <20121008135008.GB26525@avionic-0098.mockup.avionic-design.de>
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
 <1348658863-29428-3-git-send-email-avinashphilip@ti.com>
 <20121002061143.GB4298@avionic-0098.mockup.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E9CA1ED@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9CA1ED@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:sXEqkf1SyKtzLSVhVbgF9F4JoEeybHShQhqqvt5y0k6
 RbKj+cm8r9dqZ0is+az7b1AWxHj9Aqo/L2XRGxfXiUDU/1TDFQ
 bZPErueheqYMU7yQxf6UuPj7kjbUC1sGqB0UEvqUMv5I+OCqTR
 CjudyMKMn0eS4bdhR+VQbRCBH8zaaeUxjdKzq+W8Q+seXJwPwA
 alHZYHDTwIH3lUGfWz9mzcAivIwAOYz/UcWs46LfahkpIRJiP6
 v8UrnSdMLRmCBCQz/WAGDxiAurFFneN5SU6HPOkpLHpplh4aUB
 FGHS6N/ukro8uD0XvAjthe8GC+OSKKBXCbm7jeWenkSbBU/gAr
 Qh28CBmEmTk/bLIwd8+PYpObvPRE5ufEBx4S4RFHmNBaWDNJ1R
 237YbBWzXdkhueOlKr0p+jtOhtoTvGMkww=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 08, 2012 at 01:31:20PM +0000, Philip, Avinash wrote:
> On Tue, Oct 02, 2012 at 11:41:43, Thierry Reding wrote:
> > On Wed, Sep 26, 2012 at 04:57:43PM +0530, Philip, Avinash wrote:
[...]
> > > +- reg: physical base address and size of the registers map. For am33=
xx,
> > > +  2 register maps are present (EHRPWM register space & PWM subsystem=
 common
> > > +  config space). Order should be maintained with EHRPWM register map=
 as first
> > > +  entry & PWM subsystem common config space as second entry.
> > > +
> > > +Optional properties:
> > > +- ti,hwmods: Name of the hwmod associated to the EHRPWM:
> > > +  "ehrpwm<x>", <x> being the 0-based instance number from the HW spec
> >=20
> > I don't see where this property is used. There is no code in this patch
> > that parses it.
>=20
> This data used by omap_hwmod layer to create platform devices. This is pa=
rt
> of omap hwmod implementation.

Okay. I've heard about hwmod but I wasn't aware of how it was used in
the context of device tree.

> > > +static struct pwm_device *of_ehrpwm_xlate(struct pwm_chip *chip,
> > > +		const struct of_phandle_args *args)
> > > +{
> > > +	struct pwm_device *pwm;
> > > +
> > > +	if (chip->of_pwm_n_cells < PWM_CELL_SIZE)
> > > +		return ERR_PTR(-EINVAL);
> > > +
> > > +	if (args->args[0] >=3D chip->npwm)
> > > +		return ERR_PTR(-EINVAL);
> > > +
> > > +	pwm =3D pwm_request_from_chip(chip, args->args[0], NULL);
> > > +	if (IS_ERR(pwm))
> > > +		return pwm;
> > > +
> > > +	pwm_set_period(pwm, args->args[1]);
> > > +	pwm_set_polarity(pwm, args->args[2]);
> > > +	return pwm;
> > > +}
> >=20
> > This is an exact duplicate of the ECAP's of_xlate(). Maybe we should
> > make this part of the PWM core. If so it is probably safer to define the
> > values for the third cell as flags, where the polarity is encoded in bit
> > 0, and make the function handle this accordingly to allow other bits to
> > be added in the future.
>=20
> Custom of_xlate support is provided as suggested while the discussion of
> "Adding support for configuring polarity in PWM framework".
> https://lkml.org/lkml/2012/7/16/177
>=20
> without custom of_xlate() support, PWM drivers has to populate
> chip->of_pwm_n_cells =3D x;
> as this is hard coded to 2 in pwm/core.c.
>=20
> if (!chip->of_xlate) {
> 	chip->of_xlate =3D of_pwm_simple_xlate;
> 	chip->of_pwm_n_cells =3D 2;

It's absolutely fine to provide a custom implementation. All I'm saying
is that we should add a 3-cell variant of of_pwm_simple_xlate() instead
of having to duplicate it for every chip that supports inversion of the
polarity.

Maybe something like of_pwm_xlate_with_flags()?

Thierry

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQctoQAAoJEN0jrNd/PrOhiS0P/0FEV2hLcV4p3YfvgS9uuTJG
M6EWNV3w4AozIWRYAN+becyyD0haCfuzl18rz/ar7/F4N5S4zXRnzKeOupjqlYrh
mWDII3cqYOjgU4IBdnwsWETxRRjz86pR6O314wlf+SywKdRjDWriypwGE2/wXSZC
ZgNHoWfcog0oweFZD4PBLsgXomg0rjXLdgHMgF1MQry9w9F5Z7p3PGqPVFjBu6ov
OkLj2jdaWAN5376pn9YmjccE2p7k5BsumSRN70fPb0Tn/6rKNa5ZhEUJK8LAR0Jg
+uzpJmN2DJ4p7IxbVZEEpFTMXZWIMB1ub6p3MKHPLH0maLWKYDEuDmRSVSUsEtcV
gR3AoyHZHwsiWPI1mBBAJ0CIY/weIcHmqYh0dmlKV+5Lkq2Zj/tBuDMbigHytpfr
mDLjq3tsFyUhL7kJNETYuztPYOzlLdlYrnT7CqbuTF/dta3dj+F+ZNBRXnCTVn9J
DoO7XIklnf2I6P5rSzLKQgBS/Tu+dYhZxqR7kNJ2cB8RuX3kdnBq1zf7ExIbkhx1
uBl9tyE5JIFC6OipPz74jZtrZqGqKk3qTk/gs39pJ4nOjP7OcIEBL688iTf/Y4LA
MzMZOsaLSRG9Yo1yyUs9GrwVqIWozZ3/7H6yrM8pmKL32qz8wa6YNS8tGqQf1s42
FwuGrAVKsTMKiZ2rO8uD
=Vs2O
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
