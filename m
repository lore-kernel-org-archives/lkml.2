Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab2BJLGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:06:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44564 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758670Ab2BJLGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:06:21 -0500
Date: Fri, 10 Feb 2012 11:06:19 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1] regmap: add bulk_write() for non-volatile register set
Message-ID: <20120210110618.GB3056@opensource.wolfsonmicro.com>
References: <1328789531-10067-1-git-send-email-ldewangan@nvidia.com>
 <20120209121704.GF3058@opensource.wolfsonmicro.com>
 <4F33BFDE.7020006@nvidia.com>
 <20120209125505.GI3058@opensource.wolfsonmicro.com>
 <4F33FEE7.9080608@nvidia.com>
 <20120209181224.GK3058@opensource.wolfsonmicro.com>
 <4F34DFC7.3020208@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <4F34DFC7.3020208@nvidia.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 10, 2012 at 02:43:43PM +0530, Laxman Dewangan wrote:

Please remember to delete unnneded context from your mails, it makes it
much easier to find what you're saying.

> So I am going to allocate buffer for some size, initially
> min(val_bytes * max_register, 128) bytes, and in bulk_write(), if
> require buffer is more than 128 then re-alloc buffer which is now
> (req_size + 128).
> And then copy the data into this buffer, modify it and send to device.

What I'd suggest doing as a first pass is just allocating the buffer
each time, anything else is a performance optimisation we can worry
about incrementally.  Remember, this only has to be faster than I2C most
of the time and I2C is really slow.  For your case with 8 byte values
there's an even better optimisation which is to notice that we don't
need to swap at all and just use the original buffer directly.

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPNPokAAoJEBus8iNuMP3dHaUP/iiEmqUC0Hc8X64JLgp/9IdK
g/nw2TF/Ht3knFD/5VJX2LGuCkyXd2LWZR4sFjsfRIdV78oo+Dq6W9VH9uYLleA6
3rLewJUX329oPqfy263T7oReY8ZeEGxxf+Z/qhkQ0gKK0zqoAghfX4cIvjcPoxa/
VhfTJnxyhk8yajjnjzjJV7ErMtrgVFqsi9F4v1dcAEDeWorzyqPC6BitqWAszyxC
KwV8/sN8iYi8tTkW5vixErkT+A/deCKO2hJ/+5D1gaCDeDu4Lzpe5nX1wv+eYjl8
NBur2VaSxuMfOAa/WxynW4zeawZOb2H8UfM+ViZaou5S+gNa7j+UMtPYEHtTWxbe
7JpCsvqFKwn3rakk9ofl6697kivAx77vhEyZNmZdMg66+SZsJa0vcKT8aP8BlhWp
ztrNWTFMymFK9peOPCHRSqnZiRAdqupfgj9f80o/Hyh9aoL3uAkRbL6HsGbCv/uI
F81tLUu6XShw6Z1C6rnohB0UGahTTqxAfCaiP9atiGlHInmQHWY+wrrafOyd8PYi
XXlHN4Np7LWfCf7NaqOoFLWmcCK2NpPlH5a2mzKM3M4aRuqSo8RrbvqLDAmul+pz
Af7i30JyLPOa0T14zbm3LtnW4bcx0U/4eX2bjCmNZPrHow9Zz+LPYHYEpcrysn1W
Kg8B+TgqiBqfWUXfbUOC
=hN1T
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
