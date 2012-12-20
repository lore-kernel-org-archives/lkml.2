Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2LTSS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:18:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60864 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab2LTSSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:18:49 -0500
Date: Thu, 20 Dec 2012 20:18:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "olof@lixom.net" <olof@lixom.net>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/9] ARM: tegra: # of CPU cores detection w/ & w/o
 HAVE_ARM_SCU
Message-ID: <20121220181818.GA26861@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
 <1355996654-6579-4-git-send-email-hdoyu@nvidia.com>
 <20121220100625.GB24693@arwen.pp.htv.fi>
 <20121220.132136.1599315430686323669.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20121220.132136.1599315430686323669.hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 20, 2012 at 12:21:36PM +0100, Hiroshi Doyu wrote:
> Felipe Balbi <balbi@ti.com> wrote @ Thu, 20 Dec 2012 11:06:25 +0100:
> ...
> > > @@ -149,7 +154,26 @@ done:
> > >   */
> > >  static void __init tegra_smp_init_cpus(void)
> > >  {
> > > -	unsigned int i, ncores =3D scu_get_core_count(scu_base);
> > > +	unsigned int i, cpu_id, ncores;
> > > +	u32 l2ctlr;
> > > +	phys_addr_t pa;
> > > +
> > > +	cpu_id =3D read_cpuid(CPUID_ID) & CPU_MASK;
> > > +	switch (cpu_id) {
> > > +	case CPU_CORTEX_A15:
> > > +		asm("mrc p15, 1, %0, c9, c0, 2\n" : "=3Dr" (l2ctlr));
> > > +		ncores =3D ((l2ctlr >> 24) & 3) + 1;
> > > +		break;
> > > +	case CPU_CORTEX_A9:
> > > +		/* Get SCU physical base */
> > > +		asm("mrc p15, 4, %0, c15, c0, 0" : "=3Dr" (pa));
> > > +		scu_base =3D IO_ADDRESS(pa);
> > > +		ncores =3D scu_get_core_count(scu_base);
> > > +		break;
> > > +	default:
> > > +		BUG();
> >=20
> > instead of bugging out, how about setting ncores to 1 instead ?
>=20
> Maybe that would be useful in the case of adding new ARM core in the
> future.

right, kernel would at least boot in that case.

--=20
balbi

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ01ZqAAoJEIaOsuA1yqREZoAQAKmi82hURVFWWzf8DVFGy5Gg
talOWJzhA28D0JM5wahDhth1sImiSh0GyZWSH/d3nc0zxXKARs/I5qjL0X0lmb7q
zivcdNZv8eJOqAYTwWTBK9ye6Ld3soELKZuxzGBbD11M0k6K9OEsSS4Rr19OBL9V
ThdKbSRr6gfss6Gv1jq5vxDF13xR3dASgnSaUOzyxu0ZjxfUaNxeJZ9gCcK9lVyH
CQQKVPkLXTu7K/GZ3k4VxBzTlA7bRz5JVHv2GFIpN4+YbFMEKQ0SSa5Cow2d9Fcr
KXLRozZW9t5Hd287HAWKagCfYQEMSow1iu7J3ljZVGIHU+xgIykLxZMx3/rp4+bG
FkabxLtntqwaTp+7QJzN210LmEOToFviztq9D9rTPL9fILEGwsQOlOdEiqB4DFR7
7g2OmZnIhlm8/+R47bRzx0P7sXhBCtuqdwfOhr6C0dBkoXwhGb+MJBAIIsFDTXoG
BqdjcQmu/OFIYepLLy22HsAjNWrkVZxSa5d5rvfF02V4TjJnI//ayEFEdENtlp2w
Wd+/gWRLSolLujoHD+lMkASnQf7+RKBx+k5HSBbQ11rJe/y8mG41G9P1LvUhbKdC
qb9Mdxnu90LUvnpo+aeEbfjrP8eK+rMEf5vPWiA+cCBRf+gInJNrsGcpFsjbh+K1
FILqq+wKz98cKdLyMSio
=LlYW
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
