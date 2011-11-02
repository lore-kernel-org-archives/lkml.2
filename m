Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1KBXHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 19:07:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46445 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1KBXG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 19:06:59 -0400
Date: Thu, 3 Nov 2011 00:06:52 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Austin Boyle <Austin.Boyle@aviatnet.com>
Cc: rtc-linux@googlegroups.com, David Anderson <danders.dev@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: ds1307: generalise ram size and offset
Message-ID: <20111102230652.GA10696@pengutronix.de>
References: <1320267555.3000.13.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <1320267555.3000.13.camel@pc786-ubu.gnet.global.vpn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 03, 2011 at 09:59:15AM +1300, Austin Boyle wrote:
> From: Austin Boyle <Austin.Boyle@aviatnet.com>
>=20
> This patch generalises NVRAM to support RAM with other size and offset, s=
uch
> as the 64 bytes of SRAM on the MCP7941x.
>=20
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: David Anderson <danders.dev@gmail.com>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
> Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>

Looks good to me in general, with one exception.

> ---
> this patch is based on Wolfram Sang's tree:
> git://git.pengutronix.de/git/wsa/linux-2.6.git ds1307
>=20
> patch depends on:
> rtc: ds1307: comment and format cleanup 21af5f7bd6
> rtc: ds1307: simplify irq setup code  8c63e03627
> rtc: ds1307: refactor chip_desc table e246db081d
> rtc: add initial support for mcp7941x parts e69bba2d3a
>=20
> --- a/drivers/rtc/rtc-ds1307.c	2011-10-10 11:22:22.674690998 +1300
> +++ b/drivers/rtc/rtc-ds1307.c	2011-11-03 09:13:06.662159569 +1300
> @@ -104,10 +104,12 @@ enum ds_type {
> =20
>  struct ds1307 {
>  	u8			offset; /* register's offset */
> +	u16			ram_offset;
> +	u16			ram_size;
>  	u8			regs[11];
>  	enum ds_type		type;
>  	unsigned long		flags;
> -#define HAS_NVRAM	0		/* bit 0 =3D=3D sysfs file active */
> +#define HAS_RAM	0			/* bit 0 =3D=3D sysfs file active */

Why the rename from NVRAM to RAM everywhere? While it doesn't matter much f=
or
most occurences...

> -static struct bin_attribute nvram =3D {
> +static struct bin_attribute ram =3D {
>  	.attr =3D {
> -		.name	=3D "nvram",
> +		.name	=3D "ram",
>  		.mode	=3D S_IRUGO | S_IWUSR,
>  	},

=2E.. here it will break userspace.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6xzQwACgkQD27XaX1/VRvxFgCcDIAhsiheS4t7Wk2m51uCe9QH
l/8AoJRUh0nGo1+pr6hvxr/iSFIgf2QA
=W9Nn
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
