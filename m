Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1GVMW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 08:22:27 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:56760 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753667Ab1GVMW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 08:22:26 -0400
Date: Fri, 22 Jul 2011 15:22:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, kishon@ti.com
Subject: Re: [PATCH] arm: omap: usb: clock enable typo fix in usbhs driver
Message-ID: <20110722122221.GG32058@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1311084703-10266-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wQkw7DhpL9hyPo7K"
Content-Disposition: inline
In-Reply-To: <1311084703-10266-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wQkw7DhpL9hyPo7K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 19, 2011 at 07:41:43PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>

$SUBJECT is quite weird. First, this is not a patch on arch/arm/*omap*/
so arm: omap: is already wrong. Also, "enable typo fix" is quite werid.

Something like: "mfd: omap-usb-host: fix clock API usage on
usbhs_disable()" would read better.

> The usbhs_disable function was invoking clk_enable api
> instead of clk_disable; The clk_disable is called to
                        ^ this semicolon should be a period.

ok, you're missing the actual problem here. How about you extend it to
read as:

usbhs_disable function was invoking clk_enable() instead of
clk_disable(), thus only increasing the clock usage counter and
preventing this particular clock from being ever turned off.

Because of that, the power domain where the USB Host subsystem is
located, would never reach lower power states.

> disble the port clocks of usbhs
    ^^ disable.

--=20
balbi

--wQkw7DhpL9hyPo7K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOKWt9AAoJEAv8Txj19kN1ehkIAKvsA8Xu1UJALfc7MTEzuCsu
ClAH6a1Y7Zty5VL3FgB+Lt6O97Fr0waFt6J7axBL/a9NnOH3jn3MH1gOpoQKswYc
PzUYQPo7XDUgKPHF34+OsNe3UOR1FwSRjDVZzea+40wVhZ3OrFWbyDSN4kKpWdsx
h6VuwUml111mJLmigeR76hOQbmaJa4mFHtq+qkv9DrITy3Ficph+UtQMEGIIfh71
0AqMIRTgSirlwmlh/l/2FhrJ3dCet41kvkDRwnbalFtGSVtP4yw7HkZ+4wrLYJYU
GsSe6PFp2mRD18TGCT42ItavMKNaHnmeyf+nyp8x6lsdJbH4YnnlAqKyIFfqGB4=
=Wu4o
-----END PGP SIGNATURE-----

--wQkw7DhpL9hyPo7K--
