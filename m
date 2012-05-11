Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946226Ab2EKVaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:30:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41135 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422631Ab2EKVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:30:08 -0400
Date: Fri, 11 May 2012 22:30:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "lrg@ti.com" <lrg@ti.com>, Stephen Warren <swarren@nvidia.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V3 2/4] regulator: tps62360: add dt support
Message-ID: <20120511213001.GD29835@opensource.wolfsonmicro.com>
References: <1336718325-8372-1-git-send-email-ldewangan@nvidia.com>
 <1336718325-8372-3-git-send-email-ldewangan@nvidia.com>
 <20120511145833.GG3960@opensource.wolfsonmicro.com>
 <4FAD31A5.7090006@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8w3uRX/HFJGApMzv"
Content-Disposition: inline
In-Reply-To: <4FAD31A5.7090006@nvidia.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8w3uRX/HFJGApMzv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 11, 2012 at 09:05:01PM +0530, Laxman Dewangan wrote:

> Yaah, I think this flag can map directly to REGULATOR_MODE_FAST. If
> I understand PWM mode properly then this is used when high current
> load is require or fast switching on  load current is require. By
> enabling force PWM enable, hw will not switch to PFM mode based on
> load current.

> I think if we map the regulator mode to FAST as the force PWM enable
> and NORMAL as force PWM =0 then it will be generic.

Yes, this is pretty much exactly what _FAST means.  With modern hardware
the forced PWM mode just isn't needed, a modern regulator is able to
respond sufficiently quickly to changes in the output load.  Mode
switching from software was generally found to be impractical for DCDC
convertors as the load requirements change so quickly and without
software control that by the time you respond from software you can't
switch out of a lower power mode into a higher current one it's too late.

> >>+- ti,enable-vout-discharge: Enable output discharge. This is boolean value.
> >This I think we should definitely add a framework feature for this and
> >make into a generic property, it's a very standard feature and more
> >normally set unconditionally.

> I think this is not require to enable always otherwise there may be
> power dissipation from this path always, just when we off the rail
> (disable rail or when go to shutdown so that the voltage output can
> go down faster).
> Should we add "unsigned en_discharge:1" in regulator init data but
> did not get how core driver can use this flag specially when
> shutdown?

Oh, now you say this I think I remember discussing this with you before!
This is pretty unusual for such hardware.  Normally there's something in
the digital block so that the discharge is only enabled if the regulator
is disabled, if it's enabled then the discharge would automatically be
taken off since actively discharging while enabled doesn't make sense
and may in fact be actively harmful.

If the hardware doesn't do that then I'd expect the driver to take care
of this if it implements the framework feature (once the framework
feature is added).

--8w3uRX/HFJGApMzv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPrYTTAAoJEBus8iNuMP3dmboP/ipdBdDDV433RCAePQPE1uKo
NZKEBdKf9nOQwfwI2WPfjfl1hAhmwjPTKdm3qWtO+SeEtsHl0uDNWvaBQIet1cb8
vY7EQpo9UIRJ4RNmlu4ak/lPdp+dDetM+SvxGEPtrkKf1GOJ9/OGFdmwfYp+vSO7
PVUFyWT1RPeHcl1MP2cFYSH1zKlLX8Vds7b7iDX+KWFOeMql9Fzbzopp0OC2EY1D
Cjd1nLyXdF/Bop5cVWlkpZugt6aOdTjBtiQaMvFT78YbSEOJZ7Fb+paaRVOA0osv
BAASuxCl0i788ks/OTGDUiwAPtgp8FSqpR/s8I3RvidYYKLg+JHO/KHAf5ZHKab7
P2bifSCmIQ8V1RaKYLEceugk/UPAj83VX/Mtk/dmMrFXiv9uFBBXpObQJKcL2k9J
ko0XPghSI0dRyZreAsCYiAHA/zRKpBFlctIljc6taT7hsQplwhy0eybT3dguUIH3
gkvLzmK5Be40YzQfnbtd7Ib1LezBmwoAPBEAQ+3oXoQJ8IYwiCuB22g2OzrFBXbl
O3UEsaxgQcjWfMfeAmaiSvIhQsKtEYz8nAcEi3YCeDCbQC0zwXTX7sEGSWc8vfsA
LlqefToerOL/1Pqor6ylDSzefPTVPkH5ehFyNNQC0UIfkFc1qxfpqxfCXppEHmTd
5R9BoYxLOWmajcxfb7LR
=YlDT
-----END PGP SIGNATURE-----

--8w3uRX/HFJGApMzv--
