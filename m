Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab2BHNHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 08:07:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56687 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932111Ab2BHNH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 08:07:28 -0500
Date: Wed, 8 Feb 2012 13:07:26 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1 1/2] mfd: tps65910: use regmap for device register
 access.
Message-ID: <20120208130726.GB5943@opensource.wolfsonmicro.com>
References: <1328697985-22504-1-git-send-email-ldewangan@nvidia.com>
 <20120208114120.GF3120@opensource.wolfsonmicro.com>
 <4F32676F.1010305@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <4F32676F.1010305@nvidia.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 08, 2012 at 05:45:43PM +0530, Laxman Dewangan wrote:
> On Wednesday 08 February 2012 05:11 PM, Mark Brown wrote:

> >This is *really* odd.  Why is this not static data (or mostly static
> >data), why does it vary at runtime?

> I did not wanted to make the list of register in core driver. Wanted
> to leave the decision to the sub-devices driver where they need to
> enable cache based on their requirements.
> Do you think that the register list (although it is used in the
> regulator driver) should be in the core file? If this is allow then
> I can make the static table in core driver.

Yes, it should be in the core driver.

> >>+	/* If any of register is non-volatile then use byte-wise transfer */
> >>+	for (i = 0; i<  bytes; ++i) {
> >>+		ival = (unsigned int) (*wbuf++);
> >>+		ret = regmap_write(tps65910->regmap, reg, ival);
> >>+		if (ret<  0)
> >>+			return ret;
> >>+	}

> >There's nothing specific to the driver about this, if this is a good
> >idea add support for it to the core.

> This function added because there is no bulk_write function in core
> driver which supports the non-volatile in the list. Even if number
> of bytes read is 1.
> Should we move the above logic to core driver?

This is the core driver?  If you mean the regmap core then yes.

> - If any of the register is non-volatile in bulk write then split
> the transfer into the byte-wise/short-wise/long-wise
> (format.val_bytes) based on register width?
> - If all register is volatile the uses the regmap_raw_write()

> Does it sounds reasonable? If yes then I can move this code to
> regmap.c as regmap_bulk_write() i.e. new function.

Yes, though bulk_write() is tricky as it's *really* unclear what it
should take as an argument - should it be raw register size (in which
case it's just raw_write()) or should it be ints (in which case it needs
to repack the data too)?  I suspect ints but I'm really not convinced
there's much use case for this.

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMnOFAAoJEBus8iNuMP3dv24P/3Z/H2ruDYczv/Ut9B9dPqxT
zIT+A6rXHOvAJZmm/BxOPUGGUYrokS1xTcYeyg9SVfAKN8p9IawW+TgQEifpK24t
zpSMUfbUsLWMtib4E+SihHjV6EnpVKat1EA5cLsvBbx86GHODbJXDxa3IQzSFW1C
pbi8esYdp6SZii3Yy64YbjcwoEAUDpzFYlAbskUajUzbbgwhh2y1Z7jCg2a0pUro
fNe2EvZrFkAG68Chpky9bSBImsxe5JcSqWOypDg2u/O5gFyNWOVzd5eTY3h62NYl
ThnHIAF5pWsdXu7SdCaSA4roF+N4KM5qjt+hel5xCQWTvEFn5XGsWGDuNbuk64kc
c/WY5aUCpwS2oQGX3NqCnZExCOCqJlBLt+gar0LuQvwttyutNJXW5TvUvQGUYsUb
En7npX9cqSHbA/DPgs0vHwaBPToN816vOVBhcHxC6oI8x3qxYmyVyjMzHNWoCege
iXG8u8JKobtUG+ZUICPMT2eFcXNPsi3q+Un5PnCDbqi+Cr2Pn6V/QrIJliFe6b0m
LerYWYtMYvLhK5u96InfmdJ7FKym1zg9OlO+R68OudXW/lSF5fMFLZDlDvk9Wk6B
4AUHwLaWoFfSNZzu05CWJuZpojfNEGStgr3yvQcU1ZJI39xZL/lRDZ68X/i1Ejlj
oKNcUrI9m3mP66gZoAgE
=CSUJ
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
