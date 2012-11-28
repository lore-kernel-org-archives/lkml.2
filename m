Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2K1OUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:20:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51144 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab2K1OUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:20:10 -0500
Date: Wed, 28 Nov 2012 15:20:00 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 0/3] pwm: Drivers for twl4030/6030 PWMs and LEDs
Message-ID: <20121128141957.GA21042@avionic-0098.adnet.avionic-design.de>
References: <1354010999-31371-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <1354010999-31371-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2zMUkHhPY+lfgJyVXlHMQMQuMpumVxnV+pucuFv4y5r
 Itg7Q037Pb3StClfpic/QyW9faSFBeE7s2rtvfoSYr2qZYBrue
 8d8GlARqYIIgLViybegNG6cY5trfkrf3o+Ezgw3iYiF/1JoUpO
 119XuCW7mM6C7UjfL9DglseevRhMnDv8o87chkm2G4aBCyiXTP
 sH0EupNy3jtdOoo9w5MQAZ0Y+BKO8KDlyK7Kuv7o9SnrfIcWl3
 A9XTc591imCgqcuaQIynquPL88yNcZrDY7lhHKjHxpDmU/tI1N
 fOr97yWFyZQOLzqXGKoLlPZlAs9jgEDM9A6nZHx3ndTSm+fmbR
 +rbh60yCyHvwcuQkdCvVaxEwhgcK6teKfxyLembrXj1Z8yzXHX
 uX82ksO8raUkSHxBcz5wJUg0p6HwwqiypbgBTVQhhpoXXjfEgz
 JD6/Y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27, 2012 at 11:09:56AM +0100, Peter Ujfalusi wrote:
> Hello,
>=20
> Changes since v3:
> - pwm-twl-led driver's comment fix patch squashed to the original patch
> - Documentation for the DT bindings of the PWM drivers
> Comments from Thierry Reding addressed:
> - pwm-twl6030 has been removed in the last patch
> - macro for twl_pwm_chip/twl_pwmled_chip lookup
> - locking for read-modify-write sequences
> - separate pwm_ops strictures for twl4030 and twl6030 class
> - _devexit_P() removed
> - Do not select HAVE_PWM in Kconfig file since it is going away AFAIK:
>   https://patchwork.kernel.org/patch/1544851/
> - Remaining (smaller) comments from Thierry also has been addressed.
>=20
> Changes since v2:
> - New PWM cycle calculation for twl-pwm driver and twl4030's pwm-twl-led =
with
>   comment to document the expected behaviour.
>=20
> Changes cince v1:
> - The turn on/off sequence has been corrected for twl4030 PWMs as suggest=
ed by
>   Grazvydas Ignotas
> - Comment section added to the new drivers to describe what they are cont=
rolling
>=20
> The series has been tested (with additional, pending patches):
> Zoom2 for twl4030 PWM0 (keypad light), PWM1 (LCD backlight)
> BeagleBoard for twl4030 LEDB (PWMB - pmu_stat led)
> OMAP4 Blaze (SDP4430) for twl6030 PWM1 (keypad light), PWM2 (LCD backligh=
t) and
> LED (charging indication led).
>=20
> Intro mail from v1:
>=20
> The currently available pwm-twl6030.c driver only supports TWL6030's Char=
ging
> indication LED.
> Remove this driver and add two new ones which implements support for all =
PWM
> driven outputs:
> pwm-twl driver supports twl4030 (PWM 0/1) and twl6030 (PWM 1/2) instances
> pwm-twl-led driver supports twl4030 (PWM driven LED A/B ports) and twl603=
0's
> Charging indication LED (PWM driven).
>=20
> Regards,
> Peter
> ---
> Peter Ujfalusi (3):
>   pwm: New driver to support PWMs on TWL4030/6030 series of PMICs
>   pwm: New driver to support PWM driven LEDs on TWL4030/6030 series of
>     PMICs
>   pwm: Remove pwm-twl6030 driver
>=20
>  .../devicetree/bindings/pwm/ti,twl-pwm.txt         |  17 +
>  .../devicetree/bindings/pwm/ti,twl-pwmled.txt      |  17 +
>  drivers/pwm/Kconfig                                |  17 +-
>  drivers/pwm/Makefile                               |   3 +-
>  drivers/pwm/pwm-twl-led.c                          | 342 +++++++++++++++=
+++++
>  drivers/pwm/pwm-twl.c                              | 357 +++++++++++++++=
++++++
>  drivers/pwm/pwm-twl6030.c                          | 184 -----------
>  7 files changed, 748 insertions(+), 189 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pwm/ti,twl-pwm.txt
>  create mode 100644 Documentation/devicetree/bindings/pwm/ti,twl-pwmled.t=
xt
>  create mode 100644 drivers/pwm/pwm-twl-led.c
>  create mode 100644 drivers/pwm/pwm-twl.c
>  delete mode 100644 drivers/pwm/pwm-twl6030.c

Applied with minor fixups, thanks.

Thierry

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQth2NAAoJEN0jrNd/PrOhIz8QAJrLU7t9Af8zvzGCpz2+yKbW
KSKUpGFZBVBibVqUMIoA6cCaD7yHWb1LoDcJaLUBOYBN/fDZWiWvBralearHyrnf
l0pgG6tM+rhSF/A/gEZJN8f00BlrgELu5FMy3znaOkyQdMP9EWjbniIcekr80NDm
2OU8n2ry3HfipxfxvDrV0lmE/zMqEKN/hCKDPLLNAxZsWr0HgDiF5GraUeifNk6u
vA2t+usEOTlEghYsAayNdOf9h/c71QGd9d9cUjuag4BujjXTDfX/4bLCXwEuz1I4
xF2aZ2/1bgUIwzpAa2FwwaYlaZCZfBHNefw5o+shNd6Oo+/p2CFdpVY8YAz5+DZb
T4Pq5M1/48lGJ2C4kNNiBJIpnt5/Sds7qxuS5lEEhXivGG+JOUWrLaxha7Yms2vJ
Nvkj5JN+NyQ8YwZ3fyzpMgVRgIEz+kzJwnlBtdRuYSZWGYw2mBG5RV86Th3BAPTc
qSwnV55qJC8D5iPmwjtmCxN6qIX6joHFF58Y2vbHyTHZKjCWSzASHOCrtJ6Oe7mN
5SjeY3mYR2xH3wgsP8KUPy4vSD4gKroDLv0gT0zsA+rLJXxcIj0QtWCeXtz4f7q2
dq0MavSxmNM18HaDgPEFHhysdfxhDRtQzNsUi68wGiwVPXLA8h0ba7+HhhqJ5lxb
CSiKjNFHQt0geAwTZBMF
=1qMG
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
