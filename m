Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab1K2Lb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:31:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36984 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1K2Lb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:31:26 -0500
Date: Tue, 29 Nov 2011 12:31:24 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Marc Vertes <marc.vertes@sigfox.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Dimitry Andric <dimitry.andric@tomtom.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: Re: [PATCH] watchdog: add nowayout helpers to Watchdog Timer
 Driver Kernel API
Message-ID: <20111129113124.GE5455@pengutronix.de>
References: <20111129111430.GA17609@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XuV1QlJbYrcVoo+x"
Content-Disposition: inline
In-Reply-To: <20111129111430.GA17609@infomag.iguana.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XuV1QlJbYrcVoo+x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2011 at 12:14:30PM +0100, Wim Van Sebroeck wrote:
> Add two nowayout helpers for the Watchdog Timer Driver Kernel API.
>=20
> Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> ---
> diff --git a/Documentation/watchdog/00-INDEX b/Documentation/watchdog/00-=
INDEX
> index fc51128..fc9082a 100644
> --- a/Documentation/watchdog/00-INDEX
> +++ b/Documentation/watchdog/00-INDEX
> @@ -1,5 +1,7 @@
>  00-INDEX
>  	- this file.
> +convert_drivers_to_kernel_api.txt
> +	- how-to for converting old watchdog drivers to the new kernel API.

Since the howto needs a NOWAYOUT-update as well, I suggest I'll send a
patch for that and take care of the missing index-entry there?

> @@ -142,6 +142,14 @@ bit-operations. The status bits that are defined are:
>  * WDOG_NO_WAY_OUT: this bit stores the nowayout setting for the watchdog.
>    If this bit is set then the watchdog timer will not be able to stop.
> =20
> +To set the WDOG_NO_WAY_OUT status bit (before registering your watchdog
> +timer device) you can either:
> +* set it statically in your watchdog_device struct with
> +	.status =3D WATCHDOG_NOWAYOUT_INIT_STATUS,
> +  (this will set the value the same as CONFIG_WATCHDOG_NOWAYOUT) or
> +* use the following helper function:
> +static inline void watchdog_set_nowayout(struct watchdog_device *wdd, in=
t nowayout)
> +

I think one level of indentation would be helpful here so it visually
belongs to the WDOG_NO_WAY_OUT paragraph?

> +/* Use the following function to set the nowayout feature */
> +static inline void watchdog_set_nowayout(struct watchdog_device *wdd, in=
t nowayout)
> +{
> +	if (nowayout)
> +		set_bit(WDOG_NO_WAY_OUT, &wdd->status);
> +}
> +

Other than that:

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

So, shall I fix the s3c-driver based on that or will you do?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--XuV1QlJbYrcVoo+x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7UwowACgkQD27XaX1/VRuiEQCeJZB8ZlEA93hFj/jgNsIqIQ9F
4mgAoKBr9Zk/s/+14/7RzsspeiNfNVaf
=aQDJ
-----END PGP SIGNATURE-----

--XuV1QlJbYrcVoo+x--
