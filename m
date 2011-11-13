Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab1KMVxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 16:53:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44373 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1KMVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 16:53:34 -0500
Date: Sun, 13 Nov 2011 22:53:18 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jesper Nilsson <Jesper.Nilsson@axis.com>,
        Mikael Starvik <mikael.starvik@axis.com>,
        Darron Black <darron@griffin.net>
Subject: Re: [PATCH] RS485: fix inconsistencies in the meaning of some
 variables
Message-ID: <20111113215318.GA2966@pengutronix.de>
References: <4E492CFF.7040905@pwrnet.de>
 <20110822211832.GA8023@kroah.com>
 <4EB3A009.10502@evidence.eu.com>
 <4EB8F6B9.6010008@atmel.com>
 <4EB90902.4030200@evidence.eu.com>
 <20111108134804.07095c5d@lxorguk.ukuu.org.uk>
 <20111108142432.GA11293@kroah.com>
 <4EBA9385.7010806@evidence.eu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <4EBA9385.7010806@evidence.eu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I have been working on a patch series which adds hardware RS485 to the 8250
according to the latest developments. The series will be posted tomorrow af=
ter
some more tests. However, there is one thing I wondered about:

> From now on, SER_RS485_RTS_AFTER_SEND and SER_RS485_RTS_ON_SEND will be u=
sed to
> set the voltage of the RTS pin (as in the crisv10.c driver); the delay wi=
ll be
> understood by looking only at the value of delay_rts_before_send and=20
> delay_rts_after_send.

Do I overlook something or is SER_RS485_RTS_AFTER_SEND always the inverted
signal of SER_RS485_RTS_ON_SEND. So why do we need both? (BTW
SER_RS485_RTS_ON_SEND is a non-obvious name, I think. But changing it will
probably break even more users?)

> diff --git a/include/linux/serial.h b/include/linux/serial.h
> index 97ff8e2..3d86517 100644
> --- a/include/linux/serial.h
> +++ b/include/linux/serial.h
> @@ -207,13 +207,15 @@ struct serial_icounter_struct {
> =20
>  struct serial_rs485 {
>  	__u32	flags;			/* RS485 feature flags */
> -#define SER_RS485_ENABLED		(1 << 0)
> -#define SER_RS485_RTS_ON_SEND		(1 << 1)
> -#define SER_RS485_RTS_AFTER_SEND	(1 << 2)
> -#define SER_RS485_RTS_BEFORE_SEND	(1 << 3)
> +#define SER_RS485_ENABLED		(1 << 0)	/* If enabled */
> +#define SER_RS485_RTS_ON_SEND		(1 << 1)	/* Logical level for
> +							   RTS pin when
> +							   sending */
> +#define SER_RS485_RTS_AFTER_SEND	(1 << 2)	/* Logical level for
> +							   RTS pin after sent*/

Nit: 80 char should be broken here, because that is not readable. Or put the
comment above the define.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7APE4ACgkQD27XaX1/VRuYXQCdHOJJrjlq3XYasvCrZBm6rsYn
huIAoLXeVu4Dru98adHkCtNA8n/kEWFg
=/CdF
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
