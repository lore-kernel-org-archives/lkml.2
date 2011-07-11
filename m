Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab1GKVcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:32:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53266 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1GKVcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:32:52 -0400
Date: Mon, 11 Jul 2011 23:32:51 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 02/11] watchdog: WatchDog Timer Driver Core - Add basic
 ioctl functionality
Message-ID: <20110711213251.GD5811@pengutronix.de>
References: <1310392522-9949-1-git-send-email-wim@iguana.be>
 <1310392522-9949-2-git-send-email-wim@iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
Content-Disposition: inline
In-Reply-To: <1310392522-9949-2-git-send-email-wim@iguana.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> +static long watchdog_ioctl(struct file *file, unsigned int cmd,
> +							unsigned long arg)
> +{
> +	void __user *argp =3D (void __user *)arg;
> +	int __user *p =3D argp;
> +	unsigned int val;
> +
> +	switch (cmd) {
> +	case WDIOC_GETSUPPORT:
> +		return copy_to_user(argp, wdd->info,
> +			sizeof(struct watchdog_info)) ? -EFAULT : 0;
> +	case WDIOC_GETSTATUS:
> +		val =3D wdd->ops->status ? wdd->ops->status(wdd) : 0;
> +		return put_user(val, p);
> +	case WDIOC_GETBOOTSTATUS:
> +		return put_user(wdd->bootstatus, p);
> +	default:
> +		return -ENOTTY;
> +	}
> +	return -ENOTTY;

I think one of the -ENOTTY could be removed?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4bbAMACgkQD27XaX1/VRu75wCdEWJzAWed6g4qdcs+iucQXlL0
3XQAoJOJ0anObhtnD2iL6udQEv/tC2Id
=m6RX
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--
