Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab2KNH3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:29:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46589 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab2KNH3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:29:14 -0500
Date: Wed, 14 Nov 2012 16:28:56 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kevin Liu <keyuan.liu@gmail.com>
Cc: m.szyprowski@samsung.com, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, lrg@ti.com,
        Philip Rakity <prakity@nvidia.com>
Subject: Re: FW: [PATCH v2] mmc: sdhci: apply voltage range check only for
 non-fixed regulators
Message-ID: <20121114072855.GF7407@opensource.wolfsonmicro.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C060FBEA29A@SC-VEXCH1.marvell.com>
 <CADz5_gLC=z_VYrNq8q3dU7L6im7shSz-Sn6Tzym2mRZONwpgUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9ADF8FXzFeE7X4jE"
Content-Disposition: inline
In-Reply-To: <CADz5_gLC=z_VYrNq8q3dU7L6im7shSz-Sn6Tzym2mRZONwpgUg@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9ADF8FXzFeE7X4jE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 03:11:37PM +0800, Kevin Liu wrote:

> -		ret = regulator_set_voltage(host->vqmmc, 3300000, 3300000);
> +		ret = regulator_set_voltage(host->vqmmc, 2700000, 3600000);

Should this be regulator_set_voltage_tol()?  Otherwise it'd be good to
explain where the numbers come from.

> +		ret = regulator_is_supported_voltage(host->vmmc, 1700000,
> +			1950000);

We should really add a regulator_is_supported_voltage_tol...  let me
just do that.

--9ADF8FXzFeE7X4jE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQo0ftAAoJELSic+t+oim9F2gP/0YoaO/BX4RA/oHyCBZkprGv
W3hwQRxDEpvkr6+CNMKK/Bo6U2NgsuXQTAh1YrFwon1VIhQ3/eDekIJ+9mn+o7pI
biEmJC5Uy4U6KRua8r386vbJ6CqHJFzNCjtbM/yaDnkrUxQm0KmxK0pRRQXxmk0i
e/l2jnyXOY/ujfNNo8jDk/VOTc638SdwAkHxAwUoz93zeAKCmUW1A9V2rF0tjsDS
tcJKGX4ahppWCC05Y6jp/fCD0Tn9HFu4VaRdZ8N2cNtuFq8BspxyLAZsSPFQubTx
aBkAW63IKozfaQNGYBCWt3Vgg0LhxQL9jCra80InfSs5cjA8OdikwqbofaBeCxBp
5ClnTwGRMpd5t0juztarkrE6Buqj8hm4V8PZUyyDS9Id6nSTafwTbyKDdLd00oEh
tbmPKVg8KJQw7aVr85/lTpSudQ/Na16+IHj2k3u2CBg1X8l5Yhu+Z8N35/ypXC1c
g9W6VKhD6YWHk1sSasyQRyZBOazDbQapyYx+zy5fJy4VjvJ+HZfTKWlfK7Bi52sX
nmX5YSGfuVMVl2yKiSfWW/ZOS6t9E0Ug0GbjKABlCBz8LKMNhQmj3egjFGrjHdBk
g4Zzzfzcuhk+h09CmWwNjo4/66J6M48P/FJjtTdXroiPs/srZVf0zwS7IN3N1Gfy
KC+gaqZmSFQI9yknEdHp
=gFcK
-----END PGP SIGNATURE-----

--9ADF8FXzFeE7X4jE--
