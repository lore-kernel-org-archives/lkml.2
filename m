Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2LMCpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:45:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab2LMCps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:45:48 -0500
Date: Thu, 13 Dec 2012 13:45:34 +1100
From: NeilBrown <neilb@suse.de>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Erickson <marathon96@gmail.com>, <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: add pwm driver using dmtimers.
Message-ID: <20121213134534.0cd32544@notabene.brown>
In-Reply-To: <50C8AED2.4040204@ti.com>
References: <20121212192430.50cea126@notabene.brown>
	<20121212113145.GA23598@avionic-0098.adnet.avionic-design.de>
	<50C8AED2.4040204@ti.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+jRewPJj3fv1Iceo6EM4oKq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+jRewPJj3fv1Iceo6EM4oKq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Dec 2012 10:20:34 -0600 Jon Hunter <jon-hunter@ti.com> wrote:

>=20
> On 12/12/2012 05:31 AM, Thierry Reding wrote:
> > On Wed, Dec 12, 2012 at 07:24:30PM +1100, NeilBrown wrote:
>=20
> [snip]
>=20
> >> +static int omap_pwm_enable(struct pwm_chip *chip, struct pwm_device *=
pwm)
> >> +{
> >> +	struct omap_chip *omap =3D to_omap_chip(chip);
> >> +	int status =3D 0;
> >> +
> >> +	/* Enable the counter--always--before attempting to write its
> >> +	 * registers and then set the timer to its minimum load value to
> >> +	 * ensure we get an overflow event right away once we start it.
> >> +	 */
> >=20
> > Block comments should be in the following format:
> >=20
> > 	/*
> > 	 * foo...
> > 	 * bar...
> > 	 */
> >=20
> >> +
> >> +	omap_dm_timer_enable(omap->dm_timer);
> >> +	omap_dm_timer_write_counter(omap->dm_timer, DM_TIMER_LOAD_MIN);
> >> +	omap_dm_timer_start(omap->dm_timer);
> >> +	omap_dm_timer_disable(omap->dm_timer);
> >=20
> > So omap_dm_timer_disable() doesn't actually stop the timer? It just
> > disables the access to the registers?
>=20
> I thought this looked odd too ;-)
>=20
> So what is going on here is that omap_dm_timer_start() calls
> omap_dm_timer_enable() but does not call omap_dm_timer_disable(). So the
> last disable really just complements the first enable (ie. decrements
> the use count), but the timer will not actually be disabled, because the
> start has called an extra enable.
>=20
> These four function calls can be replaced by one call to
> omap_dm_timer_set_load_start() and I think that will be much clearer and
> concise.

So it now reads:


	/*
	 * Set the timer to its minimum load value to ensure we get an
	 * overflow event right away once we start it.
	 */

	omap_dm_timer_set_load_start(omap->dm_timer, true, DM_TIMER_LOAD_MIN);


Certainly more concise - thanks.


>=20
> In general, it should not be necessary to call these
> omap_dm_timer_enable/disable APIs directly. I am not sure what the
> history is or if there is a use-case that really requires this. So in
> the future may be I should make them static so they cannot be used
> directly :-)

I've removed the other instance of these calls - in omap_pwm_config.


Thanks,
NeilBrown

--Sig_/+jRewPJj3fv1Iceo6EM4oKq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUMlBTjnsnt1WYoG5AQI3FBAArOTN+D8oCyj2CcbWCaKwIeRvkNVL7B7K
GtqMTFObDsev5RJRtW93S5B+cxKPsQovTpu3KxVTKXPN2BXLHZ5TBuG6ZYrOSE2R
raZykojOBe6dzvIVf2omqPyLTDlWGM+R9pGnMim2a2mv8rao5LcVzRKv2NcFpeW9
o9k6bblgpkNaCYxYj48cCcPvLKr/SIL7dVoZgXwrQWPvj7ljPLhrgVJI0Bz7OLpG
A8OXyxE8lLRUy8VVBDk7zx19vEfQ2fJp5gI074jOWrJNgEGMEdTAY0Rcl/56Ee6t
Q1sx0pxZCJdE0U2eIO0iEazQOBeEThiLC1knKzRSilrksn8kuTmVm/lF/1zbSCqK
V2/JbX0qFPgKr5Yn8/OJVUI1Y3g/sVezTEt/3IyXT0+6s258J1Q/chuQYHVaAGsW
Y0x1gmU/Kxtai+0n6p165jDGrsesnykVie0QGP0q2fxUVBFlY/zQzIGQNXhkzYte
LSh0ZDNMmLqRurFOxQLw5CLU1jmQAbC2maLvRY9CqUwji7kOVsDNHZqNw5IR9MgS
U9FYFASMoxM0WwjYFGP1Y+6BRwIK8CHcumr9Xqt2Y52LMUEFMNjPDdJQYOymLedU
QIe/a/VShwHDFSQdYTN7CqSU+jMxp0y/TdR2CuO9hICqmG0wBYkYbLObbGGtu6i0
rtKegC9Fv4U=
=SGx0
-----END PGP SIGNATURE-----

--Sig_/+jRewPJj3fv1Iceo6EM4oKq--
