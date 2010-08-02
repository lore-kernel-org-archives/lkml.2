Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab0HBMpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:45:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48556 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab0HBMpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:45:16 -0400
Date: Mon, 2 Aug 2010 14:45:14 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sascha Hauer <s.hauer@pengutronix.de>,
        Daniel Mack <daniel@caiaq.de>
Subject: Re: [098/140] USB: ehci-mxc: bail out on transceiver problems
Message-ID: <20100802124514.GD6193@pengutronix.de>
References: <20100730173205.GA22581@kroah.com>
 <20100730173111.572059486@clark.site>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xesSdrSSBC0PokLI"
Content-Disposition: inline
In-Reply-To: <20100730173111.572059486@clark.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xesSdrSSBC0PokLI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 30, 2010 at 10:31:03AM -0700, Greg KH wrote:
> 2.6.33-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: Wolfram Sang <w.sang@pengutronix.de>
>=20
> commit 4c9715de52b9b6256bf1e9510917111a47b0c176 upstream.
>=20
> The old code registered the hcd even if there were no transceivers
> detected, leading to oopses like this if we try to probe a non-existant
> ULPI:
>=20
> [    2.730000] mxc-ehci mxc-ehci.0: unable to init transceiver
> [    2.740000] timeout polling for ULPI device
> [    2.740000] timeout polling for ULPI device
> [    2.750000] mxc-ehci mxc-ehci.0: unable to enable vbus on transceiver
> [    2.750000] mxc-ehci mxc-ehci.0: Freescale On-Chip EHCI Host Controller
> [    2.760000] mxc-ehci mxc-ehci.0: new USB bus registered, assigned bus =
number 2
> [    2.770000] Unhandled fault: external abort on non-linefetch (0x808) a=
t 0xc4876184
> [    2.770000] Internal error: : 808 [#1] PREEMPT
> [    2.770000] last sysfs file:
> [    2.770000] Modules linked in:
> [    2.770000] CPU: 0    Not tainted  (2.6.33.5 #5)
> [    2.770000] PC is at ehci_hub_control+0x4d4/0x8f8
> [    2.770000] LR is at ehci_mxc_setup+0xbc/0xdc
> [    2.770000] pc : [<c0196dfc>]    lr : [<c019bc8c>]    psr: 00000093
> [    2.770000] sp : c3815e40  ip : 00000001  fp : 60000013
> [    2.770000] r10: c4876184  r9 : 00000000  r8 : c3814000
> [    2.770000] r7 : c391d2cc  r6 : 00000001  r5 : 00000001  r4 : 00000000
> [    2.770000] r3 : 80000000  r2 : 00000007  r1 : 80000000  r0 : c4876184
> [    2.770000] Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM Segme=
nt kernel
> [    2.770000] Control: 0005317f  Table: a0004000  DAC: 00000017
> [    2.770000] Process swapper (pid: 1, stack limit =3D 0xc3814270)
> ...
>=20
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Acked-by: Daniel Mack <daniel@caiaq.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Daniel mentioned that this patch could cause a "regression" with boards
which have hardware problems in form of a floating chip select
(originating from the reference design!). For such boards, the probing
might now fail, leaving the boards without USB, while it worked before
(although it only worked because of ignoring the actual problem).

I can't make my mind if it is better to fix the potential OOPS or to
keep those boards working for older kernels. I just wanted to mention
it, so this is issue won't be overlooked.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--xesSdrSSBC0PokLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxWvdoACgkQD27XaX1/VRsnuQCfUL8+X7MEkzyanQOXppYiK3Ei
4EIAnjAAR+TC3rAJAj4klAe+p3E4S67O
=xz2z
-----END PGP SIGNATURE-----

--xesSdrSSBC0PokLI--
