Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2BVMzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:55:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58018 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975Ab2BVMzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:55:54 -0500
Date: Wed, 22 Feb 2012 12:55:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] regmap: Add support for writing to regmap `registers'
Message-ID: <20120222125551.GB7340@opensource.wolfsonmicro.com>
References: <1329914630-17624-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <1329914630-17624-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Just to have it is enough.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 22, 2012 at 12:43:50PM +0000, Dimitris Papastamos wrote:
> To enable writing to the regmap `registers' file, users will
> need to modify the source directly and #define REGMAP_ALLOW_WRITE_DEBUGFS.
> The reason for this is that it is dangerous to expose this
> functionality in general where clients could potentially be PMICs.

Applied but...

> +static ssize_t regmap_map_write_file(struct file *file, const char __user *user_buf,
> +				    size_t count, loff_t *ppos)

...with this wrapped into 80 columns.

>  static const struct file_operations regmap_map_fops = {
>  	.open = regmap_open_file,
>  	.read = regmap_map_read_file,
> +#ifdef REGMAP_ALLOW_WRITE_DEBUGFS
> +	.write = regmap_map_write_file,
> +#endif

It's also a bit more idiomatic to have an #else #define function NULL in
the main ifdef for stuff like this; I'll fix that up as well.

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPROViAAoJEBus8iNuMP3dIcYP/0g7enJNeli4ZEqDQuNb07Au
N+uKV2/z0IkFcioXQSjR1kvXIaokHS4i+NKOmCgy6+2nQKj6T9yEahQo1Ayv/XMR
DQNluESidDkLaqMkOl1LQDPA+gndQVk/qkpaWmeEA0dI92fWiNNZY2/lnpYwKpWJ
oJY9QpTYD32fFq3wcvK300i9gi7rge69YxlcmMfpHb5rt2zPxCc9RaVydwB+3PXl
duc6YGLtWu6qf3pQNWUzrBHvKzmPG+tYpfS8ixRD8Gag/9K/2UGf0q060xx8zhiO
3uCmFMRaRBOHdx26FfUQMoCzk9sc81uzv7NsLLFmCvOAqPuM7S1YTvgdq2QjBT9M
J0rgl6lakizfTGI/5Z/pCNSrAUHxXfZUt2NStz9IjgjXa4eHK9+qUhnOjEi8J0+c
Tcu7o36Vg8IJK3F4+T5cKtAlxyawpyAZmXdxVWl5gCUR4ItM5+jJWq2ZgflcGZXT
I7tP+ethPr3Q+D5TIizss7b8vLNkXl2QwaFU3jD/C14um0bYVoNUE42l5QghETPg
8aXVHHh0M7N6txp1DuVcMv5RdvzKXfvPKNGgEU15vxgZqi9gWdvhbaVH5RIWSs9u
Tc6+YOfgaCa05NcsB5LLFPf39PYKY1Ud6ATvO5s8e8HLJWeL6uPyxoJfRVk94psc
6ZKAT1y9/sTLPrbQ9Vlh
=aHI4
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
