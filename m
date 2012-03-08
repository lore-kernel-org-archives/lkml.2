Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab2CHWcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:32:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47819 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828Ab2CHWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:32:03 -0500
Date: Thu, 8 Mar 2012 23:31:56 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH v4] USB: Support for LPC32xx SoC
Message-ID: <20120308223155.GA19176@pengutronix.de>
References: <1331244574-32570-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <1331244574-32570-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> --- linux-2.6.orig/drivers/usb/host/ohci-hcd.c
> +++ linux-2.6/drivers/usb/host/ohci-hcd.c
> @@ -1055,6 +1055,11 @@ MODULE_LICENSE ("GPL");
>  #define PLATFORM_DRIVER		usb_hcd_pnx4008_driver
>  #endif
> =20
> +#ifdef CONFIG_ARCH_LPC32XX
> +#include "ohci-pnx4008.c"
> +#define PLATFORM_DRIVER		usb_hcd_pnx4008_driver
> +#endif

Can't we just do

#if defined(CONFIG_ARCH_PNX4008) || defined(CONFIG_ARCH_LPC32XX)

to save the duplicate entry?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9ZM1sACgkQD27XaX1/VRuJjgCgo6pF6usxjRxbnrEb0RxKNisf
eD8AoMOF5nqx7y1maxZcZV0HTSNPODlP
=tvmb
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
