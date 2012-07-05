Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413Ab2GEKj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:39:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43284 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932084Ab2GEKjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:39:24 -0400
Date: Thu, 5 Jul 2012 11:39:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
Message-ID: <20120705103922.GO4111@opensource.wolfsonmicro.com>
References: <20120704104840.GJ24458@pengutronix.de>
 <4FF43692.2040805@nvidia.com>
 <20120704130056.GC30009@pengutronix.de>
 <4FF45DDF.9000306@nvidia.com>
 <20120704152451.GA7333@sirena.org.uk>
 <4FF4FDC0.8020405@nvidia.com>
 <20120705062011.GI30009@pengutronix.de>
 <4FF53368.6090805@nvidia.com>
 <20120705064742.GL30009@pengutronix.de>
 <4FF5459F.5090201@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HJakWL7yBo69DI1O"
Content-Disposition: inline
In-Reply-To: <4FF5459F.5090201@nvidia.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HJakWL7yBo69DI1O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 04:43:27PM +0900, Alex Courbot wrote:

> One could actually question whether the whole regulator/gpio thing
> should be supported at all with platform data. The platform
> interface can use the function hooks in order to implement whatever
> behavior it wants when the light needs to be powered on and off. The
> reason for introducing optional regulator/gpio parameters is because
> the DT cannot use these. Since I have no plan to remove these
> function hooks, making the regulator/gpio option available in
> platform data might be redundant. Any thought about this?

Well, no - it's also done because even if you're not using device tree
(as on most of the architectures we support...) it's not good to have to
cut'n'paste code everywhere.  This means that we want to be able to
provide things like GPIOs and regulators via data which means we have
exactly the same situation as we do with device tree.

> >Right now the regulator core will just return -EPROBE_DEFER in both
> >cases. This could easily be changed in the regulator core.

> Could this be because the regulator core cannot make the difference
> between a not-yet-available regulator and a missing one?

Yes.

--HJakWL7yBo69DI1O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9W7SAAoJEBus8iNuMP3dArsP/1k3AWeN8fmHIteh+WWru0gR
JYx6HXDkLWaxDFHW51WmXh8dWbaX4zOvPtaAJB1WrU3jHacVmaWAOqxTSLpKW8R3
IrA8kHmeE+nc1tbLbo0LfjCcVgd5lVJv/ZDO699LUYFtsbTYLJzF3/5G7w2JX0hz
wnEYnX1IAL0exK2JijgdYSmvedHkw3BsQvmAVJyXRwFVs6WP2/rIQSIa7fBGU6DA
++56rF7UopWQMn7kUQLyDkA4OorHWpzkxi4blCMH8VarYEtOwKR+Bto/4Dl8zpII
9ny5cmWtY8PopXkXcf7qTLPbBUoCPkHr+rnyGAsiv+lX2FrwF8R0cKe5K5AnWpz7
UuN0TaveGLaK4HwiLiL+O3mgHkqL+QpTqAu14E2ahyrhvWAd0hBU+oPv8hjdOMs5
gdF4yn7v4faz4zD0Av2Ny3EGaWJMp3OJYMBx81jdwAid0ADtZFw3e9GE1PAjehp3
j7Sn0uX6c7Mm/YG649ertSkr6yviCcvv2Vm891jLiFNb1DEu67mmWxxr4w0o2gXV
VvAQUl8sjCHFQCPEu3lrxuwA9GiK7Go3OAbH3sayyX0sg4SOUDCikhRzT8SV56X8
LQTKspccosyxcGur/H4XEtbDvmE+FeFW8jpBMtbGSgiQUmyYWpoUaAlg2PQVIS9s
poeQ9wXGhGk1zmLcNp/r
=xqnS
-----END PGP SIGNATURE-----

--HJakWL7yBo69DI1O--
