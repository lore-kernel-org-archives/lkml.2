Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab2BCHQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:16:34 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:50537 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831Ab2BCHQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:16:32 -0500
Date: Fri, 3 Feb 2012 09:16:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [Patch] musb: fix a build error on mips
Message-ID: <20120203071624.GA24297@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328253257-14092-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <1328253257-14092-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 03, 2012 at 03:14:17PM +0800, Cong Wang wrote:
> On mips, we got:
>=20
> drivers/usb/musb/musb_io.h:44: error: conflicting types for 'readsl'
> arch/mips/include/asm/io.h:529: error: previous definition of 'readsl' wa=
s here
> drivers/usb/musb/musb_io.h:46: error: conflicting types for 'readsw'
> arch/mips/include/asm/io.h:528: error: previous definition of 'readsw' wa=
s here
> drivers/usb/musb/musb_io.h:48: error: conflicting types for 'readsb'
>=20
> so, should add !defined(CONFIG_MIPS) too.
>=20
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>=20
> ---
> diff --git a/drivers/usb/musb/musb_io.h b/drivers/usb/musb/musb_io.h
> index e61aa95..1d5eda2 100644
> --- a/drivers/usb/musb/musb_io.h
> +++ b/drivers/usb/musb/musb_io.h
> @@ -39,7 +39,8 @@
> =20
>  #if !defined(CONFIG_ARM) && !defined(CONFIG_SUPERH) \
>  	&& !defined(CONFIG_AVR32) && !defined(CONFIG_PPC32) \
> -	&& !defined(CONFIG_PPC64) && !defined(CONFIG_BLACKFIN)
> +	&& !defined(CONFIG_PPC64) && !defined(CONFIG_BLACKFIN) \
> +	&& !defined(CONFIG_MIPS)
>  static inline void readsl(const void __iomem *addr, void *buf, int len)
>  	{ insl((unsigned long)addr, buf, len); }
>  static inline void readsw(const void __iomem *addr, void *buf, int len)

Thanks a lot, will apply.

--=20
balbi

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPK4nIAAoJEIaOsuA1yqREbHQP/32/G+cb+2NrTY9ccvc0bzqF
t1hPFzXVzQenSIwuUTlS+Wf0H1IfiAzgpZi2EFD16jKe8WjFHmgYVW0yDbNYmq5n
OcDW8B9Y0ihI4oC3AglCgvQ5Gw52osfijwVFe4nFxu6osdBcRYdQy4DMNX8X5myS
Tpr3iWH/uSQbFi25GPehBELH/005OpANk3b1wlo2U6iOcqHbEL3DCZuzRdo2rkHv
EB3FXSa5L/Rd8TJbzq514FVr+yfr8l+M74xYhMSuhwzhAGXvxWLsjChcD7z5RfyF
BEoWsmpUyt+KvxV3wJ6G7sijm4mTQcZZz/ljU36YRZUsxK98iSIhsxdZibcPxDay
pQQyrTl/X7HEWwkpqUQvj31JJr4C5x5k6Uno0b0B0QXIRperSHGewGEbn/6woFEu
o3a2eJHX+AOPWDSe+zi+/KxfspxJa58OwMZvtpOABIW9kDz6mR1cdiDOt5Cj6rHD
zKXsD6xUqyj4JwCxG7rKvjNzWjnwo7mjnePrwYO82y21LhiCytO2k7fkregx6/8U
sZwU//RMV83ypkN0JHagE7C4U0xqHOh2c1fV7ORE8XpfqXe8awb78idrZmv5pmnd
EIJGwiCZeY+aERtZaQx2GYcwsoA9tQhKfIKQv2mWIQWi21x0tr20lotVWi71RNn0
mi6OHnHpuPZ91EYTrWOb
=NJ/8
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
