Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935468Ab2JXSRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:17:08 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:45720 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab2JXSRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:17:06 -0400
Date: Wed, 24 Oct 2012 13:16:56 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH v3 3/5] zynq: remove use of CLKDEV_LOOKUP
Message-ID: <20121024181656.GS20593@beefymiracle.amer.corp.natinst.com>
References: <20121024003218.GA31625@beefymiracle.amer.corp.natinst.com>
 <20121024003442.GD31625@beefymiracle.amer.corp.natinst.com>
 <20121024133231.GA28661@elliptictech.com>
MIME-Version: 1.0
In-Reply-To: <20121024133231.GA28661@elliptictech.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/24/2012 01:16:52 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/24/2012 01:16:52 PM,
	Serialize complete at 10/24/2012 01:16:52 PM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MWF3YmTHhoLNIVQC"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-24_05:2012-10-24,2012-10-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MWF3YmTHhoLNIVQC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 24, 2012 at 09:32:32AM -0400, Nick Bowler wrote:
> On 2012-10-23 19:34 -0500, Josh Cartwright wrote:
> > The Zynq support in mainline does not (yet) make use of any of the
> > generic clk or clk lookup functionality.  Remove what is upstream for
> > now, until the out-of-tree implementation is in suitable form for
> > merging.
> >=20
> > An important side effect of this patch is that it allows the building of
> > a Zynq kernel without running into unresolved symbol problems:
> >=20
> >    drivers/built-in.o: In function `amba_get_enable_pclk':
> >    clkdev.c:(.text+0x444): undefined reference to `clk_enable'
>=20
> For the record, I think this was introduced by commit 56a34b03ff427
> ("ARM: versatile: Make plat-versatile clock optional") which forgot to
> select PLAT_VERSATILE_CLOCK on Zynq.  This is not all that surprising,
> because the fact that Zynq "uses" PLAT_VERSATILE is secretly hidden in
> the Makefile.

Yes, indeed.  I did try to fix my problems by having ARCH_ZYNQ select
PLAT_VERSATILE_CLOCK, but I recall running into additional build
problems...

But now that I just tried it again, it all seems to work, barring
Kconfig complaining I've selected PLAT_VERSATILE_CLOCK, but not
PLAT_VERSATILE.  (Having ARCH_ZYNQ select PLAT_VERSATILE, however, leads
to additional build problems).

> Nevertheless, the only feature from versatile that Zynq needed was the
> clock support, so this patch should *also* delete the secret use of
> plat-versatile by removing this line from arch/arm/Makefile:
>=20
>   plat-$(CONFIG_ARCH_ZYNQ)	+=3D versatile

Yes, indeed it should.

Thanks,

  Josh

--MWF3YmTHhoLNIVQC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQiDCYAAoJEEef0niEbw+lUn0P/3nQG85jLu2uV1eCps/1skh8
rAAfEeS9j9QyUVAcg03WC0mW4k5rDj1LKusYw+S9AYKD8RTz7ZLNG4rEVnXZ04l8
TRIFBr7MLNLhm2xDC8oXxJ62Hj22t5ffQGwHzkAA2Ue0GD6PMW1mXO6lQRIPnl8g
cW/qpPBZ4utmwTF9JnhoVqQByP6Q0hK1fsN4rVNpXNwy44vRcbE8UpwywlmG24/K
KC7pDsLnXrHpTybM7tYaGAU6uGdOunawbHLBOsRk0OXHdfAK2w/AERgmE25xymkq
ub592VfsfPfM3vDKJ883R4w0+IcEA/OFoiOvmHbVwJNgmxs/Tz/DA9nkdb9lTHg9
0ittT4rjNMk0W6d0ARRrG2+6LGLMNn/8X5saxl6z6oW06lsIFyqKNaprh3BsMhGU
iesltyMThgu7RjWlJfyzh2jAbbfp8V4ygJXXgbT801NIAc779iGMEszR9sNEYYIm
s0FYU9J6HVJrpu5mV995M3NGPlocuI3153e3t7YHWvI0uDp4HEimLuxkh+wMV3Tr
+xAMnwlzNRFulhchYsgYHWcJEABj8l9ZI05Au2SOCAJAMSjvePXPAsnxq/r+7p44
TzxvxiEag6S6jUnYZhUdgod0N84w+a+dryG9nKHbekh9hrHIiIrpLQLCeCloMpTz
jfmylHQhqYTyf7hNXZ7H
=WLR+
-----END PGP SIGNATURE-----

--MWF3YmTHhoLNIVQC--
