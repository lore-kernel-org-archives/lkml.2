Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333Ab2DZU1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:27:35 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:33525 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758892Ab2DZU1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:27:33 -0400
Date: Thu, 26 Apr 2012 23:26:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi DOYU <hdoyu@nvidia.com>, swarren@nvidia.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Felipe Balbi <balbi@ti.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Jamie Iles <jamie@jamieiles.com>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] ARM: tegra: Add SMMU enabler in AHB
Message-ID: <20120426202610.GA30690@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1335352072-4001-1-git-send-email-hdoyu@nvidia.com>
 <1335352072-4001-2-git-send-email-hdoyu@nvidia.com>
 <4F99A821.2040406@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <4F99A821.2040406@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 26, 2012 at 01:55:13PM -0600, Stephen Warren wrote:
> On 04/25/2012 05:07 AM, Hiroshi DOYU wrote:
> > Add extern func, "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
> > ready.
>=20
> > +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> > +static int __tegra_ahb_enable_smmu(struct device *dev, void *data)
> ...
> > +int tegra_ahb_enable_smmu(void)
> > +{
> > +	return driver_for_each_device(&tegra_ahb_driver.driver, NULL, NULL,
> > +				      __tegra_ahb_enable_smmu);
> > +}
> > +EXPORT_SYMBOL(tegra_ahb_enable_smmu);
> > +#endif
>=20
> That looks like a neat solution to avoid having a global device object.

except that it won't work always. If you happen to have two AHB bridges,
each using a separate smmu but only one smmu is ready, this will set
SMMU_INIT_DONE on both bridges.

> However, if that driver_for_each_device finds no devices, the function
> still succeeds. That doesn't seem right, and doesn't allow e.g. the SMMU
> to defer its probe until the AHB driver has completed.
>=20
> Perhaps add a local int variable to tegra_ahb_enable_smmu(), pass the
> address to __tegra_ahb_enable_smmu, and have it increment the int. Then,
> after calling driver_for_each_device,:
>=20
> if (!ahb_device_count)
>     return -EPROBE_DEFER
> if (WARN_ON(ahb_device_count !=3D 1))
>     return -EINVAL;
> return 0;

that would look, well, weird. Why don't you just different initcall
leves for this ? Maybe smmu goes into postcore_initcall() and tegra_ahb
goes into postcore_initcall_sync() ?? then you know that SMMU will be
ready by the time you call tegra_ahb probe. Well, unless smmu's probe
fail, but then again, IIUC it won't work anyway...

--=20
balbi

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPma9iAAoJEIaOsuA1yqREG8IP/icfZHUq52y6dg7okc0f0FmQ
lHKlp7pa4UL6fr8YG4UFI8m+az/CZ0uMb+P9vliXl/NNigTsuMnrcM+xXzWw86wb
oLRx+8ShsU7PId0DsOVrpjEeeIdszn30KQTcngkLdNaX7I7fm99wfCPAUn7aSBuY
qPffLzhm3yHMp8NE4eC559qjCfrp4rGiRBGVQWUMkN2hlGzNS1j7fiujT90aEeVM
0EIzB58qOX/UZIK2lszbo4x5qlWvQ+i4d/mB/ArypNJnnRVZUcoZc+mFe+R6tDz9
tWlWmxmlMLUDd1gMK6Tsr2JDrhcEQ5P1ER6stNmuVOQxeuoaEHDp63XUCYBalTMK
9jcE1ZiZ4gl5jZYrqIeRHj1XoTTZ5hxZxtQCHe1J5+LMA+S/2ImqGJvVutthjFFG
oIHAmsHrYYttAAJdLIQ/5pjqCArio+mGXCkK8+bpUfN5kq4N53P4FgLcYf71szUa
9v5eYrGqCyptreVl16OssC+2B/LotUUZlGHnx0rTkwU8kdIGPSk9ytApP/baoFjB
e8IGHXMx0a3sAwclFlGyBI3YB+CznDRReNKrcqjg4Hm58bGK2psu+7tcPbDC20SZ
2GvJWSVlfeWjLniKd9Anng47osxu50whSnCtu1eOF04vMTX91AIY2QCkf4vfvSO8
qlJbEZQvO6LN9gle+gdh
=v3Kf
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
