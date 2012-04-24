Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2DXMmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:42:35 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:54987 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752Ab2DXMmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:42:33 -0400
Date: Tue, 24 Apr 2012 15:41:18 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tony@atomide.com" <tony@atomide.com>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: tegra: Add SMMU enabler in AHB
Message-ID: <20120424124115.GL8444@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
 <1335269116-9578-2-git-send-email-hdoyu@nvidia.com>
 <20120424123248.GG8444@arwen.pp.htv.fi>
 <20120424.153930.1438573079107186567.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K9FEQnHYtEQyKlzu"
Content-Disposition: inline
In-Reply-To: <20120424.153930.1438573079107186567.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K9FEQnHYtEQyKlzu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 24, 2012 at 02:39:30PM +0200, Hiroshi Doyu wrote:
> From: Felipe Balbi <balbi@ti.com>
> Subject: Re: [PATCH v2 2/3] ARM: tegra: Add SMMU enabler in AHB
> Date: Tue, 24 Apr 2012 14:32:52 +0200
> Message-ID: <20120424123248.GG8444@arwen.pp.htv.fi>
>=20
> > * PGP Signed by an unknown key
> >=20
> > Hi,
> >=20
> > On Tue, Apr 24, 2012 at 03:05:15PM +0300, Hiroshi DOYU wrote:
> > > @@ -95,6 +98,21 @@ static inline void gizmo_writel(unsigned long valu=
e, unsigned long offset)
> > >  	writel(value, tegra_ahb->regs + offset);
> > >  }
> > > =20
> > > +#ifdef CONFIG_ARCH_TEGRA_3x_SOC
> > > +
> > > +void tegra_ahb_enable_smmu(void)
> > > +{
> > > +	unsigned long val;
> > > +
> > > +	val =3D gizmo_readl(AHB_ARBITRATION_XBAR_CTRL);
> > > +	val |=3D AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_DONE <<
> > > +		AHB_ARBITRATION_XBAR_CTRL_SMMU_INIT_DONE_SHIFT;
> > > +	gizmo_writel(val, AHB_ARBITRATION_XBAR_CTRL);
> > > +}
> > > +EXPORT_SYMBOL(tegra_ahb_enable_smmu);
> >=20
> > ok, so this is the only place where you need that global pointer. Who
> > would call this ? Can you do runtime detection of the SoC and enable
> > SMMU based on that ?
> >=20
> > I mean, will this function always be called for TEGRA 3 SoCs or is there
> > another condition to that ?
>=20
> Only Tegra3 has SMMU.

but all of them ? In that case, you could call this from probe itself,
right ? But an ifdef won't work in all cases, so you need to do runtime
detection based on some revision register or cpu detection...

--=20
balbi

--K9FEQnHYtEQyKlzu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlp9rAAoJEIaOsuA1yqRE+2QP/jDyBkm8Ub9HSwXxpmxE4lCS
4f7fcDnuQHy/gUBmOJ6dqHUOKWL0UnsJD5gfvQbcgEpuDPcuazFJ9WwXU8iZlGFY
2j8zbAGSDs5XXIe1sTEAiQJ3i+suvFdg3eublaX9iKsr83rjNA9VFxmOjH7XfHLA
pA0BEtNK/RLK3mezR/lmfSSwhCTlqhhyljW3q8sX9iCJA98qmbX/bVRoxxljz0kI
V9AysChjuG5eml40pv1tDG2Jg1GKUf6uFb0ObYVipw72vd3UFIhneFdHlpF72odp
qG94NuDXBCYG/7RYMYOUrLNNqM4anU19x1K2ok6L8QJ7RX52gugB8ooOXuOYtUD3
pQXbUsb2HsaIZCTPMzpz1rwXHPh64sl8j9CONilFEdU6+Il+6t1oU5w0E7eDJuDJ
59p4SwZZYtC9yPvXF0DeyMRgilAErTzZlIqByOFHeGegUaS4iguquEHADTk1WawN
v9npVlFqcMfoGIfVZ7828RPbAvOxYyEga50IYfsrMx7+aJZPlYQItpOW/z1H88Dh
GLQVqyy5MskK5zB7/7B5Slm3kOpBuLZZUhKV9zbFPkLVT3H6VlmKlxcBQPxhKap9
M3nyBkZ4FMB6f4E7Qgvrxx+aD9esk8sfAjo2GdpMBqwd/tVlouOGF8dwB7bYeuiO
hu49iefejH+O4XDglmhL
=OPEs
-----END PGP SIGNATURE-----

--K9FEQnHYtEQyKlzu--
