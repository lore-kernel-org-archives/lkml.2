Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353Ab2EDWNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:13:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58067 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464Ab2EDWNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:13:37 -0400
Date: Fri, 4 May 2012 23:13:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: drivers: Probable misuses of ||
Message-ID: <20120504221333.GU14230@opensource.wolfsonmicro.com>
References: <1333580415.23520.29.camel@joe2Laptop>
 <1336168477.11505.6.camel@joe2Laptop>
 <20120504220241.GA6279@sirena.org.uk>
 <1336169378.11505.10.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r3KnbM2MoJFBL7Dl"
Content-Disposition: inline
In-Reply-To: <1336169378.11505.10.camel@joe2Laptop>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r3KnbM2MoJFBL7Dl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 04, 2012 at 03:09:38PM -0700, Joe Perches wrote:
> On Fri, 2012-05-04 at 23:02 +0100, Mark Brown wrote:
> > On Fri, May 04, 2012 at 02:54:37PM -0700, Joe Perches wrote:

> > > > drivers/media/rc/fintek-cir.c:	if ((chip != 0x0408) || (chip != 0x0804))

> > It'd probably help if you were to supply more analysis as to what the
> > issues you think you're seeing are - in the cases quoted above
> > (especially the last one) there's no obvious bug without further
> > analysis.

> Likely the || should be &&.

> 	if (val != foo || test != bar)

> is always true when foo != bar

Right, but you need to look at the code and explain why this is a
problem.  For example, the case I've left quoted above reads to me like
the intention is "If the chip isn't one I know doesn't like this then
let's do it" which is a perfectly sensible thing to write.

--r3KnbM2MoJFBL7Dl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPpFSGAAoJEBus8iNuMP3d2KMQAIO7IxLZX1I+Kf5jGeYPNzln
nwtAomN18xFn5wvuodBuQK1AQDfki9681oPqCeLZb4uNq+4pVfLmYcrDhIVmXF+6
NfKQ1TM2/yemXt+T5jM5E4j65EHf6Li5TqFAWmt1ayvwFey700bS8527jsNYDSUV
0RrGcmp9r8tn3DEy9irhxu2RtLhOlVlCBQ+h19XCubOcltpXkbeKxpk5NTudDRQP
CNu+0JAZnbNOVnR0YfhjhmMWDQaRMft/QJk/YxIBU4jiU1Fky4HN7OxdQ+5GEJIJ
SY56dAr40m9nSUZWb3oR/VJ39JKUklZbzO8ZwHyuj1hVdQ3YXwin9rWpxVC8052c
rnEZbqzdGjfpWN7E/D1FlGwL4RYTrRiDHlnF4rAxRvSkdu3vvykAq9Crsz2fhKbN
cSIyWYAP6SgnSRip5/nO9nq23NxnS+EhNky2WvIZxymQtao8+frR1SMKEBCH6PPr
JKEBgM3tVvSUTxnywupIapB23ilyn+Opcm6p0ZyASvwAyFJ1EO/hH6Tv/PNtDJzy
npZCpRCMlOm1g45ehVQYZLNUIpmRrwPwNo1SfvTFTlP8gVK72hQBLwuuROkYkXq7
ynQ48w4XQBtd/CztMJ0GHgEcTi51oXoImr5mI/SdO4fRH0qZruWOUsBu/m+vARU6
dydXTtxncd+ynOxeq211
=vFxt
-----END PGP SIGNATURE-----

--r3KnbM2MoJFBL7Dl--
