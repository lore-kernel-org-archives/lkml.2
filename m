Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2KFLd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:33:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:49156 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab2KFLd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:33:57 -0500
Date: Tue, 6 Nov 2012 13:27:51 +0200
From: Felipe Balbi <balbi@ti.com>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
Message-ID: <20121106112751.GD11931@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <50929233.7030609@gmail.com>
 <50967BFD.6000308@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FEz7ebHBGB6b2e8X"
Content-Disposition: inline
In-Reply-To: <50967BFD.6000308@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FEz7ebHBGB6b2e8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 04, 2012 at 03:30:21PM +0100, Dmytro Milinevskyy wrote:
> Convert USB descriptor's fields to CPU byte order before using locally in=
 USB NCM gadget driver.
> Tested on MIPS32 big-endian device.
>=20
> Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>

doesn't apply:

$ patch -p1 --dry-run < patch.diff
patching file drivers/usb/gadget/f_ncm.c
patch: **** malformed patch at line 31: @@ -869,15 +869,19 @@ static struct=
 sk_buff *ncm_wrap_ntb(struct gether *port,

can you use git-send-email ?

> ---
>  drivers/usb/gadget/f_ncm.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
> index b651b52..a7cdd47 100644
> --- a/drivers/usb/gadget/f_ncm.c
> +++ b/drivers/usb/gadget/f_ncm.c
> @@ -102,7 +102,7 @@ static inline unsigned ncm_bitrate(struct usb_gadget =
*g)
>  				 USB_CDC_NCM_NTB32_SUPPORTED)
>  static struct usb_cdc_ncm_ntb_parameters ntb_parameters =3D {
> -	.wLength =3D sizeof ntb_parameters,
> +	.wLength =3D cpu_to_le16(sizeof(ntb_parameters)),
>  	.bmNtbFormatsSupported =3D cpu_to_le16(FORMATS_SUPPORTED),
>  	.dwNtbInMaxSize =3D cpu_to_le32(NTB_DEFAULT_IN_SIZE),
>  	.wNdpInDivisor =3D cpu_to_le16(4),
> @@ -869,15 +869,19 @@ static struct sk_buff *ncm_wrap_ntb(struct gether *=
port,
>  	struct sk_buff	*skb2;
>  	int		ncb_len =3D 0;
>  	__le16		*tmp;
> -	int		div =3D ntb_parameters.wNdpInDivisor;
> -	int		rem =3D ntb_parameters.wNdpInPayloadRemainder;
> +	int		div;
> +	int		rem;
>  	int		pad;
> -	int		ndp_align =3D ntb_parameters.wNdpInAlignment;
> +	int		ndp_align;
>  	int		ndp_pad;
>  	unsigned	max_size =3D ncm->port.fixed_in_len;
>  	struct ndp_parser_opts *opts =3D ncm->parser_opts;
>  	unsigned	crc_len =3D ncm->is_crc ? sizeof(uint32_t) : 0;
> +	div =3D le16_to_cpu(ntb_parameters.wNdpInDivisor);
> +	rem =3D le16_to_cpu(ntb_parameters.wNdpInPayloadRemainder);
> +	ndp_align =3D le16_to_cpu(ntb_parameters.wNdpInAlignment);
> +
>  	ncb_len +=3D opts->nth_size;
>  	ndp_pad =3D ALIGN(ncb_len, ndp_align) - ncb_len;
>  	ncb_len +=3D ndp_pad;
> --=20
> 1.8.0
>=20
>=20

--=20
balbi

--FEz7ebHBGB6b2e8X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQmPQ3AAoJEIaOsuA1yqREnlwP/3w7wJSZ+tgQ9shYGROuen37
VxDOZgekovDllMx7UChDqCRtxdx3o+4pIgPPGY/OO7Z+utbSi7NY5irkve76PXLO
vcJg6YOsJx9tqVyJ3+mG5JxFdqCrMRUAcXqnnu/51lfkrmH2dWmnnxBrms5m62cs
4L3WDo68hck+LIVjDBgdZ5zPNSW3NqiCt4cU6UpjE4hOWzCHY8iqgI2hetpxdV+V
EC5nkf60JcrOUJP2i+2CGwSgLO9s3X7Kelt649yhEt7NMVMjS/mOjznBXVTitPFI
t/BZbys0G01D5G0bppTbA5jMc78pcbRBb+xCbfIEFpSAGjcedTnXoszXAV7f44n7
4QXBigXwmNVAZNkVb/aNI3/PFnGQ0YvjL+HgjQu1TFvzAfVR5+0mfZ7tecX/6wtI
mamH7Qnhin39d7hvn64SrcvTXCF6ar+tV0ZtUOo6npTauvckPBEY6A493l49APyK
4+JUjeiCZkQZ78u6xbVM1fUFAxIK239XGAsKNimhnLrxhF5TViqrOjtY8y+Mci7P
WNRnmyZ6IJOn3UpuPdqdc2QTJIqZaAqAB7QIEaUbZ8AjoljjcCdmJ8Dk71wwFOQ/
hdvYBXXnWc/dUhqUrW1MjiqYwkfTTXNFWMcP23ZjJiO51u8evanjQZJG+tZt8OcL
PGqCVE4bGKLlqpi4CXcJ
=JMcZ
-----END PGP SIGNATURE-----

--FEz7ebHBGB6b2e8X--
