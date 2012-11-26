Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab2KZJSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:18:07 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53123 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab2KZJSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:18:05 -0500
Date: Mon, 26 Nov 2012 10:17:57 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 3/3] pwm: New driver to support PWM driven LEDs on
 TWL4030/6030 series of PMICs
Message-ID: <20121126091756.GA8602@avionic-0098.adnet.avionic-design.de>
References: <1353405382-9226-1-git-send-email-peter.ujfalusi@ti.com>
 <1353405382-9226-4-git-send-email-peter.ujfalusi@ti.com>
 <20121123150412.GB16810@avionic-0098.adnet.avionic-design.de>
 <50B3288B.5020500@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <50B3288B.5020500@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:FxGps5wUdp6yTPBYb2IbY5kiRRwKYIqEhbKkuhBMEPO
 JOGUh9XTKIBFVf8OVst3J6QKVd45udRcMUKDpG4bFf0rGKBdag
 7WN4i8YILHtU96uNQyFN/RT5RfQiOq1tfnoQ0ggtGnN/lNXwQd
 3szR8NWGyCvBweg8vT6+peerSn4Yf6r86Nq4bbcz5agFCjs+rW
 q3Pkwpxb3rbYv6LlxvxkLXdtiBlR7+5tAH3eBEvuio4dnky1c2
 O63h1Ib+13Jth1fL6T5a+IeSgelYP4uteBdRV3SPgixhzCx7Sv
 bhk8OngGJAEOFhuwH58cFyZG/qmhhPiNmn8yFgzH31+BW3oSHV
 8rQS3P1e+KoAcJ3IV/0jz+ZV9qXB23sAw8iOwuvvXb+cWqmlAy
 oecB0hypVQW81a/YEMRFnGIcvpdxwO8jxw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 26, 2012 at 09:30:03AM +0100, Peter Ujfalusi wrote:
> On 11/23/2012 04:04 PM, Thierry Reding wrote:
> > On Tue, Nov 20, 2012 at 10:56:22AM +0100, Peter Ujfalusi wrote:
> >> The driver supports the following LED outputs as generic PWM driver:
> >> TWL4030 LEDA and LEDB (PWMA and PWMB)
> >> TWL6030 Charging indicator LED (PWM LED)
> >>
> >> On TWL6030 when the PWM requested LED is configured to be controlled b=
y SW.
> >> In this case the user can enable/disable and set the duty period freel=
y.
> >> When the PWM has been freed, the LED driver is put back to HW control.
> >>
> >> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> >> ---
> >>  drivers/pwm/Kconfig       |  10 ++
> >>  drivers/pwm/Makefile      |   1 +
> >>  drivers/pwm/pwm-twl-led.c | 303 +++++++++++++++++++++++++++++++++++++=
+++++++++
> >>  3 files changed, 314 insertions(+)
> >>  create mode 100644 drivers/pwm/pwm-twl-led.c
> >=20
> > Doesn't this belong in the drivers/leds subsystem? Besides that, the
> > same comments as for the previous patch apply. One additional note
> > below.
>=20
> The PINs itself are called as LED but they are PWMs at the end. If we
> represent them as PWMs they can be used for different purposes which is g=
oing
> to be needed for example in BeagleBoard, where the LEDA (PWMA) is used as=
 a
> GPO to enable/disable the USB host power.

Heh, that's an interesting use-case for a PWM. =3D)

> Also the removed 'twl6030-pwm' driver was only controlled the LED part of=
 twl6030.
> With this series I enable the use of the PWMs and the PWMs behind of the =
LED
> functions to give us flexibility on how we are using them.

Alright, we can keep it in the PWM subsystem then.

> >> +static struct platform_driver twl_pwmled_driver =3D {
> >> +	.driver =3D {
> >> +		.name =3D "twl-pwmled",
> >> +		.of_match_table =3D of_match_ptr(twl_pwmled_of_match),
> >> +	},
> >> +	.probe =3D twl_pwmled_probe,
> >> +	.remove =3D __devexit_p(twl_pwmled_remove),
> >=20
> > You didn't annotate twl_pwmled_remove() with __devexit, so __devexit_p
> > isn't needed here either.
>=20
> Oh yes, I have also received patches from a series which removes the
> _devexit_p() from the kernel.
> But should the __devexit need to be added to the remove function?

__devexit_p without a corresponding __devexit doesn't make sense. But as
all of __devinit, __devexit and __devexit_p will be removed sooner or
later, new code just shouldn't bother adding it. In this case, just drop
__devexit_p.

Thierry

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQszPEAAoJEN0jrNd/PrOhcg0QAKQgZDx/+Q9Z47mhJ2ENmzoz
89JNlgPkaWGp0fwAaO3Y3aO2db6wN8k4HYxmuS0A9KLPRSUJ2Ni/uCsSv6KwQiLc
9gtpDzFmitIx5eh08v3qZxEWG0UAfjjVjidJeEARjbMF3p2QYYUkX6LFXsC5djtb
Uh0yx4SJcz+fnzptsPfqoocMtLX3Op04ZklowGvvHjd60mx/N+/VAt3QBBWWlcq+
fn/V1Mp6sS218TFbeovfIlBYwi6XXTVggBWyzuEl9ksbI/qlRuvPEaTLkub0zLTl
wbkXRf06PJujSBk4eEZj48XKkXJS7/g1j7ZMqE6kIFH70aENBHgjxR7WzF+Bhv7p
d0mouKdOnUwBpB9HuscpA4/GWMmRfdIVk0oxhm/ftdPPDP2Y2gOWD6WQBed/ZOGI
5joWlAA1m1xLGEwjLkJ3C8tsk9ALMenDVrOGBHP6xz+5Z5v5sj54Knm+ve30C2LR
Q9MQbfpxMR0XsMWz/GtOEU8tvWeqHL2lPsku7RSDGmFJAP+jqNbK2fhro1mQ7jyY
irl+qnFVw//wzk79pweYDWjognsyV/KWbyS4+K4idsDWRbVXUA12/ZCVv4cneBEk
s2Pc9/EW1fc0sbcj4qB6QxaEUrj2onatqA7cYB1N/oiFJrvrNv+ayvYtx1b1gvTb
fpZnnfg+I1XIIjfyUPsR
=fcE/
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
