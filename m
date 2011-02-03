Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1BCInQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 03:43:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49660 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1BCInP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 03:43:15 -0500
Date: Thu, 3 Feb 2011 09:43:09 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] RTC: Fix rtc driver ioctl specific shortcutting
Message-ID: <20110203084309.GA20679@pengutronix.de>
References: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
 <1296699283-6784-3-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <1296699283-6784-3-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
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

On Wed, Feb 02, 2011 at 06:14:41PM -0800, John Stultz wrote:
> Some RTC drivers enable functionality directly via their ioctl method
> instead of using the generic ioctl handling code. With the recent
> virtualization of the RTC layer, its now important that the generic
> layer always be used.
>=20
> This patch moved the rtc driver ioctl method call to after the generic
> ioctl processing is done. This allows hardware specific features or
> ioctls to still function, while relying on the generic code for handling
> everything else.

I guess the documentation should be updated, too. Currently it says:

Note that many of these ioctls need not actually be implemented by your
driver.  The common rtc-dev interface handles many of these nicely if your
driver returns ENOIOCTLCMD.  Some common examples:
=2E..

That situation has changed after your patch.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1Kap0ACgkQD27XaX1/VRuN7ACfTvntWAHJyO2X5uXwV+AUXN0t
H0QAoIl+aqnRiB9cAviVGqBh2dyd7t5T
=RLaL
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
