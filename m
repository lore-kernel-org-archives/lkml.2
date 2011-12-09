Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1LINw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 08:52:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34824 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1LINwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 08:52:55 -0500
Message-ID: <4EE212AE.40005@pengutronix.de>
Date: Fri, 09 Dec 2011 14:52:46 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] flexcan: Acknowledge all interrupt sources in the IRQ
 handler
References: <1323438454-6816-1-git-send-email-LW@KARO-electronics.de>
In-Reply-To: <1323438454-6816-1-git-send-email-LW@KARO-electronics.de>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC0D3D5080627EE142F18E624"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC0D3D5080627EE142F18E624
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/09/2011 02:47 PM, Lothar Wa=C3=9Fmann wrote:
> Otherwise the handler will get stuck in an endless IRQ loop when an
> interrupt condition occurs that is not being acked (e.g. TWRN)

On which CPU do you have this problem?

Seems that mx25/35 behave a bit different than mx28. But I had no time
to dig into this, yet. BTW Wolfgang is just reworking error handling,
can you please test his patches he recently posted on linux-can.

cheers, Marc


> Signed-off-by: Lothar Wa=C3=9Fmann <LW@KARO-electronics.de>
> ---
>  drivers/net/can/flexcan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index e023379..ea8f04d 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -577,7 +577,7 @@ static irqreturn_t flexcan_irq(int irq, void *dev_i=
d)
> =20
>  	reg_iflag1 =3D flexcan_read(&regs->iflag1);
>  	reg_esr =3D flexcan_read(&regs->esr);
> -	flexcan_write(FLEXCAN_ESR_ERR_INT, &regs->esr);	/* ACK err IRQ */
> +	flexcan_write(reg_esr, &regs->esr);	/* ACK all IRQs */
> =20
>  	/*
>  	 * schedule NAPI in case of:


--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enigC0D3D5080627EE142F18E624
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7iErEACgkQjTAFq1RaXHM7lQCgi0ZYI8AzXbzM6UoZpixJilCW
3iwAn33/ewcUA1G74Ug8gpLrku3uiNBE
=OMmq
-----END PGP SIGNATURE-----

--------------enigC0D3D5080627EE142F18E624--
