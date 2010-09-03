Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab0ICM06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:26:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38134 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0ICM05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:26:57 -0400
Date: Fri, 3 Sep 2010 14:26:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Masayuki Ohtak <masa-korg@dsn.okisemi.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Crane Cai <crane.cai@amd.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, yong.y.wang@intel.com, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, arjan@linux.intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_I2C driver to 2.6.35
Message-ID: <20100903122619.GC4813@pengutronix.de>
References: <4C80CBC0.5050908@dsn.okisemi.com>
 <20100903133613.1c519c49@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
In-Reply-To: <20100903133613.1c519c49@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 03, 2010 at 01:36:13PM +0100, Alan Cox wrote:
> > +config PCH_I2C_CH_COUNT
> > +	int "PCH I2C the number of channel count"
> > +	range 1 2
> > +	depends on PCH_I2C
> > +	help
> > +	  This driver is for PCH(Platform controller Hub) I2C of Topcliff whi=
ch
> > +	  is an IOH(Input/Output Hub) for x86 embedded processor.
> > +	  The number of I2C buses/channels supported by the PCH I2C controlle=
r.
> > +	  PCH I2C of Topcliff supports only one channel.
>=20
> These sort of settings need to be runtime so one kernel can be built for
> many platform variants. In this case if I understand correctly the
> current device only has one channel so the define could just be moved
> into the driver for now and made a variable later as/when/if new hardware
> with more channels appears.
>=20
>=20
>=20
> > +static s32 pch_wait_for_xfer_complete(struct i2c_algo_pch_data *adap)
> > +{
> > +	s32 ret;
> > +	ret =3D wait_event_interruptible_timeout(pch_event,
> > +			(adap->pch_event_flag !=3D 0), msecs_to_jiffies(50));
> > +	if (ret < 0) {
> > +		pch_err(adap, "timeout: %x\n", adap->pch_event_flag);
> > +		return ret;
> > +	}
>=20
> You are reporting a timeout when _interruptible can also be woken by a
> signal to the process (eg the user hitting ^C)

Sidenote: a number of embedded drivers decided to switch to
wait_event_timeout() recently because reacting to a signal may have
subtle issues and must be carefully implemented and tested. Stalled
busses were often the consequence. I don't know if this applies here but
better keep it in mind.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyA6WsACgkQD27XaX1/VRvuegCePEjeDK6jbUpGowZEgn4sypLr
SF0An3IpzLGC7sR79cqh3JN8jUABMu3P
=0AiJ
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
