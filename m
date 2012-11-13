Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2KMHqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:46:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37678 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134Ab2KMHqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:46:34 -0500
Date: Tue, 13 Nov 2012 16:46:24 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/2] mfd: add TI TPS80031 mfd core driver
Message-ID: <20121113074623.GL18224@opensource.wolfsonmicro.com>
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com>
 <1352646721-8350-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+RZeZVNR8VILNfK"
Content-Disposition: inline
In-Reply-To: <1352646721-8350-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+RZeZVNR8VILNfK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 11, 2012 at 08:42:00PM +0530, Laxman Dewangan wrote:

> +#define TPS80031_RGEMAP_IRQ(_reg, _mask)			\

Why RGEMAP_IRQ?

> +static struct regmap_irq_chip tps80031_irq_chip = {
> +	.name = "tps80031",
> +	.irqs = tps80031_main_irqs,
> +	.num_irqs = ARRAY_SIZE(tps80031_main_irqs),
> +	.num_regs = 3,
> +	.status_base = TPS80031_INT_STS_A,
> +	.mask_base = TPS80031_INT_MSK_LINE_A,
> +	.wake_base = 1,

I'm not sure your wake_base setting is sane here - this is expected to
be a register.  If it is a register why is it not a #define?

> +static int __devinit tps80031_irq_init(struct tps80031 *tps80031, int irq,
> +				int irq_base)
> +{
> +	struct device *dev = tps80031->dev;
> +	int i, ret;
> +
> +	for (i = 0; i < 3; i++)
> +		tps80031_write(dev, SLAVE_ID2,
> +				TPS80031_INT_MSK_STS_A + i, 0x00);

regmap ought to be masking everything for you on init.

--x+RZeZVNR8VILNfK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQofrHAAoJELSic+t+oim9Hi8P/RR4yMkbFW8hQTWkJTPwg92x
Jvj/PJq6+QJJtGGfuco3OAtEctzcj96t/UPl/1OkSkPuRV38R2Ol3FgM5O73q42B
NHlthA3V/2aCsKL0LBd9RKhFoeBm21ZFV2wk8lBDvhYvbJ9Tuy2oYvvCA7ZwBrwV
04lUP8ZY6gQkdvKbMcWLeKOm41bjo7DllXo5zUQRzdOu2zGDJP8jdGsNff8XQfhf
VJUCDRPKoBXMbPoSvN0cpdcLMrX6t2/M22rHa9i8yQPddcRTza8yOlmt8QPjN+G8
CKDWTxQ9EsOvCcpBpGbzqy3qxkWm7bOqbRks0ukBk9jt1sNxaTZGbHdbmIIvyQxY
KI4+NUaox5m6GC+wEYE2KFTpnx8Kgr7FFmeTyXVE6G+GUVP3y9B4zxcE0bhRDlHR
Dtze+qJWCDJr/hs8zCKV2Gqi5xBg8nEMgKCtzPEwvVEg9PKcDjOl0xgRYsfADOup
e/YhBsUpB5B6SuCOjp60TfCOzxIT7jslqHAPAdGkusL0RCw5lIHvWPxX5K22ZpK0
3pngYscIsrjIj3a+KHBwul4OZexQZP5UbUdBYh24ydF6x1KOHsurQYV1F3hKBRb1
eIf1eqBRxCusy5iHqfKciPDekGTLlctTvboBEkZi7HPYoCjWMvn7d64h/kkhxtoe
5ThoU36MNGNyFFsoeAI/
=r7Uz
-----END PGP SIGNATURE-----

--x+RZeZVNR8VILNfK--
