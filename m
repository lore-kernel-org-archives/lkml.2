Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab1D0Nfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:35:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38019 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab1D0Nfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:35:38 -0400
Message-ID: <4DB81B9E.3000401@pengutronix.de>
Date: Wed, 27 Apr 2011 15:35:26 +0200
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com,
        Samuel Ortiz <sameo@linux.intel.com>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 01/11] mfd: add pruss mfd driver.
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com> <1303474109-6212-2-git-send-email-subhasish@mistralsolutions.com> <4DB1A603.2090208@pengutronix.de> <EDC1056430EF4DA8A0D850CE1DEA28FC@subhasishg> <4DB7C5F7.3080103@pengutronix.de> <20110427091252.GP17290@n2100.arm.linux.org.uk> <5BAE2D6F9E6047C19B6BE8FF26F7270B@subhasishg>
In-Reply-To: <5BAE2D6F9E6047C19B6BE8FF26F7270B@subhasishg>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7C1FA76626EA78E5E1292373"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7C1FA76626EA78E5E1292373
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/27/2011 03:18 PM, Subhasish Ghosh wrote:
> My problem is, I am doing something like this:
>=20
> s32 pruss_writel_multi(struct device *dev, u32 offset,
>                u32 *pdatatowrite, u16 wordstowrite)
> {
>        struct pruss_priv *pruss =3D dev_get_drvdata(dev->parent);
>        u32 __iomem *paddresstowrite;
>        u16 i;
>=20
>        paddresstowrite =3D pruss->ioaddr + offset;
>=20
>        for (i =3D 0; i < wordstowrite; i++)
>                iowrite32(*pdatatowrite++, paddresstowrite++);
>=20
>        return 0;
> }
>=20
> So, if I make paddresstowrite as void, it will not work. The above
> implementation does not generate any sparse errors though.

Incrementing a u32 pointer will result in increasing the address by 4
bytes. Incrementing a void pointer will result in increasing the address
by just one byte. (Pointer arithmetic on void * is a gnu extension but
IMHO a pretty nice one, though)

regards, Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig7C1FA76626EA78E5E1292373
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk24G6EACgkQjTAFq1RaXHPNOQCfYFNAi9O/JdkJKqfT9PnTMtae
nLEAn1zJtbcGw5K5pkJUWLXCkvfO9pJ5
=Ri1w
-----END PGP SIGNATURE-----

--------------enig7C1FA76626EA78E5E1292373--
