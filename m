Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2JIMsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:48:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62522 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2JIMse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:48:34 -0400
Date: Tue, 9 Oct 2012 14:48:30 +0200
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
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH 1/2] pwm: pwm-tiecap: Add device-tree binding support for
 APWM driver
Message-ID: <20121009124830.GA25493@avionic-0098.mockup.avionic-design.de>
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
 <1348658863-29428-2-git-send-email-avinashphilip@ti.com>
 <20121002060014.GA4298@avionic-0098.mockup.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E9CA1E8@DBDE01.ent.ti.com>
 <20121008133951.GA26525@avionic-0098.mockup.avionic-design.de>
 <518397C60809E147AF5323E0420B992E3E9CA82E@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <518397C60809E147AF5323E0420B992E3E9CA82E@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:SHr+WQklhT70bozQv2JWzY6Fjy3zq1Do6UEm6qi/mF4
 pAuYBtnNWvl9cpGxCpsjSc1rpdDEywe9czb1GYgNrw/nTTJfu3
 oZneWmpZtntoCP8YpzoN6tnZcaJMZ62r2jHgp97cS6HuPvWCNe
 gFTmTojV4SmopvyWOrn1ifoW27ICLo6vYVK0pn3KBkRoa7w48c
 xWGsKwGB0zmXBoRltrQVHuQkFv/tUJ2WZp1+5SKgMv8rtMsZhm
 niYBP1teo/TYvIqGVmk4FZeEf0QuhK6yiPoIYVbZyvVLr60HhU
 m93TpKSmPYJF5IYHaLR4zVsDInjvfe3NXlPvCc0wwR3tatmYN0
 JA82bdhVunZNOhe+HiMUqyqb3kqig2/SIJ2KnXK2h9pZ8UZD9D
 RNq/RiVJk8MmgTqUzgjw7q5+kbudDfXboviMlIwz1wrKWfy0Hl
 LSj/o
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 09, 2012 at 12:36:53PM +0000, Philip, Avinash wrote:
> On Mon, Oct 08, 2012 at 19:09:51, Thierry Reding wrote:
> > On Mon, Oct 08, 2012 at 01:31:19PM +0000, Philip, Avinash wrote:
> > > On Tue, Oct 02, 2012 at 11:30:14, Thierry Reding wrote:
> > > > On Wed, Sep 26, 2012 at 04:57:42PM +0530, Philip, Avinash wrote:
> > [...]
> > > > > @@ -231,13 +290,56 @@ static int __devinit ecap_pwm_probe(struct =
platform_device *pdev)
> > > > >  	}
> > > > > =20
> > > > >  	pm_runtime_enable(&pdev->dev);
> > > > > +
> > > > > +	/*
> > > > > +	 * Some platform has extra PWM-subsystem common config space
> > > > > +	 * and requires special handling of clock gating.
> > > > > +	 */
> > > > > +	if (pdata && pdata->has_configspace) {
> > > > > +		r =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> > > > > +		if (!r) {
> > > > > +			dev_err(&pdev->dev, "no memory resource defined\n");
> > > > > +			ret =3D -ENODEV;
> > > > > +			goto err_disable_clock;
> > > > > +		}
> > > > > +
> > > > > +		pc->config_base =3D devm_ioremap(&pdev->dev, r->start,
> > > > > +				resource_size(r));
> > > > > +		if (!pc->config_base) {
> > > > > +			dev_err(&pdev->dev, "failed to ioremap() registers\n");
> > > > > +			ret =3D -EADDRNOTAVAIL;
> > > > > +			goto err_disable_clock;
> > > > > +		}
> > > >=20
> > > > Isn't this missing a request_mem_region()? I assume you don't do th=
at
> > > > here because you need the same region in the EHRPWM driver, right?
> > >=20
> > > request_mem_region() is avoided as this region is shared across PWM
> > > sub modules ECAP & EHRPWM.=20
> > >=20
> > > > This should be indication enough that the design is not right here.
> > > > I think we need a proper abstraction here. Can this not be done via
> > > > PM runtime support? If not, maybe this should be represented by
> > > > clock objects since the bit obviously enables a clock.
> > >=20
> > > It is not done as part of PM runtime as this is has nothing to
> > > do with clock tree of the SOC. The bits we were enabling here
> > > should consider as an enable of the individual sub module as
> > > part of IP integration. Hence we were handling these subsystem
> > > module enable in the driver itself.
> >=20
> > My point remains valid: you shouldn't be able to access the same
> > register through two different drivers. That's one of the reasons, if
> > not the only reasen, why the request_mem_region() function exists. I
> > think you should add some abstraction to provide this functionality to
> > the drivers. I assume that eventually there will be more than just the
> > PWM cores that require access to this register.
>=20
> Enabling of PWM sub modules from CONFIG space is only present in AM33xx
> as part of IP integration (ECAP, EHRPWM & EQEP).
>=20
> Enabling of sub modules (ECAP, EHRPWM & EQEP) should do in CONFIG space.=
=20
> Hence sub module drivers are accessing CONFIG space without reserving it=
=20
> Individually from drivers (request_mem_region()).
>=20
> Can you describe/point how it can be handled in a separate Abstraction la=
yer
> as this is shared across ECAP, EHRPWM & EQEP (EQEP driver is not yet avai=
lable).

Perhaps something like a global function to enable and disable the
clocks would be enough. You could for instance have a driver that
requests the config space memory region and provides this global
function so that it can be used by the ECAP, EHRPWM and EQEP.

A more elaborate scheme would possibly involve making the new device a
parent of the ECAP, EHRPWM and EQEP devices and have their drivers
lookup the parent to determine which configurator device to operate on.

Thierry

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQdB0dAAoJEN0jrNd/PrOhuEUQAKH+erxs3ev55H0NBvjWV7lu
DiR/PlG1dGgpQUZ0qZdFFBoEyspq2iJ9LokHxBMpeG304tD8QBqLgYOIGNG1xoVO
qKTvLncoyo9dqoX/R5EpiVxHr+aexm7gKaWayAjgFSis9e2ZKF+7DvBaXYSK29Ck
n1v6pI8mpV44dUeWnhfpbIRLxJGlwivS+jbKru+d7He25aiTn2tLBR3x/SlSShAj
g4/hpjxA5ckZ5sDHfqf32XYp041fY6OWN38TskJFFsLl4RwcvO+sXPa2k8wDKkwy
Nm4H7M3l1NdWmSPRUq92BuFt14q2KKpGPkCop7X4YauObx1tXwUnMizGCbAD0nV7
Bwg2Ll/NyEnN+n5OJrhXoU4f8kiDKSfcXXlnsT8vc27ocexynvcqHjh303IfFL/Y
Orsw2+3wW/FE3lpR4o1YrvdlDwsqpfZ/uj97ERWXacYwZmSh5GLtVEwxB3LBJ3+b
t3RIvzfnsjNXKnLoYTr/onolHsZXiXSAXBI+4WpKXDeH4pTHz1/26Tb50F6on8uY
ov3GXHinA9JPjdw4Dcqgc/QBluxQjZuIeBhZIKLvtlsuEGD2Wx6aK1GDKZdmi7Jd
BF4jova96Hmbvcs0/dPPIWQUZJ6y5iCm2o/tKk0Xt2gGOdCoVZXjC98nboIsZnzW
bt7pxv2TN9a5c2yoMhLx
=ypgM
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
