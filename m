Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab2EBJIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 05:08:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37052 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755862Ab2EBJIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 05:08:52 -0400
Date: Wed, 2 May 2012 10:08:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>, sameo@linux.intel.com
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] twl-regulator: define all feature flags in one place.
Message-ID: <20120502090848.GF4075@opensource.wolfsonmicro.com>
References: <20120501204259.27026.40156.stgit@notabene.brown>
 <20120501204449.27026.29720.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b8GWCKCLzrXbuNet"
Content-Disposition: inline
In-Reply-To: <20120501204449.27026.29720.stgit@notabene.brown>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b8GWCKCLzrXbuNet
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 02, 2012 at 06:44:50AM +1000, NeilBrown wrote:
> twl-regulator has a collection of feature flags, some defined
> in twl-core.c and  one defined in i2c/twl.h.
> This is confusing for anyone adding a new feature flag.
>=20
> So collect them together and place them in twl.h immediately
> after the structure in which they are initially set.

Please remember to always CC maintainers on patches and always use
subject lines appropriate for the subsystem.  Adding Samuel since this
is not a regulator patch.

> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>=20
>  drivers/mfd/twl-core.c  |    7 -------
>  include/linux/i2c/twl.h |    8 ++++++--
>  2 files changed, 6 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index 4cbf285..269b296 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -224,13 +224,6 @@
>  #define HIGH_PERF_SQ			(1 << 3)
>  #define CK32K_LOWPWR_EN			(1 << 7)
> =20
> -
> -/* chip-specific feature flags, for i2c_device_id.driver_data */
> -#define TWL4030_VAUX2		BIT(0)	/* pre-5030 voltage ranges */
> -#define TPS_SUBSET		BIT(1)	/* tps659[23]0 have fewer LDOs */
> -#define TWL5031			BIT(2)  /* twl5031 has different registers */
> -#define TWL6030_CLASS		BIT(3)	/* TWL6030 class */
> -
>  /*----------------------------------------------------------------------=
*/
> =20
>  /* is driver active, bound to a chip? */
> diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
> index b526031..88e8cd8 100644
> --- a/include/linux/i2c/twl.h
> +++ b/include/linux/i2c/twl.h
> @@ -171,8 +171,6 @@ static inline int twl_class_is_ ##class(void)	\
>  TWL_CLASS_IS(4030, TWL4030_CLASS_ID)
>  TWL_CLASS_IS(6030, TWL6030_CLASS_ID)
> =20
> -#define TWL6025_SUBCLASS	BIT(4)  /* TWL6025 has changed registers */
> -
>  /*
>   * Read and write single 8-bit registers
>   */
> @@ -748,6 +746,12 @@ struct twl_regulator_driver_data {
>  	void		*data;
>  	unsigned long	features;
>  };
> +/* chip-specific feature flags, for twl_regulator_driver_data.features */
> +#define TWL4030_VAUX2		BIT(0)	/* pre-5030 voltage ranges */
> +#define TPS_SUBSET		BIT(1)	/* tps659[23]0 have fewer LDOs */
> +#define TWL5031			BIT(2)  /* twl5031 has different registers */
> +#define TWL6030_CLASS		BIT(3)	/* TWL6030 class */
> +#define TWL6025_SUBCLASS	BIT(4)  /* TWL6025 has changed registers */
> =20
>  /*----------------------------------------------------------------------=
*/
> =20
>=20
>=20

--b8GWCKCLzrXbuNet
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPoPmaAAoJEBus8iNuMP3dGnkQAINgNh8RH7XBexJ1E7mdnaN8
jWzySvNdGvCVLp832U9GYIpFZP2sqd3e+SQvd7TE5h+vRMGo3fLIrDTdJF+GqxMD
lv2wBGDm54GLgcStKij7m56SO9i6v0WnIdhwF5aCowsKh7gRLro1vEH7aFbpmwX4
ywFtdbEzBIFnWu+EdUWsTM/bt7odZ7Aq6FgIjOkQYEXgm8XP+OmikxFYW74r8i2l
CJ0t/2w+PbhBFKvidnp0Q+8a5vsbIz4p3zyrmQQFuIgbsIL4HtSV2AEHcSkbiFtW
0nJ9y6IMEwcS6fL+gWqcXphBZT4S05zPLOIBrYwYvkGB0X0fech3ZTzCRDf7SDcG
9gPtk+964f+yYckFL+UepYZ4peTBscSdFPWQwWGywJc7CvfNQ3lBpFgbAWu9afGX
MDz0UtrScKDTsJzlbBnzA3k/digzzHt6iYjKpozodJ9Y/BG1uRNLqfP7kgawUDKI
o7m6WpG+N+yNfp3N3Z/wOw1lEGzqe1XiWGdGXHUGmz0w+4B21Z3EzjBy51QKhIKQ
JwnmH+qvQJR7P+Lctp5gpiY+RqCdzknicpoqFcT9eLXHVuM2FjjlQx0v3ZhLcDiK
rVnmj22/rM7Z8cyi+LpjKgkITRTqIJUpRSGIuumQCTvI5QTP2M9MAH76Y1rD2ley
H1imK7VcFI3Otd6LWVAE
=BWNT
-----END PGP SIGNATURE-----

--b8GWCKCLzrXbuNet--
