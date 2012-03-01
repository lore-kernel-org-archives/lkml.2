Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab2CALag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 06:30:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39830 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202Ab2CALae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 06:30:34 -0500
Date: Thu, 1 Mar 2012 11:30:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v5 1/2] mfd: Add anatop mfd driver
Message-ID: <20120301113031.GD3124@opensource.wolfsonmicro.com>
References: <1330593052-15184-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OaZoDhBhXzo6bW1J"
Content-Disposition: inline
In-Reply-To: <1330593052-15184-1-git-send-email-paul.liu@linaro.org>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OaZoDhBhXzo6bW1J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 01, 2012 at 05:10:51PM +0800, Ying-Chun Liu (PaulLiu) wrote:

> +	spin_lock(&adata->reglock);
> +	val = readl(adata->ioreg + addr);
> +	spin_unlock(&adata->reglock);

Do you really need to take a lock for a single read operation from a
memory mapped register?  I'd expect this to be atomic in itself.  You
need to lock on read/modify/write cycles to make sure that you don't get
a read/read/modify/modify/write/write and misplace one of the modifies
but that's not an issue for an isolated read.

--OaZoDhBhXzo6bW1J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPT1voAAoJEBus8iNuMP3dWSkP/i2qSXLpNISFEJqiBxtEhiTg
AMOdDZo10K9LnAuAoeVjORqNqe2nL+U4vSNCytieK5LNbO8e69abIuwI1pDgR3vw
d9HTDnCwBlEXhwmbpdS94PGJPs9bRK9HXLBwH06jkrndq1qarcJ4WkXF6ttfYema
fA1ZvthzP7zB4xsZJPIR3Du2S/dZH9L7rJXSab4GJfUsx8b9n6hb+JLaeZRI/b38
vqirUFwrY9BY84dKTKi09T7mUgpkqNJbexTtPEx93oefQRlAZJA1ccy2X6qnwcAN
D3qQLZJMf3miGuOpt1fYxRrPZ+iOY/GbhTppFhEn6hbg7QMxogkcihb93zB6vB6S
LVH7vLllNk2GQXD+yHW6P1MAfzOQZqT0w0YKisNF05G9/O1ZnWydv41ylYNwl85F
iveiZlrtOiqljeE/s9d/9pR4pKewl88BNrt+jU9NQ1OC7sRmTKhuCXQe/blcLLDQ
Me9tGHzJ9X7k9as5cDSr6ezvVYuALKheM4R29j2hkkScjV0b2x+W8n0XUbZXLQYg
fU5jJMCpA6NiaDgTIbVRrJ3qY++aFJARBItpcKjXp8HxAkfhhVgPuqbwtXcpZPRU
r5EmEcXbK3AWoycIcC29gnRZi0802KZ8FpF364ihAInuX9uBoPD94CZuktJSH5Q5
Wb6JK/mBOXrp/zsQXqFB
=30p8
-----END PGP SIGNATURE-----

--OaZoDhBhXzo6bW1J--
