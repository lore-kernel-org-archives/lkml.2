Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2BNHSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:18:42 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:37059 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab2BNHSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:18:39 -0500
Date: Tue, 14 Feb 2012 10:20:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christoph Lameter <cl@linux.com>
Cc: Xi Wang <xi.wang@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
Message-ID: <20120214072017.GF26353@mwanda>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
 <4F33C7D7.1060801@kernel.dk>
 <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
 <4F33CEAE.60400@gmail.com>
 <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
 <20120209150652.5b1d19dc.akpm@linux-foundation.org>
 <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com>
 <alpine.DEB.2.00.1202130958470.23562@router.home>
 <20120213194446.GD26353@mwanda>
 <alpine.DEB.2.00.1202131424020.25908@router.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EDJsL2R9iCFAt7IV"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202131424020.25908@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F3A0AC4.0094,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EDJsL2R9iCFAt7IV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

SAFE_ARRAY_SIZE() would return the size if there were no overflow
and -1 on errors?  We can't return zero on errors because there are
a lot of places which do zero size allocations and it's valid.  It
seems ugly.

I really think that's over thinking things.  Let's just match
kcalloc() exactly except without zeroing.  The BUILD_BUG_ON() thing
is an over complication as well.  We haven't needed it for
kcalloc().

The only impossible bit is picking the right name.

regards,
dan carpenter


--EDJsL2R9iCFAt7IV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOgsxAAoJEOnZkXI/YHqRDEMP/ixtcygxh23xXgmhUp5mdf7C
jYzXj8H9Q4y0X+gGUp02dUpnzmMYuph2aPHuXcvC+I0eftZi9hYxO+I696KOtmr5
jSornuQcOJEDj9SsmJ3lttdZI79IbtwmgfBjCggestCtj4CkZ8AzA2KCeZb/Plc8
wS659nhH9PXhVOhyJcNgimcIVW21ZPpUzpQVpHc2fVv+C3M0lzpSFMUHVLQ0mPBh
NqnqN20PBS3DqO94sRnW7CF/O3ZJK00E94Lg1/1Y7lwJKNu17hUDpcWp9i9iSueI
9/6m204yfcnv+5uhIRYHCSUxjcjL3fPgNWbry9qBcKmcAwrgmBcqYryVi+HynEDc
vp9nHnguoHyibE8t++i6K7ZC1rpT7bEUg2lxBgvo43sVU8LSUyqU2NfgA9ej8SoJ
bwZSAy+4Ps8yYA0tRS9eRSAihHbIHxniLOQ9NuFHibWd1hMSVXzAYRWs9RCuF3sC
dtZZOY52Hq6F8RQ9HdEzYf3YdW65JRdOBCGKBSZrgDfO5/hBkkxci04sCuI4d5rf
/ELraFZVyVZQS3UTUp09290ouY5ENsIeL+bhegLA9csBi+qWQW4rkdADo4feaayP
j+wxc9mg1kcu4jkjWBQTbO0zTJtXwsU2TUPzQIq11MkRo9Md+vmd3FdGAs21lBbS
d5swcM0ozTN1MI2QEfXA
=+mbf
-----END PGP SIGNATURE-----

--EDJsL2R9iCFAt7IV--
