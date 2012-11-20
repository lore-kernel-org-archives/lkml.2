Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab2KTL7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:59:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:57105 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab2KTL7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:59:03 -0500
Date: Tue, 20 Nov 2012 12:58:53 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 3/3] pwm: New driver to support PWM driven LEDs on
 TWL4030/6030 series of PMICs
Message-ID: <20121120115840.GA2500@avionic-0098.adnet.avionic-design.de>
References: <1353405382-9226-1-git-send-email-peter.ujfalusi@ti.com>
 <1353405382-9226-4-git-send-email-peter.ujfalusi@ti.com>
 <50AB6F63.9040009@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <50AB6F63.9040009@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:GoAf6Uzme7xf5Hppdr+0Yd8D+7w4PzV3yZn7AFS9d/a
 pKsQ9YoGYOrigxpNxrrtggRRy2/pc64QV5wWCXqdwSkuIaH3QX
 LCLzHEvTLtajmw4raBzf6eBx/vmAAWZJx8a3Ko8WBl2/fK4vzh
 3D5SZ1GiuebTQQ0ERvG5N06B+10m7m9nJWtg2TI9W8Fw9G8N16
 vfOhxkpAskrAX+zKBMtnkTAtOlbz5ByfOY3WHpo+iGS1/pNpv8
 M/+zgPcpAFU+74lUCrpeGPrAMDknZ2Exp+lVNivfKVeIZnGCpv
 s+iL9mtEKYUhKqxve92wEjudtT36/3davh34FheGkC0YiXQygE
 1taB3FyJiZBWLnJ5phjoRgztMj0hYFlM+6qUqUT1T6XjZ50v5m
 MENvtcZ1q2eR17s0ezTEdhE0E/YkOxm+HE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 20, 2012 at 12:54:11PM +0100, Peter Ujfalusi wrote:
> On 11/20/2012 10:56 AM, Peter Ujfalusi wrote:
> > The driver supports the following LED outputs as generic PWM driver:
> > TWL4030 LEDA and LEDB (PWMA and PWMB)
> > TWL6030 Charging indicator LED (PWM LED)
> >=20
> > On TWL6030 when the PWM requested LED is configured to be controlled by=
 SW.
> > In this case the user can enable/disable and set the duty period freely.
> > When the PWM has been freed, the LED driver is put back to HW control.
> >=20
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> > ---
> >  drivers/pwm/Kconfig       |  10 ++
> >  drivers/pwm/Makefile      |   1 +
> >  drivers/pwm/pwm-twl-led.c | 303 ++++++++++++++++++++++++++++++++++++++=
++++++++
> >  3 files changed, 314 insertions(+)
> >  create mode 100644 drivers/pwm/pwm-twl-led.c
>=20
> ...
>=20
> > +static int twl4030_pwmled_config(struct pwm_chip *chip, struct pwm_dev=
ice *pwm,
> > +			      int duty_ns, int period_ns)
> > +{
> > +	int duty_cycle =3D DIV_ROUND_UP(duty_ns * TWL4030_LED_MAX, period_ns);
> > +	u8 pwm_config[2] =3D {1, 0};
> > +	int base, ret;
> > +
> > +	/*
> > +	 * To configure the duty period:
> > +	 * On-cycle is set to 1 (the minimum allowed value)
> > +	 * The off time of 0 is not configurable, so the mapping is:
> > +	 * 0 -> off cycle =3D 2,
> > +	 * 1 -> off cycle =3D 2,
> > +	 * 2 -> off cycle =3D 3,
> > +	 * 125 - > off cycle 127,
> > +	 * 126 - > off cycle 1
>=20
> Oh, I missed to save the updated comment before I commited the change.
> Can I just send and update patch instead of the whole series again?

Sure.

Sorry for taking so long to review this. I'm rather busy with other
things but I'll try to find some time to review properly tonight or
tomorrow.

Thierry

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQq3BwAAoJEN0jrNd/PrOhpoEP/R5Ag1ql8+BRO4mkjZzMNiKW
BnDfuVMuE4YrAD2D8J3vaf7SlHCAisHXFk4LV4UyGyyMQOPQXRyLsBEgaMXriK3E
LUeaeOf6EPiPAsHDulUDwCHsjqoB7knqc6fuS+EDC1lTB62VkbTq0RpiaHOJMTqO
SGL8hi5N+spH+QpXyRH7XSbKnE37+EPIkTl4FjFmtJnVQNw8xH0cNpz0sAVoCqVh
T5423cbThqWirz/J0xcELvImuS2s3vZD5PdRlQfTxTR1WZRBEuMCuHvfRQKQdn3I
DhxBfXCylVIHo58GkpfxR5bAFE5bFT8PwdQiikVUeX5w95hK9YA1VrmV1YkxM9Mk
kxhb+/83oIRXBGcVu2HYUyCWCIpjoDz5kiVt40cKIp6UeyOkIy7l/RbQ49+bGqk8
ZIAKNzRYDe9rtGvps1Y3D0mTJKk+68kKhG23c61B6KFYmyfIvkWUjcwTEJ/wfqt+
KAV+uUseWtcKDA+LepA2Uod9GvoR8VarM+OEMkkmUxesPs7qUUz5pEuTLFszHuaP
GmEuE8ExWt1k6e+UQWUYo8VEK+rqBVENwiHFi+gP+Sqd9mqhprm0frAzijbTGKVI
rJK083OIh50qXNAy2xkwNWepzchZK5yE2cCTltaE91ornNGAcLEY1FGffC/x9A9a
Gqrul1zcH9UgbJCQeSCD
=oNIP
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
