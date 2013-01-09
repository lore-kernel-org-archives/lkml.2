Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab3AIPkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:40:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59973 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932073Ab3AIPkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:40:12 -0500
Date: Wed, 9 Jan 2013 15:40:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
 regulator is enabled by external pin
Message-ID: <20130109154008.GB20956@opensource.wolfsonmicro.com>
References: <1357371223.22227.1.camel@phoenix>
 <20130107110818.GB4544@opensource.wolfsonmicro.com>
 <CAFRkauBBHtjR+GYogpVPxBwGnoJD2==MUaqhZ6KOC7TJE4SpAA@mail.gmail.com>
 <20130108104356.GK4544@opensource.wolfsonmicro.com>
 <A874F61F95741C4A9BA573A70FE3998F69E1205F@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E1205F@DQHE02.ent.ti.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 09, 2013 at 02:34:40AM +0000, Kim, Milo wrote:

> -			goto wash;
> +
> +			if (ret == -EBUSY && config->is_gpio_shared)
> +				shared_ena_pin = true;
> +
> +			if (!shared_ena_pin)
> +				goto wash;

It'd be much nicer if we were able to just keep a list of GPIOs
controlling regulators as we see them and automatically work out if
they're shared.  Probably we should just refactor the code so that the
GPIO object is a separate thing rather than just storing the state
directly in the regulator struct.

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7Y9NAAoJELSic+t+oim9djwP/jI0li1QcNDsygjJpm05wLn3
c/qdy3H+RXy165oCT0Chl7tbjznTBzwnrwsK7Oew0Uyol6YASNlakdv5RPDC7Ss9
1Anbh3ixJkx+ssRJl38g3BatsOgqjXfOnJE9xwX0mputrsy73Tlw6ueNYTYq3mSU
C+Q3oLi0bhGfsUnixvD+YDX458wCqih8kPP6Q9Mvt3bhWxX/Om14j+RK6tjsw2wG
+6FwEBD1HWgZYe78RnI37zoltJAwdExQhdPNd5WuVARFp4RxFrdWSSEphQxr5Z2g
D49az9PBIHa6wt/WlFrOtaOQJ/EiiBQUivay8iKr8FHeMvtTeVYPqfJiewUcLem+
lVJlSrSH5GxLRU8jPSo0v+guz8GA1JpWVQusGX0akH7R7V/Cu2A61zH+BS5OquOE
sZS0YTg/HBYnLt6UOITOy1zB2cOwXB86zc8gc7oXU9XHEjgkepelsF6SxJy1H/k9
JaOL0isqB9JRJz1tjDvHs3vLE/p86R2QHiQA+rbRh/+GUFIV4pnJ88ZVHKy3i/O8
Spb32PVhGNZfVlyJgAC+7vhlsJe0jszTpZEV2Zr2TO13TRBUQFJNdm9Sm7A1rfdp
oS9ooVsbsOdyeLq+JI8EYuQHPURz1MRGeoLeVtbrp43ilRfpiPwNRzWaDhhCDqes
/wFVxO4BH93+6DCmOIQX
=e4Km
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
