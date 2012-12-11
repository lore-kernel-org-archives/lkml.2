Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab2LKIgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 03:36:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51338 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2LKIgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 03:36:47 -0500
Date: Tue, 11 Dec 2012 09:36:35 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: Re: Re: [PATCH v3 1/4] leds: leds-pwm: Convert to use devm_get_pwm
Message-ID: <20121211083632.GC27084@avionic-0098.adnet.avionic-design.de>
References: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com>
 <1355133637-2784-2-git-send-email-peter.ujfalusi@ti.com>
 <20121211070307.GB8294@avionic-0098.adnet.avionic-design.de>
 <3193669.Hv54bBklsP@barack>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
Content-Disposition: inline
In-Reply-To: <3193669.Hv54bBklsP@barack>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3RhFi9H3rDbDz1LhTlcHfN//+CHFl7zQOxZVuEuzPO8
 QrfTql9Ce0LDOwG6nWo9BtMOlNN2zqHg/m/c4/4Eo8UK3XH/uL
 SS/Lje/wPEFKby2YvUa5xPN+2sOYSbkoJC6bFaMzqUBgezKOC7
 0bpNeGqaOpR3MhqnfJBT8WFpn6eVSg3fs58/Qpyue2vsNjGIe5
 CambortfCr5aHT5f4vrWgvgNrP4MSIFCYSeWqG+u3xYqRCsGNG
 r6Gv3xSmjF87FBKCoka0RNZ2i3VRUDBaAnw6hWxK/cDuhpSzfI
 Pzjfjnmt9PCmGvuOPGmna0+4s1h6Mx4GshWeJrZhsGcquAuWKE
 bHmlKFiYpvGEY506d8AB0yOAuWZ7j7+gQ2Fsp0yPUGMRHo3m6q
 GdZq8OSZhQTZTuMB6/PzkgrP7XzoA7blFtyL9KwsCTbyVzPR60
 PMxiz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 11, 2012 at 09:29:21AM +0100, Peter Ujfalusi wrote:
> On Tuesday 11 December 2012 08:03:07 Thierry Reding wrote:
> > On Mon, Dec 10, 2012 at 11:00:34AM +0100, Peter Ujfalusi wrote:
> > > Update the driver to use the new API for requesting pwm so we can take
> > > advantage of the pwm_lookup table to find the correct pwm to be used =
for
> > > the LED functionality.
> > > If the devm_get_pwm fails we fall back to legacy mode to try to get t=
he
> > > pwm.
> > >=20
> > > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > > ---
> > >=20
> > >  drivers/leds/leds-pwm.c  | 19 ++++++-------------
> > >  include/linux/leds_pwm.h |  2 +-
> > >  2 files changed, 7 insertions(+), 14 deletions(-)
> > >=20
> > > diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> > > index 2157524..351257c 100644
> > > --- a/drivers/leds/leds-pwm.c
> > > +++ b/drivers/leds/leds-pwm.c
> > > @@ -67,12 +67,11 @@ static int led_pwm_probe(struct platform_device *=
pdev)
> > >=20
> > >  		cur_led =3D &pdata->leds[i];
> > >  		led_dat =3D &leds_data[i];
> > >=20
> > > -		led_dat->pwm =3D pwm_request(cur_led->pwm_id,
> > > -				cur_led->name);
> > > +		led_dat->pwm =3D devm_pwm_get(&pdev->dev, cur_led->name);
> > >=20
> > >  		if (IS_ERR(led_dat->pwm)) {
> > >  	=09
> > >  			ret =3D PTR_ERR(led_dat->pwm);
> > >=20
> > > -			dev_err(&pdev->dev, "unable to request PWM %d\n",
> > > -					cur_led->pwm_id);
> > > +			dev_err(&pdev->dev, "unable to request PWM for %s\n",
> > > +				cur_led->name);
> > >=20
> > >  			goto err;
> > >  	=09
> > >  		}
> >=20
> > The commit message says that legacy mode is used as fallback if
> > devm_get_pwm() (that should really be devm_pwm_get() btw) fails but I
> > don't see where pwm_request() is called.
>=20
> Oh, true. The fallback has been removed based on earlier comment from Bry=
an=20
> Wu. I will correct the commit message.

I'm not so sure that's a good idea. After all there may still be users
who rely on the legacy behaviour.

Thierry

--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxvCQAAoJEN0jrNd/PrOhG/UQAIi2y/4nZ9jysjd/hUMvP2HF
3Q9HeQIhFBocZVzI5KweSvOTpdP8/zJtoVZOAQGatHNSZuUC4Tth53umPMe0C/7d
6pHeZaBt1sBJBw34kIr+AReL0+KM7iiGf+nmZAVM+ZjfoNagGzi9dqGoqyrvTSlM
K/P+EYom16Zq8VsK8kF/qo37rP4ltcQPjeSRHTrC0VLNrYYeRwi1+rLu9DQ8nmbe
fOJ6LGbn//9/B3p0OrHyTz16BeRxQABWxZzUZhXRRzfwfISWix3kMnIhTcGJskYL
3zjDnA/Ug6/aoBx1Vkc/vN6e5Az9I+jl4S1ocC7kvuj9KciEfffKHDPYxov6KiSe
yDqLHVR95CAC2+aeO/x8D3khf3Zfxt/wv7VwRqi17x8SAZKJG8EXn5ow13d/IXlJ
giLaeP3dTrHKrfVSOaLQ2Te3qxxpupj0MCOfQZQ8yTRLlwmjpzFVzxVxvkCF+fjn
XEFZLirHrVh6i01QTmMIo83Q3VN67Bhv551BQy4rzgBYzpU3++85sAuuqT3hHk58
TANQMQ4xoLhOshhUhv6Bm5rE90zJMwcVlBfxH/pDn/5LVEoFrl1+CPZtVYk8g6aK
GCrnQrF3FojrW+C5NnCtJIAVMUFp61b4oRWEb4Sj/YemdXp/JISDqRFUkwOO+WPl
iNIvBkiShCjwjzuY0rbn
=tKtb
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
