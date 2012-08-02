Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2HBIWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 04:22:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2HBIWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 04:22:07 -0400
Date: Thu, 2 Aug 2012 10:21:57 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
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
Message-ID: <20120802082157.GA14866@avionic-0098.adnet.avionic-design.de>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <50170EA0.1010408@wwwdotorg.org>
 <501A338D.7080105@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <501A338D.7080105@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:XQ3fRF6vX0d2UrZIUgtrzq1XrgYa5J1aolf5HCoN2W7
 Gpuqmm6elIo/KFfvDmmUAx45DbYVvaMfQ2mUhVc1HRQlGIX/+w
 EuOmajc0vRGAxIA7Nek9BTjOnPORyeCj9Cqd9Jg87Dy77wY/Wg
 /QOx8K44OXD3Rl4RV6j8bAfQzYSWDP7W/7Xlvf8UTqWv/MWkWn
 EJdC7xGwQ4Y/lfad5AK45sTfXgV7jZsE69AsmDWi+4DPSrPItw
 3hEyg6PVXMrBTIarf3mfdCwaQ1rgsEoXNa8ygooly0QeOx9/hR
 TW6E6VIR0vholrUS7y1KcHkjgFZCkRWWJerC5NEg8RGUaIW0AJ
 xUnnf0TejB0U0eT4diJldsGty30moFegLN5N9ugd7eK3wUak/V
 eLCeCGJ1Pb4fQxRZ4vTvGIu+QWLf0bMv9z1YwqX0C84ATrRIkm
 IcIHa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 02, 2012 at 05:00:13PM +0900, Alex Courbot wrote:
> On 07/31/2012 07:45 AM, Stephen Warren wrote:
> >Oh I see. That's a little confusing. Why not just reference the relevant
> >resources directly in each step; something more like:
> >
> >		gpio@1 {
> >			action =3D "enable-gpio";
> >			gpio =3D <&gpio 1 0>;
> >		};
> >
> >I guess that might make parsing/building a little harder, since you'd
> >have to detect when you'd already done gpio_request() on a given GPIO
> >and not repeat it or something like that, but to me this makes the DT a
> >lot easier to comprehend.
>=20
> I tried to move towards having the phandles directly in the
> sequences themselves - that reminded me why I did not do that in the
> first place. Let's say we have a sequence like this (reg property
> omitted on purpose):
>=20
> 	power-on-sequence {
> 		step@0 {
> 			regulator =3D <&backlight_reg>;
> 			enable;
> 		};
> 		step@1 {
> 			delay =3D <10000>;
> 		};
> 		step@2 {
> 			pwm =3D <&pwm 2 5000000>;
> 			enable;
> 		};
> 		step@3 {
> 			gpio =3D <&gpio 28 0>;
> 			enable;
> 		};
> 	};
>=20
> The problem is, how do we turn these phandles into the resource of
> interest. The type of the resource can be infered by the name of the
> property. The hard part is resolving the resource from the phandle -
> it seems like the API just does not allow to do this. GPIO has
> of_get_named_gpio, but AFAIK there are no equivalent for regulator
> consumer and PWM: the only way to use the DT with them is through
> get_regulator and get_pwm which work at the device level.
>=20
> Or is there a way that I overlooked?

No, you are right. Perhaps we should add exported functions that do the
equivalent of of_pwm_request() or the regulator_dev_lookup() and
of_get_regulator() pair.

Thierry

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQGjilAAoJEN0jrNd/PrOhWQIP/ia8nbamFqB7B7+uXDeV7vqy
GRrn/b9KIIWdIIij79MoJKaoljC2Cwf+i5gviN5IrbN/wvLlZtPXLbO6du3u+YF6
4+b48S8oEysitxKCw3/9t1GGRZVbcLuC2ulHr+GOAsH42J5tD/X8NsSOPBMiL6Zm
jqNP56WcuDAyAG1maCu3cBX66rp8K3ErfOb6QveFmzAWZKGajvQY+/bkdp+bQRPX
gAe7SOqVp1n9u4Tj8gqJC6UQyp+hDulDEZ4yQx/fyRJbxuy1i0gu+33FWhFSVolQ
+aHDIhSZdClv9AnCp2HM8FrXh4BWTh2h31wu+P3h+IV2D0OzQ45SJ/uptMPkwhoT
CjeGIsDxfOI7yriCUxZ65zHnhdlPRJP9FSF+5qknRthgxP4LCidEcdMidPU5lLQa
ditQPl8iiuMq3gDr/GTkOQpiSThAP6GOqhdRVWz8wJgnxKibKMMNvV8mgz+kfMSW
N+N38Lj/njak7rIqkdrDilxrtpqFJq3kqOY97O0wVGdelpx8lT8Qu7NoOIsanDdh
IL1UO5pXgCX1QzS/M++hNnx6riRjIUood1cYyzyd8J/qOY9Sl9MT+9gOMcwfRevh
oaR18VD5uPrSxtYufrvO/tXFB90hucHfosEnDuKP3uB45tUhddgRsUi1iKIjr7MO
yEb1u6FLcbdCIbqD49rQ
=HfNb
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
