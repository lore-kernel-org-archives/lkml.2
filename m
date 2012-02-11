Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab2BKVr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 16:47:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47731 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836Ab2BKVr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 16:47:58 -0500
Date: Sat, 11 Feb 2012 21:47:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, lars@metafoo.de, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V3 2/2] regmap: add regmap_bulk_write() for register write
Message-ID: <20120211214754.GF31887@opensource.wolfsonmicro.com>
References: <1328889628-13151-1-git-send-email-ldewangan@nvidia.com>
 <1328889628-13151-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XaUbO9McV5wPQijU"
Content-Disposition: inline
In-Reply-To: <1328889628-13151-2-git-send-email-ldewangan@nvidia.com>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XaUbO9McV5wPQijU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2012 at 09:30:28PM +0530, Laxman Dewangan wrote:

> +		/* No formatting is require if val_byte is 1 */
> +		if (val_bytes == 1)
> +			wval = (void *)val;
> +		else {

Please don't combine branches with and without braces.

> +			wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
> +			if (!wval) {
> +				mutex_unlock(&map->lock);
> +				dev_err(map->dev,
> +					"Error in memory allocation\n");
> +				return -ENOMEM;

As a style thing a goto error pattern is clearer for stuff like this -
there's so many branches that it's complex to keep track of the
unwinding.

--XaUbO9McV5wPQijU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNtx5AAoJEBus8iNuMP3dGwkP/05UHp/6mjkf8naAO6w9jNiY
SqXJV6zqyYGp0tWyz4vWHPpfWYIbiZyfF61ZJCOSk1elVyr7DLJTxTKiT/viuJmi
/hafkqW0z/CK7oFKfxgddAO3UvMlXObEXlh8TF4qEdZzOY04l/xJzL09RfKNrNaR
NcRBz2DZ/0BA9HFqfCb09FsZ3nuQEqY2HgOGWXKkb6YJ9SR315vChzaPkHUSDzcf
B7gLzLgf2g4rkKecy9aXAQVWQJrjuEyW1PnUFOYmNf4Hjr8aFCPxnGH+lD4qR8qD
cKdSdhfVAzyehreY53xP9uiFSRLkywAk5lWCJYGxGOWbj1K7b+irE2WfZjlARBwu
os6CeVH8eRoy1OlKmas/P9SrJD30SRnlxIvhoKWAqiH7E2YQmZMOwKU3zHWAxDyh
N7v2Nb4RwTfsVcbh8xMq6XSuCIE27t6ZN0zXFRCtoXmsNeOYmyLzutfhRVi7VO9A
ted9e6t4h0I6m21GENPna8kTPYLSShKNxineyiLa6V+pyVeLKMJnWprqEezb7Qi4
h82+0rXABAlz4naPaUOw9izUQQXUArzuFtLUBsUAo0CTyHC005XYDMbatKbMPTcK
9miul462WN527szgL1b38RWJmgfihiam/zCSI05DC8EkSzs2bkfajP3hWqT6AAKE
wxfnYKb7vh7BQfcm1/Iv
=D9xs
-----END PGP SIGNATURE-----

--XaUbO9McV5wPQijU--
