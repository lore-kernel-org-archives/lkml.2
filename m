Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab3AIHvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:51:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56296 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3AIHvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:51:46 -0500
Date: Wed, 9 Jan 2013 08:46:30 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Boris BREZILLON <linux-arm@overkiz.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH v5] pwm: atmel: add Timer Counter Block PWM driver
Message-ID: <20130109074630.GB12782@avionic-0098.adnet.avionic-design.de>
References: <1357659402-4574-1-git-send-email-linux-arm@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <1357659402-4574-1-git-send-email-linux-arm@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:gO7d7AUsjzagPfdy4vuREA1fH6QYpD2Mg/aka5V9Ii4
 5LHPYNL4rmRhuGAB600uaZnt7UyPS6eCnFpMU31UvTEVk6y7fF
 uMm8kbzZdosNVIzSDDSaCoih5uW9kbpphrwJr2hHfip9xf1+su
 Kiit3PodUSjfiLIyiwJxl0SUKoFAvsgyRFu0wKbPkPWBLjppoP
 ZoEcVjIwA35i7fu5QbGrsK9vMCh6Xwq7/1RnhxFpUdW1bTvq8V
 vsvLp+SDSRNALzJLrp4eOKd9oPIgsEjUzWXSeS8WTbxEASW6p0
 hGkscSV/uWfU17p9rmhpyG3TxVTWWOGJEqoXo8X5kuir9ZyBNF
 TNTfrquh9eP3hjKIcu3JP7J1nbqIphHnt13CYCpAsrFXF9bh5Y
 /3YEVhKvJ3VTTx2AE0QjuMZym85BbeQTwk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 08, 2013 at 04:36:42PM +0100, Boris BREZILLON wrote:
> Hi,
>=20
> This patch adds a PWM driver based on Atmel Timer Counter Block.
> Timer Counter Block is used in Waveform generator mode.
>=20
> A Timer Counter Block provides up to 6 PWM devices grouped by 2:
> * group 0 =3D PWM 0 and 1
> * group 1 =3D PWM 2 and 3
> * group 2 =3D PMW 4 and 5
>=20
> PWM devices in a given group must be configured with the same
> period value.
> If a PWM device in a group tries to change the period value and
> the other device is already configured with a different value an
> error will be returned.
>=20
> This driver requires device tree support.
> The Timer Counter Block number used to create a PWM chip is
> given by tc-block field in an "atmel,tcb-pwm" compatible node.
>=20
> This patch was tested on kizbox board (at91sam9g20 SoC) with=20
> pwm-leds.
>=20
> Regards,
>=20
> Boris
>=20
> Signed-off-by: Boris BREZILLON <linux-arm@overkiz.com>
> ---
> Changes since v1:
> 	- Fix device tree binding Documentation
> 	- Fix Kconfig issues (missing OF dependency,=20
> 				deprecated HAVE_PWM select, ...)
> 	- Fix various coding style issues.
> 	- Cleanup code and add some comments.
>=20
> Changes since v2:
> 	- Replace kzalloc/kfree with managed versions
> 	  (devm_kzalloc/devm_kfree).
> 	- Add one cell to device tree binding to support polarity
> 	  flag.
> 	- Replace min computation (2 div -> 1 mul + 1 div).
>=20
> Changes since v3:
> 	- Fix device tree binding Documentation
> 	- Fix Kconfig description
> 	- Fix coding style issues (function parameters alignment)
> 	- Replace 1000000000 value with NSEC_PER_SEC macro
> 	- Get rid of newcmr variable in enable/disable functions
> 	- Remove unneeded devm_kfree
> 	- Add missing atmel_tc_free
>=20
> Changes since v4:
> 	- Add missing comments
> 	- Fix coding style issues (multi-line error string)
> 	- Fix wrong MODULE_DEVICE_TABLE setting
> 	- Remove unneeded MODULE_ALIAS declaration
>=20
>  .../devicetree/bindings/pwm/atmel-tcb-pwm.txt      |   18 +
>  drivers/pwm/Kconfig                                |   12 +
>  drivers/pwm/Makefile                               |    1 +
>  drivers/pwm/pwm-atmel-tcb.c                        |  445 ++++++++++++++=
++++++
>  4 files changed, 476 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.t=
xt
>  create mode 100644 drivers/pwm/pwm-atmel-tcb.c

Applied with minor changes to the commit message, thanks.

Thierry

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7SBWAAoJEN0jrNd/PrOhgikP/jKVdIFMx0m8jILfXJbDhikS
d4rLJXt+X2ttfyfu7LuRxgZI8Yeg89sowhZ6tuyTKqr4YKcQgb3sgsmxfHYSzZxj
WYfDi3HvMYS7WMYXNFfF8LCNtJ8Wa10Zz+cemNJ14ISRWzgkiQqPyvtMa06uDr8W
7UWas7X643tp/BQdfcSt8HXizF7omRQukIYkI9QIezlhgb4qtw9Pe0IFHP0ZR6ak
Q8DfPLHOt3t5kPrRKFIEJW02ZrDJIHVNqmYBcJ5pgckKIkW4Fy6F0t/Bu58BZ8wk
Mkr211EQSwLu8yoJPt7eegrNOQqMJq95HSPLk+LeMtXXTq3piQFjN4yu8pkap11Y
NYalL0BoOXyfOQKEbayEZlUn9VneR2RgF4t+8hurKEZ3MTQ1EM+sxCBuYZ+VgWmc
vLQYvTMVD4t90YvxxCSqsg5WwN+uWgcYdAdBQ/0gkOBk8Hg5/v0ic77mK2Tx9Q4P
0FrqiTaH6/8YCt2cwjOJVyNRbrcv5whqO4kW5GW93wbXsxOKuueHuP5nTuebaEFX
nNCrqrCJpdTCtlZcYY0OOk+bJNYAg49M7fBUJnehMgTgkRC++gh3q/9cv4eMR3g6
HqlaCVakQZLcB8lm45sIh6Y2NYoq8oMVIgUFHzucJKYEnwKZlKT4hNyuGOAX5sVU
CXIzp90Ymp2TBodzMq8p
=mxuN
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
