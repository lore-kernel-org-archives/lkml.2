Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab1GKVfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:35:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55552 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab1GKVfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:35:19 -0400
Date: Mon, 11 Jul 2011 23:35:18 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 06/11] watchdog: WatchDog Timer Driver Core - Add Magic
 Close feature
Message-ID: <20110711213518.GG5811@pengutronix.de>
References: <1310392522-9949-1-git-send-email-wim@iguana.be>
 <1310392522-9949-6-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lQSB8Tqijvu1+4Ba"
Content-Disposition: inline
In-Reply-To: <1310392522-9949-6-git-send-email-wim@iguana.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lQSB8Tqijvu1+4Ba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>  static int watchdog_release(struct inode *inode, struct file *file)
>  {
> -	int err;
> +	int err =3D -EBUSY;
> +
> +	/*
> +	 * We only stop the watchdog if we received the magic character
> +	 * or if WDIOF_MAGICCLOSE is not set
> +	 */
> +	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
> +	    !(wdd->info->options & WDIOF_MAGICCLOSE))
> +		err =3D watchdog_stop(wdd);
> =20
> -	/* stop the watchdog */
> -	err =3D watchdog_stop(wdd);
> +	/* If the watchdog was not stopped, sent a keepalive ping */

s/sent/send/

>  	if (err < 0) {
>  		pr_crit("%s: watchdog did not stop!\n", wdd->info->identity);
>  		watchdog_ping(wdd);

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--lQSB8Tqijvu1+4Ba
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4bbJYACgkQD27XaX1/VRsNZwCgvabZD0yxVb/z96GsA2VDNDdC
vc8An0lN5amuFy/40DHQ3DyQzrcU9gda
=gR+0
-----END PGP SIGNATURE-----

--lQSB8Tqijvu1+4Ba--
