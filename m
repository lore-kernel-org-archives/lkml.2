Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2EHHIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:08:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:55642 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab2EHHIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:08:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="163279864"
Message-ID: <1336461106.23308.12.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2 3.4-rc6] MTD: NAND: ams-delta: fix
 request_mem_region() failure
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: David Woodhouse <dwmw2@infradead.org>, Tony Lindgren <tony@atomide.com>,
        linux-mtd@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 10:11:46 +0300
In-Reply-To: <1336460605.23308.8.camel@sauron.fi.intel.com>
References: <20120504171125.GD5613@atomide.com>
	 <1336423897-31729-1-git-send-email-jkrzyszt@tis.icnet.pl>
	 <1336460605.23308.8.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-bjWdgVQG0bV2xhtwwUtP"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bjWdgVQG0bV2xhtwwUtP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-08 at 10:03 +0300, Artem Bityutskiy wrote:
> On Mon, 2012-05-07 at 22:51 +0200, Janusz Krzysztofik wrote:
> > A call to request_mem_region() has been introduced in the omap-gpio
> > driver recently (commit 96751fcbe5438e95514b025e9cee7a6d38038f40,
> > "gpio/omap: Use devm_ API and add request_mem_region"). This change
> > prevented the Amstrad Delta NAND driver, which was doing the same in
> > order to take control over OMAP MPU I/O lines that the NAND device hang=
s
> > off, from loading successfully.
>=20
> Aiaiai found out that your patch adds this gcc warning:
>=20
> -------------------------------------------------------------------------=
-------
>=20
> Successfully built configuration "l2_omap1_defconfig,arm,arm-unknown-linu=
x-gnueabi-", results:
>=20
> --- before_patching.log
> +++ after_patching.log
> @@ @@
> +drivers/mtd/nand/ams-delta.c: In function 'ams_delta_cleanup':
> +drivers/mtd/nand/ams-delta.c:285:19: warning: unused variable 'res' [-Wu=
nused-variable]
>=20
> -------------------------------------------------------------------------=
-------

But I've fixed this up and pushed to l2-mtd.git. From the commit message
I have an impression that you are not going to implement that longer
term plan. Dunno if Tony has a plan to force someone to do this by
blocking some changes which are not urgent fixes. Hmm? :-)

--=20
Best Regards,
Artem Bityutskiy

--=-bjWdgVQG0bV2xhtwwUtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPqMcyAAoJECmIfjd9wqK0dcsP/3Ulouzeibl5pHRphFaKuQXU
MqkpF02aeO0CsgiA/6FFsgn/s3oz+fKg6dETmYY1pNtRIei33lVKN6WxRClXseGA
3Ml8Cr1TeL6j+232EGYoMr/c7+5hayE4Zw2kvTrgq6LLGUS52wrtoR2ROZghhMH7
atPaJbfEzOsEMP/n6a7bCCExYpOs7XW6gkmH/dDWm+WfzMKTDRGyw+C+r70G5xbz
8Huxd1jrLvIkXLMaBCdE2niUbHyCRe1pFGDr1IYA+PvfVHIYBHIfUrqPVaK+/STh
jCeFoA9zeGoFKmGj1UMdh/nm5V6uQn4UAMVS+/cJhX7tX91KceUTXsuVmureQjG8
Ou4Ohfezx0KKM32K2ZT0JV8MU6aGCex3yzjwgNeIkhDtG7wNwG6Us2A2SYdtP5ur
z1oGBHWOdgno753pK6+znbPWLcj9JdA8L6XLQ3pv6CFEys4P8biWjAbSu6NJr4yx
rgqKckLLzA+vBiZ7WZa7yqr457QNOchDFIOaGrEOHYw3gXx1fbnb7YVmdbesBb8M
fBRNr/qPSIk2mkqsiIfAXd84O8S4Kws6j9wbGNotAg00y0M7osXY5y6a079LCmx0
ynK5j6ymJFZNtTemcymOiuxjCOQPH8uI7T0guKjqXcwuXPqZa2ZZ6pTFFBhhQe0d
2kiry/A2RYUi5UrpAfDc
=VbBB
-----END PGP SIGNATURE-----

--=-bjWdgVQG0bV2xhtwwUtP--

