Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2FKLWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:22:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50105 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab2FKLWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:22:08 -0400
Date: Mon, 11 Jun 2012 19:21:50 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20120611112149.GK11439@opensource.wolfsonmicro.com>
References: <1339412480-7558-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120611110958.GT6845@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJAclU0AInkryoed"
Content-Disposition: inline
In-Reply-To: <20120611110958.GT6845@arwen.pp.htv.fi>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v3] clock: max77686: Add driver for Maxim 77686 32KHz
 crystal oscillator
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IJAclU0AInkryoed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 11, 2012 at 02:09:59PM +0300, Felipe Balbi wrote:
> On Mon, Jun 11, 2012 at 08:01:20PM +0900, Jonghwa Lee wrote:

> > +static __devinit int max77686_clk_probe(struct platform_device *pdev)

> why platform_device ? Isn't this an i2c device ? So this should be
> i2c-client driver...

It's a component on an MFD.

> > +		if (!max77686[i])
> > +			return -ENOMEM;
> > +
> > +		max77686[i]->iodev = iodev;
> > +		max77686[i]->mask = 1 << i;
> > +		mutex_init(&max77686[i]->mutex);
> > +	}

> doesn't look like the right way to do this. What if a user doesn't use
> all clk outputs ?

It seems like a bad idea for the individual drivers to have to worry
about that, it seems simpler for them to register all their resources
and then let the subsystem do what it likes with them.

> > +static int __devexit max77686_clk_remove(struct platform_device *pdev)
> > +{
> > +	kfree(clk32khz_ap);
> > +	kfree(clk32khz_cp);
> > +	kfree(clk32khz_pmic);

> kfree() or clk_unregister() ??

Shouldn't be kfree(), the memory is allocated with devm_kzalloc().

--IJAclU0AInkryoed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1dTBAAoJEBus8iNuMP3dVLgP/RjSLtZiex91Acuc61VA7Z4p
wNGhwIh6/UmjOJKQTHeLkqBf52/0hH/ioJj0dyHjdlunbCuZhEZ8ihMT/yEYn9YN
C75j4x8oig0pEurCIAmeemeaSKPmZPcztNc5IY7o/PTqRK8BOR09d8coWg62FDqV
8MM3mU5lwAtW0eL6AAxYGXpJNh70ZxTJj3CBdpuTLHg5H1BlahYzrZqIMJmUqDNB
tAfprJBTtamiAlmeVq5D3pagZTLqxz23a5WPQct8TRNnVMoAo0zzuZxcvfmesjZF
hUk82krXE7kvp7Mz9Xc+9wcrd6iKO2ERPbot0Ne0HYCkKM55abhR2ygy1XlVPAZS
wM3hXXEgAu1hdafummRbsCM3oIKCiMk32JlA0VzjTFbce6N/x5IyM+GvqiqAzD83
ery0bG3pUAWpCuMVKLThTdp6wi2MVPuaZ18Px/Q6B4V1rA4M49YzzaaEIHym75aH
r2DK8srsPFvDq+V7RGvipJ8FVYQBkHh5ORd0MamLB6tsg5ABRHrD/lOb+ia0x5L1
FTADH8K49I7RgKkWiO8zk0zpeuumXYfyNh28FfHpGTIp59qi4eqdoxo5GZrwEEBr
4+T4UdM2VclAuaxn7JbrRqnejBVJFNDmByqplGAOW5dgPS/JlOWT7Xjlo7pt0xCg
qLHzbbOgqb1/0ZU9DNVR
=x1V5
-----END PGP SIGNATURE-----

--IJAclU0AInkryoed--
