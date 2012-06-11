Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2FKLQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:16:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50949 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2FKLQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:16:41 -0400
Date: Mon, 11 Jun 2012 19:16:25 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20120611111624.GJ11439@opensource.wolfsonmicro.com>
References: <1339412480-7558-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YPJ8CVbwFUtL7OFW"
Content-Disposition: inline
In-Reply-To: <1339412480-7558-1-git-send-email-jonghwa3.lee@samsung.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v3] clock: max77686: Add driver for Maxim 77686 32KHz
 crystal oscillator
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YPJ8CVbwFUtL7OFW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 11, 2012 at 08:01:20PM +0900, Jonghwa Lee wrote:

> v3
>  - Add mutex to the max77686_clk structure to make atomic execution of enable/disable function.

No, you've not understood the issue.  As I said on my previous review
these need to be prepare() and unprepare() since enable() and disable()
execute in atomic context - that means you can't do I2C I/O and you
can't take mutexes.

--YPJ8CVbwFUtL7OFW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1dOBAAoJEBus8iNuMP3dEdUP/26Cv0rjWZz5OdB38elTL4+K
tNI5DViHif2x1yj5svFUHMJt30XwskklObVOY2ZFjl1vBnL8wB+jt3RtsxOd2YsH
k3uo6K2FGcSjIg7yBwXJTx+7S08Sf8eERc4C5jNPz9zWosDoEcqSOoXI2K4ZgajO
3XgC+pnn+WlYqdW/X4HKd8GWfL5lp3VXC/UuhcMHpi+c/7bNbN9TozR04CRia1AX
K9eJuVqfInIPhlzk5IOVBGqpJwTSGL7UHV6Cm3jxQAPdzfR6mGgjY6YKleJumz8P
skP7WIopl/fJ4XVBWiY3UJMR4LvJGDdicZPuu11tnLsNCuWmDCfHkZusDWf/xzoW
Du9F9zM5Axm2ZqkIS6Xm972uAMIeT7aP9pOh3SIznyd4TyI4+oZyOb4vqLX3pYiR
Lckh8O/Vpp7nKt0qclUPNHm4CTl5yVazjDaO3EO9cYcuhSd5Q9gT/Q9G43r2x0nv
G67w3jYed0cs0eviEbj8xOViNjUh8c3FU4YU7UMGCn0d8te2z8MrWqDZgGNBWOfz
RgDx+gD+EGHTq1VY7EuzbD2QtmrHa7/GN+mV+NX2C18o2rEFCZ3J28CZdrFy67jz
xQ3zE9CTaTuY66yTXn9ECaP/luFbhf5gzTzagUsaoW0b9BiDBSFIF83Tt5eJcHJN
2JjTuZ9i6q5IhCgduEz2
=yBLB
-----END PGP SIGNATURE-----

--YPJ8CVbwFUtL7OFW--
