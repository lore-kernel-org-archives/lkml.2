Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1LFVvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:51:03 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55689 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab1LFVvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:51:01 -0500
Date: Tue, 6 Dec 2011 22:50:56 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Heiko Schocher <hs@denx.de>
Cc: Wolfgang Denk <wd@denx.de>, Vitaly Bordug <vbordug@ru.mvista.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] drivers, char: add U-Boot bootcount driver
Message-ID: <20111206215056.GD14154@pengutronix.de>
References: <1322991921-21096-1-git-send-email-hs@denx.de>
 <20111204114741.GA5788@pengutronix.de>
 <4EDCD7B2.5030409@denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Content-Disposition: inline
In-Reply-To: <4EDCD7B2.5030409@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Heiko,

> >> This driver provides read/write access to the U-Boot bootcounter
> >> through PROC FS and/or sysFS file.
> >=20
> > Why ProcFS? Why ProcFS and/or SysFS? Which has priority? Why not /dev?
>=20
> I drop the ProcFS support for v2.

Don't bother. This approach starts from the wrong side.

>=20
> >> The bootcountregister gets configured via DTS.
> >> for example on the enbw_cmc board:
> >>
> >> bootcount@0x23060 {
> >>                   compatible =3D "uboot,bootcount";
> >=20
> > No. I assume you are not the vendor of what is at 0x23060, the actual d=
evice.
> > Only the device must be encoded in the compatible-entry which then impl=
ies the
> > bootcount functionality. Also, keep in mind that your solution should be
> > generic for bootloaders.
>=20
> So I should call it compatible =3D "generic, bootcount" ?

Nope, you should give it the name of the device. Remember that 'compatible'=
 is
no 1:1 replacement for platform_driver-binding. Check
http://devicetree.org/Device_Tree_Usage, especially the sections about the
compatible-property.

bootcount itself is not a device. It is a feature of certain devices. And t=
hat
needs to be implemented; possibly generic enough that it can work for regis=
ter
based, i2c based, and so forth, accesses.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEARECAAYFAk7ejkAACgkQD27XaX1/VRsK8gCgsBZlpGkToxR4W/TNp7j9yOmo
8TEAmNpVaf1A7KManfT9jWcx10Ntn/M=
=k/HJ
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
