Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2ELNIP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 09:08:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44941 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab2ELNIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 09:08:13 -0400
Date: Sat, 12 May 2012 15:07:56 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, swarren@wwwdotorg.org,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 2/2] i2c: tegra: notify transfer-complete after
 clearing status.
Message-ID: <20120512130756.GI20673@pengutronix.de>
References: <1336373179-12739-1-git-send-email-ldewangan@nvidia.com>
 <1336373179-12739-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wjoFZxbW4tu+iR6v"
Content-Disposition: inline
In-Reply-To: <1336373179-12739-3-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wjoFZxbW4tu+iR6v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 07, 2012 at 12:16:19PM +0530, Laxman Dewangan wrote:
> The notification of the transfer complete by calling complete()
> should be done after clearing all interrupt status.
> This may avoid the race condition of misconfigure the i2c controller
> in multi-core environment.

"may avoid" or "does avoid"? I.e. does it fix any bug that really
occured? Then I'd add a stable tag.

So far, applied to next.

>  	if (status & I2C_INT_PACKET_XFER_COMPLETE) {
>  		BUG_ON(i2c_dev->msg_buf_remaining);
>  		complete(&i2c_dev->msg_complete);
>  	}

Side note: If you see a way to handle the BUG invocations more
gracefully, that would be appreciated.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--wjoFZxbW4tu+iR6v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+uYKwACgkQD27XaX1/VRsVBgCguFJmH6yHRVL2H34Zc0S0G5Xe
kIoAn3OmV02dJOiu/S0rBej/Wiz3nLTV
=34To
-----END PGP SIGNATURE-----

--wjoFZxbW4tu+iR6v--
