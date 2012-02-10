Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759187Ab2BJLpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:45:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33164 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab2BJLpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:45:44 -0500
Date: Fri, 10 Feb 2012 11:45:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] regmap: Support for caching in reg_raw_write()
Message-ID: <20120210114541.GB6472@opensource.wolfsonmicro.com>
References: <1328873572-12603-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <1328873572-12603-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2012 at 05:02:52PM +0530, Laxman Dewangan wrote:

This looks good, but could you make the few small improvements below
please?

> +	if (!map->cache_bypass && map->format.parse_val) {
> +		int val_bytes = map->format.val_bytes;
> +		unsigned int ival;
> +		for (i = 0; i < val_len / map->format.val_bytes; i++) {

A bit nit picky but since you've got a local val_bytes you may as well
use it.

> +			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
> +			ival = map->format.parse_val(map->work_buf);
> +			ret = regcache_write(map, reg + i, ival);
> +			if (ret) {
> +				dev_warn(map->dev,
> +					"Error in caching of register\n");

Say which register and the return value here - knowing the register
might be very helpful for debug.  This should probably also be at least
a dev_err().

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNQNfAAoJEBus8iNuMP3dvl4QAJXDu0MPk+oWCsua2sdGprtf
AAnjUwTO5/0CfFnElfn+GHCBTXlf/QnIsxz42u+7QF9cjz3x2jqL2mmoRLEIK1w9
tvVL4U5huXi+I+1UcMGhIwh5+1MtPJhsEPteBVevv5/RRWU4IcniMhosRQeyPRrq
9E7LIUQ18niV68AxihDqnWc0JO0LpnU5OZFJyFJeP5r4cYVFpVwE1m5zlki9iJjL
5w0pZIJ8HO46k0myXDUwE2vjgqKyX2HLKiXLwXVLDP/+/nyW/xRi1wZnSuD4EYnw
Ce3iT3Q4YsT1XaxENeh9DWJs14J6W6YkrxVX0vbqzl1sL4i8WRw5iUlw8tgb2Fv2
0ZohwpEa/Tt1LnF1K2bu+BL//zJwrxaxW+k/qPcoW/F+Ts8/Cn5z17PRyQxQL77J
I92xkIYmmD4s+CNJayZZ3/oETF2JPkEdFRRs9Pc3ByRXG3nxRZNWga4DwmrOcBIM
djz86tSe+FP5SddLYEhqua25B/ZVgXxENVL/tnJPcWg3pU+4CQY1UnOuL8qVjUM+
CD/Fk4tfviltjHm3PGe8CxrjLUaA8yzBg7d1dU7wUxxv34xLuI4q6ZcWkY5fjB4m
GimbWBbyfnVsCE+F+he7Fbi/+Me0hyBWT5wi5QTYX3XbLus2mILZEIY/K+GcJYUg
s7a0dcFN1tCndbLuFT3u
=2/MY
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
