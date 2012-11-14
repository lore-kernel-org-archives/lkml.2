Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2KNBKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:10:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54061 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932161Ab2KNBKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:10:51 -0500
Date: Wed, 14 Nov 2012 10:10:43 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chris Ball <cjb@laptop.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 3/3] mmc: sdhci: apply voltage range check only for
 non-fixed regulators
Message-ID: <20121114011042.GC4415@opensource.wolfsonmicro.com>
References: <1352796533-12350-1-git-send-email-m.szyprowski@samsung.com>
 <1352796533-12350-4-git-send-email-m.szyprowski@samsung.com>
 <87fw4dn030.fsf@octavius.laptop.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <87fw4dn030.fsf@octavius.laptop.org>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 07:45:07AM -0500, Chris Ball wrote:
> On Tue, Nov 13 2012, Marek Szyprowski wrote:
> > Fixed regulators cannot change their voltage, so disable all voltage range
> > checking for them, otherwise the driver fails to operate with fixed
> > regulators.

> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

> Perhaps it's a good idea to mention that the regulator API is changing
> (being fixed) at the same time, and that's why this patch is necessary.

This should be totally unrelated to any externally visible change in the
regulator API, if anything I would expect fixes in the API to *improve*
the ability of clients to work with fixed voltage regulators.  What's
missing here is some explanation as to what the problem is and how it's
being fixed.

As I understand it this should really be a workaround for hardware which
runs cards at out of spec voltages; we have a fixed voltage regulator
which claims to not support any of the voltages that are in spec (due to
this being what the hardware does) so if we try to use the voltage
management stuff in the MMC API it gets upset.  As a workaround if we
can't change the voltage we just ignore the voltage aspects of the API.

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQou6gAAoJELSic+t+oim9T5MP/02aQy+TIolpJeCNOGDIY1wC
Lvzelv4UVUoF5LEUPyQkXbm5hlbLe0EI2Ctol4Ll3IP++qDWVfi90LUzc/zUonzh
2h0GwJswhVSmzsDBxvTmKO775oqWNs2LDApJGyNoYQ633eknFQSzlr8xHRT1+C+P
Zar9Q7WMulOZaP/L+UwNIZWYjoslxQgPICilXhxg1k97gabpj+2/Et1YpQCJg/Kg
FP9z2CvwXenWk7hYpeKUmHusDyGNoWtAytd5VmQEEWM+8uFe8wucQ7+zxNttTGDx
+wfDEQ5iYHNcVvJPsaVOfG+fhGUDO2qJL+Z4rzLnKdLf2NTcYIwysZZxRZuwU7Fw
Lc9Y/Y3VBonzqiMfLU3OqiVUZ6SZk5vhU50zw1JuCrjqJWUYaNLW3I8bZyo1hIij
mIC7kiGeHf+W1eP5ko9R622dwgtoW2rw1uzYIDavUp8ao7uvIjrSP7QkV5a0PWs0
4ipnG0uujjqB8kWQwaw4TFHH3vM9cV4sSsGFQ07R1rMfSO+mKubCQUAccpmKHsMv
RF/MusXYGK7xsIcsKi07LtayxP0fZL+PrjNc0SwO0bOdSx/SSVfSqy70vtHeQOOm
8dPy36OrzHqEJljcia8iMpJYrVUu6Xe8Nh9PQlavkNjlN1OVOBBvPjMVjv3jGSFt
nnM0mxS2SkXyTxq8fKmX
=nkFo
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
