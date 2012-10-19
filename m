Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab2JSPlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:41:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53835 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2JSPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:41:31 -0400
Date: Fri, 19 Oct 2012 18:35:56 +0300
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Message-ID: <20121019153555.GC440@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 19, 2012 at 04:08:05PM +0530, Venu Byravarasu wrote:
> NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> In order to support USB PHY drivers on these SoCs, existing
> PHY driver is split into SoC agnostic common USB PHY driver
> and Tegra20-specific USB phy driver. This will facilitate
> easy addition and deletion of phy drivers for Tegra SoCs.
>=20
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>

I was reading this "driver" more closely and I have a bunch of questions
about it, but the most important of all of them is: "why isn't that a
real PHY driver ?". It doesn't have a probe() function, it doesn't use
struct usb_phy to represent the PHY, it has a bunch of tegra-specific
APIs and we can't let those continue.

Please, take a look at drivers/usb/phy/omap_usb2.c (misnamed actually,
should be phy-omap-usb2.c so we have a common prefix) to see how your
PHY driver should look like and which sort of functionality if should
expose to the rest of the kernel.

Please comment on the above.

cheers

--=20
balbi

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQgXNbAAoJEIaOsuA1yqREYMQP/3FB0K6T6VEmsnLfeL4AGXUp
hLJL+AunqjCOk4CrCACeMFpyR+lt/V7OObOgRxUVmPAOJD+8i3ZemBhMJR2HhD+a
05Pz71fxzrcp5bCPR7U3sHEqC8kv8K8M+MPGX8OFqnIeAHnhCta/CdGvHyTo7/gt
2RGUMItI4B3qLKu1wTapU7VhX9J9wscdw7tLzIEc2rGas6zHZTjXTEyIPZXEfBYe
L4SAeGw7RKi/NuIG4L4j2VZ6BH9N/KUI98rw3DGs6wz5oew9szdXP+xeni76QybJ
SU1eaeDslXz5/Bx61DurVKRWElaqHb124stsoqYyp/8gzlt6xYgHVia4O09cUCWp
nAbEZVVZ9xfi/SAIZLz6D8orvb95ukuPE/YpzEysh++WLZPzjUe1biwOtg6/yg41
iDGWmprl1A1dc/9EFz/v+xLLWkfcnuFuDvhfiZBiNDBzK3yMmoceZO1Vqmp3NjEl
iKEwS1OxvhsChYB7J0qwJAV1uxsrWxwAcgeFAhhmu7SRzQoYejy6BxMEoIm65dBS
ku4ly5FH0J642QNKY72Dz993mFPtmBRUz6oVNUn5kCEuKI35fDyStJ7xAZkH4xLe
AIUtIyOjbi7J+T0nkgQphOfLog4+O/nM6UZfCixtoHnuMF0Z6KRcJ+6k9ViDz127
j2T0yRuBSNUf26FnNGa6
=Ocvz
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
