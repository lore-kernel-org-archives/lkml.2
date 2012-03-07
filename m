Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031629Ab2CGADu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:03:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42147 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031615Ab2CGADs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:03:48 -0500
Date: Wed, 7 Mar 2012 00:03:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, alan@lxorguk.ukuu.org.uk,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        Stefan Nilsson <stefan.nilsson@unixphere.com>
Subject: Re: [PATCHv2 2/3] misc: add support for bmp18x chips to the bmp085
 driver
Message-ID: <20120307000320.GG19635@opensource.wolfsonmicro.com>
References: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com>
 <1331068084-17911-3-git-send-email-eric.andersson@unixphere.com>
 <201203062127.44463.arnd@arndb.de>
 <20120306221752.GB18235@skinner.xfiles.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n7zTieg8iIQ1Wja9"
Content-Disposition: inline
In-Reply-To: <20120306221752.GB18235@skinner.xfiles.lan>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n7zTieg8iIQ1Wja9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 06, 2012 at 11:17:52PM +0100, Eric Andersson wrote:
> On 21:27 Tue 06 Mar     , Arnd Bergmann wrote:

> > I don't know much about regmap, but your description sounds like you
> > should be using it here, to simplify the differences between i2c and
> > spi in your driver instead of implementing your own abstraction
> > layer.

regmap provides I2C and SPI register I/O for most devices using those
buses (and will do more buses in future I expect) and also provides
diagnostic (things like register I/O logging and register map dumps) and
optional cache infrastructure on top of that very cheaply (so you can
easily do things like avoid the read part of read/modify/write cycles or
restore the register state on resume).  The win is partly getting the
infrastructure and partly the fact that all the code for formatting the
data for the bus is factored out from the individual driver, usually
there's a substantial code saving.

> > IMHO this would be better expressed if you make CONFIG_BMP085 a hidden
> > option that is selected when either BMP085_I2C or BMP085_SPI are enabled.
> > Otherwise you make it possible to build just the base driver but neither
> > of the front-ends, which is a bit pointless.

> This setup is inspired from other drivers such as ad525x_dpot.c and
> ad714x.c, which also have their own bus abstraction. If regmap is a more
> generic way of solving this I am all for it!

The idiom Arnd describes is the more normal one for the reasons he
mentions - see for example what most MFDs that have this problem do.

You'll need the same setup even with regmap since you'll need to
register I2C and SPI drivers.  What you save is all the register I/O
code - often the I2C and SPI specific code gets reduced to just calling
regmap_init_X().  The regmap subsystem only appeared in 3.1 so lots of
drivers predate it and could benefit from using it, we're starting to
see conversions happening in some subsystems.

--n7zTieg8iIQ1Wja9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVqW0AAoJEBus8iNuMP3dY08P/R9++r7QYPe1UA19XFSbmgyq
dhdaHnHvQyBWM6YTaTTTucZfKryRTEdzZTlj9FRKLyI/CNX2DhnYnrAQwGPeMOGk
82ZOQ/B+K9w6kbnreYCoDKMZ8aiFsx1Q4uok4iOU6ZCe4l/3Je45I5hqje7j3tvI
PoJZqLP9PG8qzC1nEgcRkhLpVtEy+BCfHGHWVmXVM89k7c8IJ9bDhedzez9uqXui
4SRUz0PyywLub73ZlByUwEJ66Ryc+W8THmH1/YgtdlnELwfXhLJhdSMWMCr+3Fb6
frBUJKS8OvbpXiaeldegIApvsOx2mb7hawso3295frkkkaApTMak7/l953ODf2Nj
lrYuVQ6A4ljWW2jK14Q5Ztkr2zDjztqck4/NlL/lDBET3jCbKzEejSBb4nBhQ6Uf
A/ciwJ3EMFPV1pkkXxq41y4t1g0W1X9eYqSwcAebgEyBOobcwIcjihjB8n/zRagr
VQKLQv3rKCxwj/JLORqBpf/2F5Xfy8wWLjiglFEYxgOkDD7jKvOJMbunZ+kUxjj5
d1N8sW8PxWywEW2gftdaUTT3b/AbtrB+7txZ6hCJMWxzG4pj+og2hCUTU5KO+JWz
lTVCtuSwTzQ+BIe/aj6oNCbTCCtvfilJOYEpcnAa9lFUVL1lZNI3X+ZoY8H+n7r5
2uFHISX/Iub+78FHSyKt
=o/Zd
-----END PGP SIGNATURE-----

--n7zTieg8iIQ1Wja9--
