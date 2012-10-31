Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935573Ab2JaNlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:41:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60752 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605Ab2JaNlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:41:10 -0400
Date: Wed, 31 Oct 2012 15:35:14 +0200
From: Felipe Balbi <balbi@ti.com>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
Message-ID: <20121031133514.GU10998@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <508FA17B.7060308@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cbsCxbAnPLQXdgdB"
Content-Disposition: inline
In-Reply-To: <508FA17B.7060308@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cbsCxbAnPLQXdgdB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 30, 2012 at 10:44:27AM +0100, Dmytro Milinevskyy wrote:
> Convert USB descriptor's fields to CPU byte order before using locally in=
 USB NCM gadget driver.
> Tested on MIPS32 big-endian device.
>=20
> Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
> ---
>  drivers/usb/gadget/f_ncm.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
> index b651b52..0b9e2ad 100644
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
> @@ -869,15 +869,15 @@ static struct sk_buff *ncm_wrap_ntb(struct gether *=
port,
>  	struct sk_buff	*skb2;
>  	int		ncb_len =3D 0;
>  	__le16		*tmp;
> -	int		div =3D ntb_parameters.wNdpInDivisor;
> -	int		rem =3D ntb_parameters.wNdpInPayloadRemainder;
> -	int		pad;
> -	int		ndp_align =3D ntb_parameters.wNdpInAlignment;
> -	int		ndp_pad;
> +	int		div, rem, pad, ndp_align, ndp_pad;

I would not combine them in a single line. Keep them one per line.

cheers

--=20
balbi

--cbsCxbAnPLQXdgdB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkSkSAAoJEIaOsuA1yqREitUQAIMw5znrJjA/MFB1Pd7swBHc
aUQWoV3njUsKagv35DnQ6JB38UusKGbt2SAli1j7oTwKGHhE9czDan8+8JU/dEGl
rRVV0OFWEq0B+Ez2Kv4VG5g6+9r0Bh1MJkRysQWdCHvRiFFfrv6XXz8zgQjK5TRl
Ua1qSRLm672PlOM21IOrmFH+edM+l1e3MVNPdc178HjNUm7zbD+ptKRqv5bjaD5G
6RdtBP1o4Vgjr1sZ9CTL6Y4TMDoSigyNXH7NdhHi5BhRRPdESh8qyyGaaKicpEY0
2gZSKJUmgeDsvOpJOfL6zI+M60cfiAUvvtf1Mlr4cbkdGs9NtlQeg1+cfMu5S26q
6YFQ8qHLIdfmKVx9Ry4kwD0kPWapEViPClOVYyTNY3e0CehqHSEm4shDCQks5fNl
UZg8ejccAdD93KN+nLFsTEfOsUpOhYQ+blqgah2b+Od18Bv2mOutMU5LTc4VJOlI
/B6YuKb/qWwIbAlTlg/MaSInsGt8xgtlJ/dxB0QHPKn3NbaCQAcbS4LjYOL3Mykg
kdGuh54Uj/Xx1hskF4yulrewmrh8axN42J3mIErcmfsiw/9AvNsyFdLy37yEv9YZ
sso6KeGFCtQneCz0nUSRQMhHxvlfdMsOcbxyxpo8HNLpfXOv+x6xgL256TUOyHSd
zs/G1RruL2nuSrobUKhN
=GeIb
-----END PGP SIGNATURE-----

--cbsCxbAnPLQXdgdB--
