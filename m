Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2GKGjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 02:39:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59885 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2GKGjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 02:39:15 -0400
Date: Wed, 11 Jul 2012 08:39:11 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pwm: fix used-uninitialized warning in pwm_get()
Message-ID: <20120711063911.GA15039@avionic-0098.adnet.avionic-design.de>
References: <1341347661-26567-1-git-send-email-swarren@wwwdotorg.org>
 <20120704055828.GC18779@avionic-0098.mockup.avionic-design.de>
 <4FF5B942.6080101@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <4FF5B942.6080101@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:E+8EP1HjP86sTj26fZzGdYJ7xyURZflQRRfhpQnKQ6f
 wrTqMLI2jGeLmquvSTbM3RNTm8lIV0IlDUPWdgqBN/xE63Dsv0
 yAKHyLJ54Xi2Nndm2xRip/KdDNRJhxW+bqJTOWyYEY1nxfrPUW
 YGUJvVL40/1f16tV60ucjdPELVXe9RunCZWXqrcGjfgNjfXR1G
 UvvTvcOTRz8azP2XF3mXEY+onW2zw9Cgbw1BZXn4Z+FJZZKQEW
 VV/3UUWtdS5xDwNMySn7QL13PcXSSpwPRU59X95MV4T6NFHuWY
 1sR8aqTCn0NVqvYXL6xzp6oldX9Dg9Yivb11Xpyq5F2hkziRbi
 cNrQoH3QGOQGhDRdOzTXyLpUEKr6tHvIu68RIIH4SQyvknISXp
 gLhzF6FRl66xl82vswrVATZX5JDf+UhPAg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 05, 2012 at 09:56:50AM -0600, Stephen Warren wrote:
> On 07/03/2012 11:58 PM, Thierry Reding wrote:
> > On Tue, Jul 03, 2012 at 02:34:21PM -0600, Stephen Warren wrote:
> >> From: Stephen Warren <swarren@nvidia.com>
> >>=20
> >> This fixes: drivers/pwm/core.c: In function 'pwm_get':=20
> >> drivers/pwm/core.c:534:15: warning: 'index' may be used
> >> uninitialized in this function
> >>=20
> >> The addition to the if condition at end of the function isn't
> >> strictly necessary to solve the warning, but does make it more
> >> obvious that the initialization of "index" to a dummy value isn't
> >> just hiding the problem.
> >=20
> > Actually this seems to be a false positive, and one that I don't
> > see (I use GCC 4.6.3). index will be initialized when chip is set
> > in the loop. My guess is that GCC 4.6.3 actually notices while your
> > version doesn't.
>=20
> Yes, it is a false-positive, which is why I was fine with just
> initializing the variable to hide the warning rather than making some
> other code change. I think there's still value in hiding the warning
> though, so that:
>=20
> a) Nobody else has to look at the warning and decide it's a false
> positive and remember to ignore it.
>=20
> b) The fewer warnings there are, the more likely new warnings will be
> noticed and analyzed.
>=20
> So I'd still argue for this change, or some other fix for the warning,
> be merged.

Okay, I've applied a patch based on what you did, with a more explicit
description of what's going on. Since I didn't see the warning with my
toolchain before it would be good if you could retest and verify that it
indeed fixes the problem for you.

Thierry

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP/R+PAAoJEN0jrNd/PrOhI84P/RBVZx3CrrZ6v/xvqqNelVZ/
TIR50lskFQzhnacP9iPftgDCbTK5MfEk5devZpmp7u/Elyzzc7jqFblrHTb6GWLO
lye4h+Uuj1LeweJZO2JXlJ4gny3pV9/k/7eZ1p9NqR/lgasol1TRDIVEHpiHyuU1
dIz056LVUiY51yWdA73ycESsqD035O572Br039uWrHVx/Nk74XjbKDfWSJBof2MQ
cgwLe3P1Rt9bYbtolZui38pt1/FiLrittXXaGWscB5Q4nEWZEg08md+Kd4ioBbPB
0RGktTURQ/CWtvESgVE4QOq3l1rvukezW/Pgin0rwljDejLONZCJ3hdi4YvuNBcX
TRv1ENbizAw0EvlSyabgK3L1u0ztjRW4i9K9FiE4uIGcpCRIK48GaRkPrFhZFdl0
ZEvjaHWEvy7GnDugigay6wPN43qygLWsQBURc9fc8Pn6wrD3+NzVtHvGW6CMH/oQ
1IQvbMIAboLqyxxKtHC2adYAbptLXbplWrIRoC5aj6LUbvU2GjiZbU1odlnAzzE1
KVmN24G89ro87Q3aOUzbN1Ti+CvCHOoXb4bIgxrMF/CXIuHIw0e0jbSi5tng+SsV
LsTWxIC+gkvowdxFZp0LSGplVGxkJiJa1+HDLhZhNr7iMZ7gW2NKo/XQlR2wNm4P
KV83UUEE2iTfgbOiu32D
=HXXD
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
