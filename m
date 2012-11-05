Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2KEKmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:42:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49403 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab2KEKmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:42:50 -0500
Date: Mon, 5 Nov 2012 11:42:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: tps80031: add regulator driver for
 tps80031
Message-ID: <20121105104246.GC1385@opensource.wolfsonmicro.com>
References: <1352108658-14289-1-git-send-email-ldewangan@nvidia.com>
 <1352108658-14289-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <1352108658-14289-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 05, 2012 at 03:14:18PM +0530, Laxman Dewangan wrote:

> +	switch (ri->device_flags) {
> +	case 0:

Should we be using different versions of the ops depending on the device
flags rather than having these switches?  It seems like we can't change
at runtime and it would make the code a lot simpler.

> +		if (sel < 57)
> +			voltage = 607700 + 12660 * sel;
> +		else if (sel == 57)
> +			voltage = 1350 * 1000;
> +		else if (sel == 58)
> +			voltage = 1500 * 1000;
> +		else if (sel == 59)
> +			voltage = 1800 * 1000;
> +		else if (sel == 60)
> +			voltage = 1900 * 1000;
> +		else if (sel == 61)
> +			voltage = 2100 * 1000;

This looks like a switch statement with a default case (as do most of
these).

> +	ret = tps80031_write(parent, ri->rinfo->volt_id,
> +			ri->rinfo->volt_reg, sel + 1);

Why the + 1 (and - 1 in the get()).  I'd expect we can just use the
register value directly as a selector.

> +	if (!(ri->config_flags & VBUS_SW_ONLY)) {
> +		dev_err(&rdev->dev, "%s() is not supported with flag 0x%08x\n",
> +			 __func__, ri->config_flags);
> +		return -EIO;
> +	}

Same as the device flags above - we should this be set by changing the
ops when we register?

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQl5ggAAoJELSic+t+oim9BW0QAIQTnef0FCTE6BTQC7rrefgm
aitjZu6N+NV4aI7knyfKUZRa4Qs7o8Bm5iozvx/xPxdvYiNB5V1iaws8WAEn/ej3
a42XMpVBJ8/gjlkurf/jfcsqO4EYNqVkOaDIRGsVmsoBsMqNd+hhFoOA76kpRB58
5XMqe+UysiaKjsQE60Jr+xrCxsQ4EGDI82GiEfgvHs/133GNxBuegNqW9de4MZGA
QdBIE6ewrL5PjxPb3OjiyiIELuVtZMHoXyhx/7pnv9yn7IRGr6ZcXf+K0AcOwlgO
WD6/N6PiBsl0imjdL8jQPej4V3TNrW5qKi4qiGsG6Mx2RGez+qAus7O5UDis/Dr6
zFJcfts+eP2INyrvy7L5Zl1NYkbJn/V0/9PQUG++RoBbrjjHi0HimXJxWmYB/RGb
f6Zen6CoDueE8+mdj4Pw/385pXsuAJPpKOeCz+msAqm8Ee91dbAO7aNUutEUwq4M
96lXRPk/vqcMX8GVZtOEFvyDWnmT1HNSfNHcQuL97P8+RXCc2Etg13+zwuV2bXWs
Bh3D8k3y15/zIFM055bwVH2LvuuJz8mZgIwrf8DQFfcZROPNhJBXpO+ojA2dxmJD
YOxaTYBlX8PAmOh8oSYcsSKyK8wK7wl0GRB88j6mpyPvrjJ+FpzS7HB1aPHblbIj
rV9OPeMZbE+EeyeyPzqv
=drTy
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
