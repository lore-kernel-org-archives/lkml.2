Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2BDMK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 07:10:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41320 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125Ab2BDMK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 07:10:28 -0500
Date: Sat, 4 Feb 2012 12:10:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the gpio tree
Message-ID: <20120204121024.GA8042@opensource.wolfsonmicro.com>
References: <20120203135432.e9ab5f0d41805bff0df10333@canb.auug.org.au>
 <CACxGe6uaxKoqKVyVZsaXZ6s-J3urJ7i_SxP2S-6sXQ7ZqXrYFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <CACxGe6uaxKoqKVyVZsaXZ6s-J3urJ7i_SxP2S-6sXQ7ZqXrYFw@mail.gmail.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 03, 2012 at 04:18:08PM -0700, Grant Likely wrote:

> I've dropped the patch from my tree.  Looks like there are still a few
> drivers that need to be either fixed up or made "depends on
> ARCH_HAVE_CUSTOM_GPIO_H".

Would it not be better to add a followup patch replacing the removed
headers with something like:

  #ifndef __LINUX_GPIO_H
  #warn Don't include asm/gpio.h directly, include linux/gpio.h instead
  #endif

instead?  Perhaps even without the ifdef.  That will mean we still get
rid of the boilerplate and will encourage fixups to drivers, nothing
that hits these can be relying on a custom implementation since all the
headers concerned are boilerplate ones.

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPLSApAAoJEBus8iNuMP3duIgP/1WTnWcvXNzny933H8oug/wr
gGtbMjFLi4l1xlEjSKApsEoTtIxq4xMmpqvF5cfsR+gf8Ste3G1GlaXZze+iCzSy
M6m9lAohX92tfiokx84UqJpAe9ZrtaExITxj0LCmXs3E95K/s1NmcGZdOxHB4V9e
h1ntoNBDJ2o6Cq5AZ4UZbTg3rUVrcZJMQ+Thh0654KWXKp726sRN4qCJMZBx9SUB
lnH0ZS6tbRgmBh9LgB8ObzKkrctaADXlyWkOCJ21eQQVDf3FfUOn7kOUYzP8Sa9y
k1cDGMgPmIrQ0Dut/CG36VMVfVR85h6AuNzoqlHQdyHFkdDXDxNZxb6+wN5c6XDF
aHgshISVX/5zM/gBO73h/xnCvDHBvYI7FQxribkuGKAh71GrqkkLUskUrVpNWU/W
2YvBpdR8/oYQS10lYwDRZ25fqmnTHgwDDzNPpM6QcHskKAnUMJNAoUuP1rFnWTKz
lhIt0dnvZcpjDK0lWijICbUKTAs/u3PsNDbkwnkA3h4plYQeQUfXbqKO/3u7Pqnh
6w0W6mM02XzZyAdAJ5QosCR95ujNnjbkVTK5/3Q/dIGgQnY+s0cLrwpFP4ZdQ9jv
OwICkBxxwFPQe9H24dV0MzHg4ZoWjcnrMSz/iJpn/CGxDXjK+1GVkHi8lCR6ixKI
1OHdpbiirYMngQ1IUtb+
=S4jT
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
