Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab3AIJYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 04:24:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab3AIJYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 04:24:07 -0500
Date: Wed, 9 Jan 2013 10:23:52 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
Message-ID: <20130109092352.GA28037@avionic-0098.adnet.avionic-design.de>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
 <1357371910-3164-3-git-send-email-ldewangan@nvidia.com>
 <20130105080658.GA1315@core.coreip.homeip.net>
 <20130106192739.GA11566@avionic-0098.adnet.avionic-design.de>
 <20130106195748.GA28212@core.coreip.homeip.net>
 <20130109070745.GA12782@avionic-0098.adnet.avionic-design.de>
 <20130109091939.GA4369@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20130109091939.GA4369@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:EcEUL6XuWUZFOqB8u52EJydGtNaQ2KkUiNj4ldJarfT
 EbCWxFD0Q/fP5h6k4LhnGDW/aVbT713pOkYRokvMUpA15R165O
 Mjf8Jsvke146zGfrKFYN17uhKDzDbN5UttZwfn3UGHdNsGHLTK
 UQVNAtEe2yVkugPxyesjH2QWMGIcZnEq6ikDoxg4H6MzGyE2Wi
 xZq1frHCJDmiOqxf11dorgjRrs9DEGD8y0QeOQylUAfVn0ReTV
 590LxjtW9Kkfg5l0Cw39MJjnoksmXpm56kzLsSGjkIQqwsR9iE
 iTvnsFeNKeHMvdTb5OPkFiSxewUPLGpF9VGW6QfO+Pya7jKcIL
 ph+x4f2TSQmQqEl82wHVJnk8QgsOcNFes0PU/Cslyj0B48Ej0G
 +8M2677FXqPoZTnuRDCypVcPSWDrLZJFlc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09, 2013 at 01:19:39AM -0800, Dmitry Torokhov wrote:
> On Wed, Jan 09, 2013 at 08:07:45AM +0100, Thierry Reding wrote:
> > On Sun, Jan 06, 2013 at 11:57:48AM -0800, Dmitry Torokhov wrote:
> > > On Sun, Jan 06, 2013 at 08:27:39PM +0100, Thierry Reding wrote:
> > > > On Sat, Jan 05, 2013 at 12:06:58AM -0800, Dmitry Torokhov wrote:
> > > > > On Sat, Jan 05, 2013 at 01:15:08PM +0530, Laxman Dewangan wrote:
> > > > [...]
> > > > > > @@ -735,25 +738,16 @@ static int tegra_kbc_probe(struct platfor=
m_device *pdev)
> > > > > >  	spin_lock_init(&kbc->lock);
> > > > > >  	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned =
long)kbc);
> > > > > > =20
> > > > > > -	res =3D request_mem_region(res->start, resource_size(res), pd=
ev->name);
> > > > > > -	if (!res) {
> > > > > > -		dev_err(&pdev->dev, "failed to request I/O memory\n");
> > > > > > -		err =3D -EBUSY;
> > > > > > -		goto err_free_mem;
> > > > > > -	}
> > > > > > -
> > > > > > -	kbc->mmio =3D ioremap(res->start, resource_size(res));
> > > > > > +	kbc->mmio =3D devm_request_and_ioremap(&pdev->dev, res);
> > > > > >  	if (!kbc->mmio) {
> > > > > > -		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> > > > > > -		err =3D -ENXIO;
> > > > > > -		goto err_free_mem_region;
> > > > > > +		dev_err(&pdev->dev, "Cannot request memregion/iomap address\=
n");
> > > > > > +		return -EADDRNOTAVAIL;
> > > > >=20
> > > > > Erm, no, -EBUSY please.
> > > >=20
> > > > EADDRNOTAVAIL is the canonical error for devm_request_and_ioremap()
> > > > failure. The kerneldoc comment in lib/devres.c even gives a short
> > > > example that uses this error code.
> > >=20
> > > I am sorry, but I do not consider a function that was added a little
> > > over a year ago as a canon. If you look at the uses of EADDRNOTAVAIL =
it
> > > is used predominantly in networking code to indicate that attempted
> > > _network_ address is not available.
> >=20
> > EBUSY might be misleading, though. devm_request_and_ioremap() can fail
> > in both the request_mem_region() and ioremap() calls. Furthermore it'd
> > be good to settle on a consistent error-code instead of doing it
> > differently depending on subsystem and/or driver. Currently the various
> > error codes used are:
> >=20
> > 	EBUSY, EADDRNOTAVAIL, ENXIO, ENOMEM, ENODEV, ENOENT, EINVAL,
> > 	EIO, EFAULT, EADDRINUSE
> >=20
> > Also if we can settle on one error code we should follow up with a patch
> > to make it consistent across the tree and also update that kerneldoc
> > comment. I volunteer to do that if nobody else steps up. I'm also Cc'ing
> > Wolfram (the original author), maybe he has some thoughts on this.
> >=20
>=20
> If you going to change all drivers make devm_request_and_ioremap()
> return ERR_PTR()-encoded errors and then we can differentiate what
> part of it failed.

Yeah, that thought also crossed my mind. I'll give other people some
time to comment before hurling myself into preparing patches.

Thierry

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7TcoAAoJEN0jrNd/PrOhIqMQAMBhD/S8tk7+4S0NYELrA/yn
upCtFa68MncU9wAvuLAz7lvhuLwdB+rTTzickEgIOAR/Q7BqYNJ5baH1vC5sTPe8
0VSOnO/3ZpVps+kaZCXrpEN2rDonfvjIkI0Z3ysim9rBegeednip04QV4IgAzjgO
ZF+Cz7/7DNJJM/JcVlz+eAPiwPM1RjHnAYfhk1OnAJsekFw0s33RqUXKpxizDenI
QVg0+vXO6JXtWRT+wCYQVeDMWVMkNQnX8SmoX/Z+qZiGRMcEpt0s9wW4nW4/41ip
1KEsN7LL9wR1K0CA76M+MvBGjG9jd7829j7aR+1XOw/6iUO8MHD/oMEnR+rL/VaJ
Rem9QBly5P8QWt0YvL+YgGLjuNoFHgWoM9GDXRuoJCjbqzmAnZG1Gyh6Fm3UKxVA
WxithXn6DpZmLQ9sdAY21oJeF82K6IaYuTcx5SVIrmOrd5OAB4W0tCI6e1STqZIk
DwKnq+hxWV/hbmZNAwmOH4ehVOjMwl8nE/ciwJuChUJDkj0JCYe3NPSWcKKRyB/g
hfKtKqjlGKRqqwzOQ8NMVPIThVdwb59u+jxhlsgPRHZwXCKrYxiFjcHB92Bu/WRS
AsYYu+ibCxLUkwB+3Zie3T80Gw5fV9xQnpi3WRT3cRvrwYNpgagL/RFtPnW5XxCr
eTB8ACQunRliKECCrvMX
=X3wL
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
