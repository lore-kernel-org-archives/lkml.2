Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab2EaH3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 03:29:04 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:53476 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757272Ab2EaH3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 03:29:01 -0400
Date: Thu, 31 May 2012 10:25:42 +0300
From: Felipe Balbi <balbi@ti.com>
To: Joe Perches <joe@perches.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] usb: gadget: pch_udc: Fix likely misuse of | for &
Message-ID: <20120531072541.GC5377@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <cover.1338408931.git.joe@perches.com>
 <2530fb0cbede64dad718d41012156043d1ca424e.1338408931.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
In-Reply-To: <2530fb0cbede64dad718d41012156043d1ca424e.1338408931.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 30, 2012 at 01:25:57PM -0700, Joe Perches wrote:
> Using | with a constant is always true.
> Likely this should have be &.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

this looks good to me. Do you want me to carry it on my tree ?

If you want to carry it out as a fix:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/pch_udc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
> index 1cfcc9e..f4fb71c 100644
> --- a/drivers/usb/gadget/pch_udc.c
> +++ b/drivers/usb/gadget/pch_udc.c
> @@ -2208,7 +2208,7 @@ static void pch_udc_complete_receiver(struct pch_ud=
c_ep *ep)
>  			return;
>  		}
>  		if ((td->status & PCH_UDC_BUFF_STS) =3D=3D PCH_UDC_BS_DMA_DONE)
> -			if (td->status | PCH_UDC_DMA_LAST) {
> +			if (td->status & PCH_UDC_DMA_LAST) {
>  				count =3D td->status & PCH_UDC_RXTX_BYTES;
>  				break;
>  			}
> --=20
> 1.7.8.111.gad25c.dirty
>=20

--=20
balbi

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPxxz1AAoJEIaOsuA1yqREQfMP/RkU+WLS8OduTuYrM9IJnIY8
Xm3fkezHHZAqqp8zo9NXCSfKrXZC0OY51Unv6xAZngTn/xZA6QRR7ZLFwsK4nEos
6/yFd4zdGmvtGl5RGtyQnISCgUfc/p9OF+HPKB6XsuNTJgpgsC/aYQ1QR6hEaA55
ZRHnT3ZjO9fdjcNsRPu5gqH+nb+1puNNXaVw8Hcw2OtwZzLVPMPLmxQyE/yTMphy
slksLXJdQZi727EXtNKxHpmoRC4rL0uQAwLbBpP82lZXcjIHzpaqE2XB/6QmvZFR
XjU/iyy5hTBlSxgrqROf+aDLT6+Q1T6PgntUvsRNx0LEgstRxvnjj3hDRCPWG9qh
UzW6/3kFBpBRsZmihuhk27TCY5LqpvVcmiJzH+7amJopBWNl4v4kmzJPQdFeg9YR
L7epivNxOzD8Fegq8yVluj0jKFSCNLM4ToXqdlP11pb1L2mxJ16bw+nDu0N3h65g
XCxm+13/ZN1YMkD0iPGeLCb9sz6QdwB05i1Ih8t4eA5RatElfvy4F7lnVfqNvSKY
p7GJWc9648s5Jt+eKN2iOATq0IXBBsfihAkgAExC4w+LtErxWAAB39teKYldND6f
TgE4AmjEkwNFZnkerawv+Uq2GObmtI2kxnhTMsQJbqhcjimdsFWqLwjNKYQvAy9v
Dlox22qj+QGK3cAsddQI
=LPev
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
