Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3AJLFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 06:05:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41671 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907Ab3AJLFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 06:05:32 -0500
Date: Thu, 10 Jan 2013 11:05:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, sameo@linux.intel.com,
        grant.likely@secretlab.ca, akpm@linux-foundation.org,
        a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 3/4] gpio: palmas: Add support for Palams GPIO
Message-ID: <20130110110529.GI20956@opensource.wolfsonmicro.com>
References: <1357210020-19876-1-git-send-email-ldewangan@nvidia.com>
 <1357210020-19876-4-git-send-email-ldewangan@nvidia.com>
 <CACRpkdbSW+aj9RSedsAMyF3UtSL+w=0KM+pxc2bGdceSy+rXaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="byLs0wutDcxFdwtm"
Content-Disposition: inline
In-Reply-To: <CACRpkdbSW+aj9RSedsAMyF3UtSL+w=0KM+pxc2bGdceSy+rXaw@mail.gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--byLs0wutDcxFdwtm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 10, 2013 at 11:57:10AM +0100, Linus Walleij wrote:
> On Thu, Jan 3, 2013 at 11:46 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> > Add gpio driver for TI Palmas series PMIC. This has 8 gpio which can
> > work as input/output.

> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

> This driver seems unnecessary. Can't you just use
> drivers/gpio/gpio-generic.c ?

This only works for memory mapped devices but this is an I2C controlled
MFD.  Someone should really do a regmap gpio-chip (or convert the
gpio-generic driver to regmap, regmap does support MMIO now but it does
add a little overhead).

> > +static int palmas_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
> > +{
> > +       struct palmas_gpio *pg = to_palmas_gpio(gc);
> > +       struct palmas *palmas = pg->palmas;
> > +
> > +       return palmas_irq_get_virq(palmas, PALMAS_GPIO_0_IRQ + offset);
> > +}

> Why are you implementing this for a driver which does not even expose
> the ability to trigger IRQs? If it's supposed to support IRQs it should
> register a struct irq_chip.

The irq_chip is in the MFD core for the device.

--byLs0wutDcxFdwtm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7qBRAAoJELSic+t+oim9p0YP/3l1xhJmD82/ERxOkKOhL32z
yy4JfBc1sDf95xD2lzdkNPiTsC/cNral2Uh7KSXUUiDIeUWXM/tBCTCzZ5D5u5b0
hO6RJJEtePjO2aHRTMf2vrOGXnl0O2RStSllEzUEPV1RdkKvVuP6ElH/BQaP+QBP
ygK6clA3aAZW3appF4jwEf+IVfKT/37zZbftZDCoUjKUN5OmOBIGIo6DmUmKFj3F
zj/h0nokxWfv0X4dokahLfrhMds3sx106gKBiLJYkeAsFva7pQ4UjIiIMX5sJJh6
uJRbWQYaTcBGarzO+QR6/a++C5+UfOmAa9+ksW3f/EWQmyiRHo+tyqUXeRjhaZ37
L/dGUj9RZDapl4e2ED7XQifQGVhqVzPla+RdQvWyP7fMPtl3YZ9/9btW1DqM6W+n
T9YOp1PeEagAyBzutGNLGodPMVrgV7AgF8gA2Ncb2z1HJn1qEr/DePXQ+x+tNNaZ
SW1qp/2i8IQnXtq8t7yo6q0i9sBkAkK08boCBlFSrZAI+BhKIwUo8EkW0zAafDTR
WCMaFEZjb8W4X/aj8C3SOZy927vCnqMZ1GoNZVJT69zFhzUzlcF7S7pd949H7yCA
1zSmEG70DcS6ObeDrgD4D0ZALS01FKGUpO7Uky6nNLW2pYtXw5LCzyZexXfl6c4k
ZeLN4Va71KEnEA6nLpJ2
=MEDu
-----END PGP SIGNATURE-----

--byLs0wutDcxFdwtm--
