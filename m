Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab1IXGxj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 02:53:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37573 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1IXGxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 02:53:38 -0400
Date: Sat, 24 Sep 2011 08:53:32 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: Austin Boyle <Austin.Boyle@Aviatnet.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rtc-linux] Re: [PATCH 2.6.39-rc7] RTC: rtc-ds1307 EEPROM
 support for ds1388 chip
Message-ID: <20110924065332.GA19721@pengutronix.de>
References: <1306127917.3071.32.camel@pc786-ubu.gnet.global.vpn>
 <1308024897.2992.39.camel@pc786-ubu.gnet.global.vpn>
 <20110722145451.78390257.akpm@linux-foundation.org>
 <1312151457.24642.5747.camel@pc786-ubu.gnet.global.vpn>
 <20110923160445.68c3098e.akpm@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20110923160445.68c3098e.akpm@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 23, 2011 at 04:04:45PM -0700, Andrew Morton wrote:
> On Mon, 1 Aug 2011 10:30:57 +1200
> Austin Boyle <Austin.Boyle@Aviatnet.com> wrote:
>=20
> > [PATCH 3.0] RTC: EEPROM support for DS1388
> >=20
> > This patch adds support for different sized NVRAM, such as
> > the 512 bytes of EEPROM on the DS1388 chip.
>=20
> This patch is causing problems in today's linux-next, with x86_64 allmodc=
onfig:

Sorry, I missed the patch so far. The whole approach is not correct.

The EEPROM uses a different I2C slave address (0x69+0x6a) than the RTC (0x6=
8).
So, you should be able to use the ds1307-driver on address 0x68 (maybe with
minor modifications, didn't check that) and the eeprom part using the
at24-driver on address 0x69, selecting the 24c02-type. Despite saving redun=
dant
code, at24 handles peculiarities of EEPROMs much better. Can you please rep=
ort
if that works for you?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk59fmwACgkQD27XaX1/VRs+gQCgiyUY8nT7azjCZk1Xg7WYGUcl
Pg0AoKLsX4uEcNzH53EH7041q+4x64fX
=OLDR
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
