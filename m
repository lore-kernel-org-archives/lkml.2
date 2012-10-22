Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab2JVIB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:01:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47473 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab2JVIBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:01:53 -0400
Date: Mon, 22 Oct 2012 10:56:11 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <balbi@ti.com>, Venu Byravarasu <vbyravarasu@nvidia.com>,
        <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Message-ID: <20121022075611.GC14033@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com>
 <20121019153555.GC440@arwen.pp.htv.fi>
 <50817FEF.70107@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jaoouwwPWoQSJZYp"
Content-Disposition: inline
In-Reply-To: <50817FEF.70107@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--jaoouwwPWoQSJZYp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 19, 2012 at 10:29:35AM -0600, Stephen Warren wrote:
> On 10/19/2012 09:35 AM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Oct 19, 2012 at 04:08:05PM +0530, Venu Byravarasu wrote:
> >> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc. In
> >> order to support USB PHY drivers on these SoCs, existing PHY
> >> driver is split into SoC agnostic common USB PHY driver and
> >> Tegra20-specific USB phy driver. This will facilitate easy
> >> addition and deletion of phy drivers for Tegra SoCs.
> >>=20
> >> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> >=20
> > I was reading this "driver" more closely and I have a bunch of
> > questions about it, but the most important of all of them is: "why
> > isn't that a real PHY driver ?". It doesn't have a probe()
> > function, it doesn't use struct usb_phy to represent the PHY, it
> > has a bunch of tegra-specific APIs and we can't let those
> > continue.
>=20
> One question here: If the PHY "driver" API changes, there will need to
> be a bunch of ehci-tegra.c changes too. Will you take all those

hmm.. indeed.

> through the PHY tree? If you expect to do that, then I'd like to

I can take those if Alan is ok with it :-) Alan ?

> request you also take:
>=20
> usb: host: tegra remove include of <mach/iomap.h>
> http://www.spinics.net/lists/linux-usb/msg72429.html
>=20
> ... since that should get merged before any large changes to
> ehci-tegra.c; it's the EHCI equivalent of the PHY patch you already
> merged.
>=20
> (The same request applies to put that into a branch I can pull into
> the Tegra tree as a basis for cleanup in the Tegra tree)

sure, that should be simple enough to do ;-)

--=20
balbi

--jaoouwwPWoQSJZYp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhPwbAAoJEIaOsuA1yqREhEEP/AuXS/9iaH+fwmmOwfjDj/nT
PZohE+k2/uGNCngqYH5wWGlFpN2ocAnyD4MRdWRr8f1nHwlTctrsmBRTnad3oTo/
nx5OEfW7YdpXBwSbSBsqQYxycrYzf/yQXEBZ0p04l2vTxjd6SBjG3S7C1GRef42U
YvaRAijgFUiwa4SO03bBBjcFTA+GH9UalhrNW6zpICKf9yBQdSvMdj1nwTp6PMku
MRO92cpK24Twq0l+dW8e4+aacPUkS272grsnxOZkfL/RalvKt5oWdJsBo7UMbsv/
fhytfaIFWB9cow6u/uGEgVUf2OMmNITcTGuEQvyjdlPPC4lxRQU+ZavsV99yW7zG
txmKQpopEdTz1VZ8UYcNvZB+OpYSBUbWBdi9dDxrUdZ6UMl+T/LyAGwXdKxGDbZb
vDjiS74NQhO49/2JDkzG5ypLY5PEUw3sa51GmkBakfn8rXonYc1B41dLFo6KoQVA
T0y0EfxxYKiCk54pZ9sRTMr2wcpewRSW61g0ZWEU88jXdWAsRgz7tGTIpLnx9yzr
xNk+w5CaOr2bdnZtlLqM4f+ADJlP5KSjVsa5VQ2fNyyx3DfbCBrO89bOJiP0//Iv
hFN3jEYogdCpFW948MrysZi/UmhobPvfDZnWZR7V/1UGKkTzz4fxZJK1EEUP+E/Y
rf+Rpo2u/RYe7CO+qTkE
=KnkI
-----END PGP SIGNATURE-----

--jaoouwwPWoQSJZYp--
