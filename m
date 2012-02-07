Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2BGNRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:17:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48415 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756277Ab2BGNRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:17:00 -0500
Date: Tue, 7 Feb 2012 13:16:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 7/7] MFD: TWL6040: Add regulator support for VIO, V2V1
 supplies
Message-ID: <20120207131657.GL3332@opensource.wolfsonmicro.com>
References: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com>
 <1328619678-26080-8-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NZiXfHLGvOGtDZMn"
Content-Disposition: inline
In-Reply-To: <1328619678-26080-8-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NZiXfHLGvOGtDZMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2012 at 03:01:18PM +0200, Peter Ujfalusi wrote:
> twl6040 has three power supply source:
> VBAT needs to be connected to VBAT, VIO, and V2V1.
> Add regulator support for the VIO, V2V1 supplies.
> Initially handle the two supply together with bulk commands.

> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> +	twl6040->supplies = devm_kzalloc(&client->dev,
> +					 sizeof(struct regulator_bulk_data) *
> +					 TWL6040_NUM_SUPPLIES, GFP_KERNEL);
> +	if (!twl6040->supplies) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +

though I'd be inclined to just embed this structure into the twl6040
struct directly, you're always going to need to allocate it and it saves
a tiny bit of error handling and whatnot.

--NZiXfHLGvOGtDZMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMSRDAAoJEBus8iNuMP3dynEP/ixDQp/g4HRQThsELFNjhkI9
uO4Rt1mK5kZg7OgioD0QfX8nNOO0cCxvBVX3Aaa49RnmgEtUWcYJSumW3ZAj4yIy
4dwsMR0eemJnrnKQczOKDprKpds0OIWxd79WfsREV2jU6QhyrmHl38mRW31uLrDD
Ab2y9sT6ZT+m7EnyAIr7K8d9z4ye+y04slOqwBNCnUZNBHqBF6XvMK78cffa/Icm
WtO639Y32YXsO3QbaNxN2e4SDG5J6q2jrouxKm3+aukSe4ppieVM15ZbHIfE3C3k
Q36clC/nQ6wmC+3hMkCcSFUH7zjfsW6T6rTUCgh7CJwj1HU2bhAzGnBARdQ3lqHh
mMcXSnZd83QlhK4pUbgWfmCY3fG24XzMDS70Z0dG9s7E129Hou8eZMJjj4ivmCFW
2vHBLa/zjSl8RHRe4VacMwWIknb7NoCX7DANWoWPhSGGYdvc4X1mjLQ2MYu0eUC7
Gzr7l9o5xvLe5P+UQZDKguBrEXSNBNu7teBSZHbwvKTONA1WgKqLP7JR3pwrbx6v
1weOnQN8oAGR8ce9rvxv2jsAB+CPPskw15BqW6dbUSYUZpBi46XhphegWcOubEPh
jLogAmxTS5Oln/pJQFQzJRPc7TOdqZDLM4b75cxEklzvUNiAAgJyM6EEgfh2JGdy
cmBuuLMzR/FdzZ1dDa2R
=ucmh
-----END PGP SIGNATURE-----

--NZiXfHLGvOGtDZMn--
