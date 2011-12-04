Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1LDLrw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 06:47:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56913 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1LDLrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 06:47:49 -0500
Date: Sun, 4 Dec 2011 12:47:41 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Heiko Schocher <hs@denx.de>
Cc: Wolfgang Denk <wd@denx.de>, Vitaly Bordug <vbordug@ru.mvista.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] drivers, char: add U-Boot bootcount driver
Message-ID: <20111204114741.GA5788@pengutronix.de>
References: <1322991921-21096-1-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <1322991921-21096-1-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 10.1.0.3
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 04, 2011 at 10:45:21AM +0100, Heiko Schocher wrote:
> This driver implements the Linux kernel half of the boot count feature -
> the boot counter can only be reset after it is clear that the
> application has been started and is running correctly, which usually
> can only be determined by the application code itself. Thus the reset
> of the boot counter must be done by application code, which thus needs
> an appropriate driver.

An appropriate mechanism, not necessarily a driver, see below.

> Required feature by the Carrier Grade Linux Requirements Definition;
> see for example document "Carrier Grade Linux Requirements Definition
> Overview V3.0" at
>=20
> http://www.linuxfoundation.org/collaborate/workgroups/cgl/requirements#SM=
M.6.0_Boot_Cycle_Detection
>=20
>       Description: OSDL CGL specifies that carrier grade Linux
>       shall provide support for detecting a repeating reboot cycle
> 	due to recurring failures. This detection should happen in
> 	user space before system services are started.

So, technically, a flag would be enough, not necessarily a counter? Althoug=
h a
counter probably has more advantages...

> This driver provides read/write access to the U-Boot bootcounter
> through PROC FS and/or sysFS file.

Why ProcFS? Why ProcFS and/or SysFS? Which has priority? Why not /dev?

> The bootcountregister gets configured via DTS.
> for example on the enbw_cmc board:
>=20
> bootcount@0x23060 {
>                   compatible =3D "uboot,bootcount";

No. I assume you are not the vendor of what is at 0x23060, the actual devic=
e.
Only the device must be encoded in the compatible-entry which then implies =
the
bootcount functionality. Also, keep in mind that your solution should be
generic for bootloaders.

>                   reg =3D <0x23060 0x20>;

I assume that non-volatile memory would qualify as a boot-counter, so those
could be tied to I2C busses etc? reg would not fit then.

I do wonder if it makes more sense to add such functionality to the
watchdog-core to save the additional device (CCed). Needs a second thought,
though...

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7bXd0ACgkQD27XaX1/VRtikACfUVsugIOq9HGDOCZJnqSKyFnL
tJMAoJgohhT9H7MwsdkZxL9YbjNGR8K0
=z91i
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
