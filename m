Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab2C1OkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:40:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60535 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390Ab2C1OkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:40:20 -0400
Date: Wed, 28 Mar 2012 15:40:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, fabio.estevam@freescale.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mfd: mc13xxx: add I2C support fix building for v3.4
Message-ID: <20120328144017.GV3232@opensource.wolfsonmicro.com>
References: <1332943273-22447-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AonAANj1daC6QcQu"
Content-Disposition: inline
In-Reply-To: <1332943273-22447-1-git-send-email-alexg@meprolight.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AonAANj1daC6QcQu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 28, 2012 at 04:01:13PM +0200, Alex Gershgorin wrote:

> index c3fbc5e..2119732 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -577,6 +577,8 @@ config MFD_MC13XXX
>  	depends on SPI_MASTER || I2C
>  	select MFD_CORE
>  	select MFD_MC13783
> +	select REGMAP_I2C if I2C
> +	select REGMAP_SPI if SPI_MASTER
>  	help
>  	  Enable support for the Freescale MC13783 and MC13892 PMICs.
>  	  This driver provides common support for accessing the device,

I'd really expect this to be squashed into the patches adding the regmap
usage for I2C and SPI, how can those patches work without this?

> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index 31dbf91..5a60273 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -616,7 +616,7 @@ static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
>  #ifdef CONFIG_OF
>  static int mc13xxx_probe_flags_dt(struct mc13xxx *mc13xxx)
>  {
> -	struct device_node *np = mc13xxx->dev.of_node;
> +	struct device_node *np = mc13xxx->dev->of_node;

This looks like it should be submitted properly as a bug fix for
inclusion on 3.4 or squashed into whatever change introduces the issue
if it's not present in 3.4.

--AonAANj1daC6QcQu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcyLEAAoJEBus8iNuMP3d+igP/2nX8ghAFfo6LKzNRKOTug6d
IpVso55eIKkaRynrNwe37/Rncy6YMbvhjXWjn/ejnEL5nYFZFPg4BrryGRRcxkRM
Ts1vyr3Hc/ytG/dRePNHCCyslOkUI5HSb2dlTsWOxc0ZyfWvWbXuWWAlm9A0PcLO
MlMEOIe6tUCCilcLsdoe1s24cNQ57giXLrCcUM5JirGspL4jGdAVyhcPRmyHb6H0
4gVRNntdIvvYNLxeozVBzhubetya+RYKIheixdnJbnbxEp5v8M/guik5i9AIAJkE
6oMQqHfSuHNg8OZxh2TRk/d0R0hAY4zAJp2vWI48XvSgxrANt3JT9im4ZsIVvUB/
h4s2l+SKHk5V1uMh2uV+OECU9dmeLk/SHcwiw48+oRbWhR5JbZ4Sz+dmiCNvBce9
L84sbu2kYNCtgWjME+SF/Hnog//ooteHD3NfeESczdz/Xy7khfLYMRB5Yxuygl76
M9n+6qPupLmb6qmdFK1HxbPE/SzrCdtfeChhF7TMq8LkLFr+tIxRV9MlUxH+FUI9
H+sb9xQMld+fABWGmTbkUJCiVu/ScA/7mihKkkWUmN5hgdrSGxgHKI1fnC0oLwUB
EFfGrpnbj4AjTWiga6w4+Nq/69QolOe46lg74o3hlWtxRHBJQA13V+yKTVd5jdgE
WFoN1v8V285IYnD+SyCo
=oSIi
-----END PGP SIGNATURE-----

--AonAANj1daC6QcQu--
