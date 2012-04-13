Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab2DMJIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:08:50 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:54297 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757864Ab2DMJIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:08:48 -0400
Date: Fri, 13 Apr 2012 12:07:52 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, "Balbi, Felipe" <balbi@ti.com>,
        "Mohammed, Afzal" <afzal@ti.com>, Greg KH <greg@kroah.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "V, Aneesh" <aneesh@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "mgreer@animalcreek.com" <mgreer@animalcreek.com>,
        "msalter@redhat.com" <msalter@redhat.com>
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Message-ID: <20120413090750.GM4343@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
 <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
 <20120412030044.GA26236@kroah.com>
 <4F867A95.9030104@ti.com>
 <20120412131045.GB31384@kroah.com>
 <C8443D0743D26F4388EA172BF4E2A7A93E95947E@DQHE04.ent.ti.com>
 <alpine.DEB.2.00.1204121053570.29473@utopia.booyaka.com>
 <4F87240F.6060902@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x38akuY2VS0PywU3"
Content-Disposition: inline
In-Reply-To: <4F87240F.6060902@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x38akuY2VS0PywU3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 12, 2012 at 08:50:55PM +0200, Cousson, Benoit wrote:
> + Felipe,
>=20
> Hi Paul,
>=20
> On 4/12/2012 7:00 PM, Paul Walmsley wrote:
> >Hi
> >
> >On Thu, 12 Apr 2012, Mohammed, Afzal wrote:
> >
> >>On Thu, Apr 12, 2012 at 18:40:45, Greg KH wrote:
> >>>On Thu, Apr 12, 2012 at 12:17:49PM +0530, Santosh Shilimkar wrote:
> >>>>I was hoping that we will have some thing like drivers/memory/*
> >>>>but since it doesn't exist, we used drivers/misc.
> >>>
> >>>Why not create it?  I have no objection to that, it makes it more
> >>>obvious as to what this really is.
> >>
> >>There is another memory controller used in a few TI SoCs,
> >>namely GPMC [1], do you prefer having it too there.
> >>
> >>As of now it is not a driver, platform code handles GPMC, a patch
> >>series for converting it into a driver (but still residing in
> >>platform folder) was sent a few days back [2,3].
> >
> >Probably the GPMC driver should go into a slightly different place than
> >SDRC/EMIF.
> >
> >GPMC is actually a general-purpose parallel bus driver.  It's used to
> >interface Ethernet controllers, UARTs, FPGAs, NAND/NOR flash, SRAM, etc.
> >It cannot be used to control DRAM, at least not without a separate DRAM
> >controller chip.
> >
> >SDRC/EMIF are both DRAM controllers.  That's all they do.  They can't be
> >used to control anything else.  They implement DRAM refresh, etc.
>=20
> The LPDDR2 spec does consider as well NVM (Non Volatile Memory), so I
> think we should stick to driver/memory for EMIF.
>=20
> >So perhaps something like drivers/memory/dram/ for the SDRAM controllers,
> >and maybe drivers/memory/ for the GPMC?
>=20
> In fact Felipe was considering something else for that kind of
> general purpose bus driver like GMPC, C2C and LLI...
>=20
> ... But I do not remember the name :-)

the name matters very little :-) But the idea was to avoid writing yet
another bus driver and just use the platform_bus instead. We would do
all the channel/port setup before hand and far-end device driver
wouldn't have to know if it's integrated into the SoC or plugged though
LLI/C2C/GPMC.

=46rom the driver's perspective it would look the same.

--=20
balbi

--x38akuY2VS0PywU3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPh+zmAAoJEIaOsuA1yqREOy8P/2j0xBGDA5Maaws8NVYT0cOR
vmyW249XqyNhYzOxi/l9wUAHtM5vxSwBG5J856DjWmiZHPHCdhD24fSM7rL7kpA7
CG//baD2JJvDpfL/O7GGjlx9GxmohsmoDmyOGTkhhWrfkTHJ5vYJjpsUsTp1cdLP
M1zzfBkJPbquY2itdF6ezKVJL1jxHDfjQwMghRHo5d86wyjvEnEicvwfojZU4QcS
n5MCND/6Xu6jFF4atxsZSvkv8xadGm+ih3ToCs1WRBI7xn8lGQ0pm0QTO3bQRfKU
ZbAF058Gcd5DfWtAzdBWwmp3IWNjfKuWk4YiVrzdoaLscZAnftGSK9HPdsdyy9kN
U55/JIKOttOXazYqmxO36KHF1gLKmAzTwD/B2phDbrJXIK2ZdGgL2rMEHUtvBfDR
iMTv2dxTGjtdlMGFwF461vd5FVUekUGFAI9vxP2TZMC5CCqQnktoUm2YKseXbxdt
p5uiYDRP+KmpG7UqGtbIDGDLX6zocvpLi855zXlHn6NGFYQMCZGxYaiUuNsx/ljd
wgQeiK/E/DYy9uOqwgFmr91Rne1d1aTJe4wwAFqCyeR8UHaWAA7ywGag4nM4fNdV
ibJ7GE6mj4ojQY4nP4JUF8EwnpUm83Rc3kizTWxCbfyd02rhOJ/d7Y+06oSHBRoI
0Et8Pbb+prFyqtQq8nmT
=inf9
-----END PGP SIGNATURE-----

--x38akuY2VS0PywU3--
