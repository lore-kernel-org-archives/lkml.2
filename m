Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2BFRVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:21:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50573 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754033Ab2BFRVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:21:23 -0500
Date: Mon, 6 Feb 2012 17:21:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add I2C driver for Summit Microelectronics SMB347
 Battery Charger.
Message-ID: <20120206172120.GW3070@opensource.wolfsonmicro.com>
References: <20120206155729.9947.22792.stgit@bob.linux.org.uk>
 <20120206160127.GF10173@sirena.org.uk>
 <20120206162409.4f7536cf@pyramind.ukuu.org.uk>
 <20120206163544.GO3070@opensource.wolfsonmicro.com>
 <20120206170528.6c74f206@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GTZ+2qEBTXdGs1w1"
Content-Disposition: inline
In-Reply-To: <20120206170528.6c74f206@pyramind.ukuu.org.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GTZ+2qEBTXdGs1w1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 06, 2012 at 05:05:28PM +0000, Alan Cox wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > I'm not sure what complexity you mean?  If the interface is too
> > difficult to use we should fix that but I didn't notice anything in the
> > driver which should be more than a straight substitution (or deletion of
> > code in the case of the debugfs file).

> The API seems fine to me but you've then got to implement the
> writeable/readable/volatile reg callbacks and figure out what is cachable
> for the chip and specify it.

All those callbacks are optional, you can tell the API what the maximum
register is with max_register and it should just show all registers
(which is pretty much what you have there) - you only need max_register
so that debugfs does something sensible, though thinking about it we can
probably just assume the maximum possible register value for devices
that don't specify it and have something sensible happen (at least for
smaller address sizes, I'm not sure we want 65535 registers shown by
default for 16 bit address devices).

The cache usage is totally optional too, it's available if you want it
but it won't make sense for all devices and is disabled by default.

--GTZ+2qEBTXdGs1w1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMAwKAAoJEBus8iNuMP3dkY0P/i1JGaZKkr5F33ALVOCN2JqJ
CXeCH4HZBT4kQC+MH3FhmOIRg0ggkbRlYYuUa93WjcfD8/DfJck2wdgkTobQkdpZ
HjzHXri3riXFMab3uDruHMmN6b7a5Vt6nbfyzaNB86m/Iyslu9Y+pHj2YccjUDyh
0QkGl6QjdlhFOfj1fh98k7HJELIjgA2IsfC1/8W8wdl1JZHDtSpEjM6Gxk21QgBl
N1tjS5ileZHZHqy/rCKH8jiho8OSgmYotTlBaJVbUREotKpjKkaD8BXt9gfafeqc
lnOXEAoQB3XubkUhcYkdGxLnDLJ0yu2w176fVlrRLEJaSIbazIIBYBlikxBBDNwK
E9vqh29Mrq4+2HJTxzGjDkNBmr0fSPyBsrQTKVVzWiWluPUqnSbOAJa7YB3xl32l
cbfZTyJ5+xZEYRqCEdpdMA0LzRVBmlh3XzYtDRyvZ4IPNPFNXGltncB01wIuE6WL
4DHSsS4w+AOKvsMncQ0O6BvnX53B4XdigTuFMIkrqGhO9smlG84lSkT2JhqG53sl
iawEjqbzXSVlUdZFIWuptkqs0O2AtaIODHPyTWsEuvQrEcFELO43coI5kMpJ1Ycw
9IOwVV3jSGCl4oW4vwtDY8AsrzDcj7OMe/z7BPNES/Oj96Oat0Iv+B7uQxC3n6KC
iRVVWKD3QpDAUd9OadjP
=4Ajs
-----END PGP SIGNATURE-----

--GTZ+2qEBTXdGs1w1--
