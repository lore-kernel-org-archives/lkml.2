Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161123Ab2JXTEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:04:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60169 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505Ab2JXTEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:04:10 -0400
Date: Wed, 24 Oct 2012 21:58:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-input@vger.kernel.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121024185818.GB772@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121024161429.GA16350@core.coreip.homeip.net>
 <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
 <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 24, 2012 at 10:28:46AM -0700, Dmitry Torokhov wrote:
> > for more complex pinctrl use cases. These are my dogfood drivers ...
> > Most of these will request more than one state and switch the driver
> > between these different states at runtime, in these examples for power
> > saving there are states named "default", "sleep" and in the I2C driver
> > also "idle".
> >=20
> > These examples are more typical to how the ux500 platform will
> > look, also the SKE input driver will move the devise to sleep/default
> > states but we need to merge PM code before we can do that.
>=20
> I do not say that no drivers should ever touch pinctrl, just that most
> of them do not have to if you have other layers to the right thing for
> them.

It will be a much bigger mess. Some drivers don't need to care about
pinctrl because drivers/base handle it for them, while some others will
need a way to tell drivers/base "hey, don't touch pinctrl at all because
I know what I'm doing" and that has to happen before probe() too,
otherwise it's already too late and, according to what you suggest,
drivers/base will already have touched pinctrl. The only way I see would
be to add an extra "dont_touch_my_pins" field to every driver structure
in the kernel. Clearly what you say is nonsense.

--=20
balbi

--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiDpKAAoJEIaOsuA1yqREDIsP/0uhC5y1maA2qGHjnTqaWgxv
DarRiOqoDKkQfsqIzF4D+Vm0pYzmy4u2zODrTZ/OicBIcoc3jzf9EmxeuR3FjQhZ
KhUY0sxzii/5xSDKVThx2F4H0Cg8AgUCHKf6yq+3CUrQuxEatm30H0q9jJaYAcN7
mvPEjgiKnd9U/xZqzKkU3OJX5Sblr1DN2Qg4YmHR0jB8QHVIU4p5FHMT7oV668ks
SQjcvwDIzUc88rR4YkjpWKvWGTllZZnHK0yMbP1T8XRTyU5Gu3DbXM+NeMN7jUMw
J/x9BOl20zLIhuCRUymidTCD79JP4rLhFS0fUrQN4ZEqXS5iW6ADoJahUa/6BE6s
78XCqrj+Cwbpdb0/ROe2VK+gkbzFBQSG6GZ0+tOicwG76gnFTd8LJaoO2E+VOafH
C3m+abV1MuEoNRNtQ4HgF9hmsPitZPujfGcMxGvT+L/H0iJ7ajKdp7A0btvOhrvg
M+bk6KKY7I/QB0DifHpkBNo0bUNl+84dFekTcBquuV6I6cnMQMQrHKEh5ezFlW+u
UNVhJ/LqYRLU8oPNwB8lN/fubc29Yrsndk+Y+k6Y3iXT+WLtPghF9H23NRg1tvp8
9LIeCrGQQH1do3A4F6MOBR6xQkOictl32IlOkPUpVI0JTp9A4P1asencbYDzrfQV
GX/RvXQmlTh+jtQp2+5S
=vJXe
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
