Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2DTVLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:11:14 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53848 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2DTVLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:11:13 -0400
Date: Fri, 20 Apr 2012 23:11:08 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Dong Aisheng <aisheng.dong@freescale.com>,
        Huang Shijie <b32955@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V2 1/3] lib: add support for stmp-style devices
Message-ID: <20120420211108.GC12691@pengutronix.de>
References: <1332368519-22660-1-git-send-email-w.sang@pengutronix.de>
 <1332368519-22660-2-git-send-email-w.sang@pengutronix.de>
 <4F73CCC6.6000001@freescale.com>
 <20120329064320.GA20840@pengutronix.de>
 <20120418090551.GA30966@shlinux2.ap.freescale.net>
 <20120418092019.GB2232@pengutronix.de>
 <20120420053014.GK22219@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
Content-Disposition: inline
In-Reply-To: <20120420053014.GK22219@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 20, 2012 at 01:30:17PM +0800, Shawn Guo wrote:
> On Wed, Apr 18, 2012 at 11:20:19AM +0200, Wolfram Sang wrote:
> > > If not, i guess include/linux/fsl which already exists may be the
> > > right place.
> >=20
> > Which is a bad choice in my book. linux/dma would have been the proper
> > thing for mxs-dma.h, I'd think.
> >=20
> If it already exists, it will be the proper place.  We do not want to
> be too invasive to create folders in include/linux for every subsystem
> for only the need of fsl drivers.

I think linux/dma would have made sense:

$:~/Kernel/linux/include/linux$ ll *dma*
-rw-r--r-- 1 ninja ninja  1809 Apr 15 23:32 dma-attrs.h
-rw-r--r-- 1 ninja ninja  8343 Apr 15 23:32 dma-buf.h
-rw-r--r-- 1 ninja ninja  4915 Aug 20  2011 dma-debug.h
-rw-r--r-- 1 ninja ninja   299 Nov  8 20:06 dma-direction.h
-rw-r--r-- 1 ninja ninja 33123 Apr 16 11:47 dmaengine.h
-rw-r--r-- 1 ninja ninja  7018 Apr 15 23:32 dma-mapping.h
-rw-r--r-- 1 ninja ninja   923 Aug 20  2011 dmapool.h
-rw-r--r-- 1 ninja ninja  1288 Mar 30 22:12 dma_remapping.h
-rw-r--r-- 1 ninja ninja  6933 Mar 30 22:12 dmar.h
-rw-r--r-- 1 ninja ninja  3203 Apr 15 23:32 dw_dmac.h
-rw-r--r-- 1 ninja ninja   157 Aug 20  2011 init_ohci1394_dma.h
-rw-r--r-- 1 ninja ninja  2463 Aug 20  2011 intel_mid_dma.h
-rw-r--r-- 1 ninja ninja  3305 Apr 15 23:32 nfs_idmap.h
-rw-r--r-- 1 ninja ninja   999 Aug 20  2011 pch_dma.h
-rw-r--r-- 1 ninja ninja   415 Aug 20  2011 pci-dma.h
-rw-r--r-- 1 ninja ninja   572 Apr 15 23:32 sa11x0-dma.h
-rw-r--r-- 1 ninja ninja  2631 Apr 15 23:32 sh_dma.h
-rw-r--r-- 1 ninja ninja   123 Mar 30 22:12 sirfsoc_dma.h
-rw-r--r-- 1 ninja ninja  1784 Aug 20  2011 timb_dma.h

> On the other hand, I have seen a clear need for include/linux/fsl.
> The following files are all good candidates to be moved there.
>=20
>   include/linux/fsl_devices.h

I stumbled over this file some time ago. It is an arbitrary collection of s=
tuff
which should better be seperate. See 'fsl_spi_platform_data'? That should be
cpm_spi_platform_data. It doesn't even fit to MPC5200 (which SPI driver
unnecessarily includes this file), let alone i.MX, so calling it 'fsl' does=
n't
make sense at all. I fear similar confusion with a fsl-directory.

>   include/linux/fsl-diu-fb.h

Sadly, another bad choice. It should have gone to include/video like all ot=
her
fb-drivers.

>   include/linux/fsl_hypervisor.h

And that could simply stay in include/linux then, like kvm does.

> IMO, include/linux/stmp_device.h is just another good candidate.

Still not convinced, more the opposite.

> Oh, today I was asked by Fabio where is the good place for ssp-regs.h
> which will be shared by mxs-mmc and spi-mxs, as we are cleaning up
> <mach/*> from drivers.  I told him include/linux/fsl.

What's wrong with linux/spi? SPI devices capable of doing MMC as well shoul=
dn't
be much of a surprise, they are common.

Also, what will happen if Freescale ever gets renamed?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+R0OwACgkQD27XaX1/VRtWbACfdghCx5uTFTMVakPdcrBFjYYr
lV4AoJ7lzIGA7sEk/QUp8lHT6FUXEbxE
=bmXR
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
