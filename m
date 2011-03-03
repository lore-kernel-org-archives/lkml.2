Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab1CCNZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 08:25:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42312 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab1CCNZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 08:25:53 -0500
Date: Thu, 3 Mar 2011 14:25:49 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Dirk Eibach <eibach@gdsys.de>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, rdunlap@xenotime.net,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] hwmon: (ads1015) Add devicetree documentation
Message-ID: <20110303132549.GG3649@pengutronix.de>
References: <1299143805-13133-1-git-send-email-eibach@gdsys.de>
 <20110303115151.GF3649@pengutronix.de>
 <20110303132025.51e0d92e@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z0mFw3+mXTC5ycVe"
Content-Disposition: inline
In-Reply-To: <20110303132025.51e0d92e@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z0mFw3+mXTC5ycVe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > Hmm, device tree bindings should be OS-neutral, sysfs is not.
>=20
> Why do we document this in the Linux kernel tree then?

To describe which bindings Linux supports.

> > with the active channels. Then again, what is the drawback of exporting
> > all channels?
>=20
> Performance and user-friendliness. libsensors-based applications will
> read all available attributes by default, and each reading takes time.
> Letting the platform declare how the inputs are used allows for a sane
> output for "sensors" and other similar tools out of the box, without
> the user having to tinker with ignore statements in configuration files
> to discard the nonsensical values.

OK, that's fine I'd say.

> > Is there another hwmon-driver doing so (couldn't find one)?
>=20
> If "doing so" means "letting the user define how the ADC inputs are
> used", then yes, the pcf8591 driver does something similar, except that
> it uses a module parameter for the setting, for historical reasons.
> Platform-provided, per-device data is better in my opinion.

OK. The thing is you can't map platform_data 1:1 to bindings, because
most are very specific to the Linux-driver. Do you think something like
"active-channels" would be sufficent for those other hwmon devices, too?
(I still do not like "exported-channels", because there is no need to
export the channels for the OS. The devicetree is primarily a hardware
description language) Or maybe we go specific and say "ads1015,channel1
=3D 1"? Maybe somebody knows of a similar chips as a reference?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Z0mFw3+mXTC5ycVe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1vlt0ACgkQD27XaX1/VRvV1QCgjaQ9BP1I4aFmi3IT31LdSg/N
O7QAmQF418k+5XdzyJI86pn/Jkma1ghO
=bw2/
-----END PGP SIGNATURE-----

--Z0mFw3+mXTC5ycVe--
