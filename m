Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966628Ab2EPJes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:34:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:1392 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966066Ab2EPJeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:34:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="166999176"
Message-ID: <1337161096.24809.36.camel@sauron.fi.intel.com>
Subject: Re: [RFC v4] UBI: Fastmap support (aka checkpointing)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Date: Wed, 16 May 2012 12:38:16 +0300
In-Reply-To: <1337101871-31181-1-git-send-email-richard@nod.at>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-uepf/RHG9PYSFfmK9qxE"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uepf/RHG9PYSFfmK9qxE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-15 at 19:11 +0200, Richard Weinberger wrote:
> We observe that attaching by scanning depends on the total size N of the =
UBI
> device.It has a complexity of O(N).
> Whereas attaching by fastmap has a nearly constant attaching time.
> In the best case fastmap has to scan only one PEB.

The improvement is impressive, but again it is not O(1), strictly
speaking. It is still O(N).

> This case can happen if the complete fastmap fits into one PEB, the fastm=
ap
> super block is the first PEB on the MTD partition and the fastmap pool is=
 empty.
> On the other side, in the worst case fastmap has to scan UBI_FM_MAX_START=
 +
> UBI_FM_MAX_BLOCKS + UBI_FM_MAX_POOL_SIZE PEBs.

When N -> inf, UBI_FM_MAX_BLOCKS -> inf as well. Each PEB requires
little space in the fastmap table.

O(N) would be: N -> inf, UBI_FM_MAX_BLOCKS -> C, where C is a constant.

Or did I completely forgot math basics?

> With the current default settings this would be 192 PEBs.
> So, attaching via fastmap has a complexity of O(1).

No :-) Again, for each PEB you have a little data structure in a fastmap
which you have to (a) store, (b) read, and (c) process when attaching
the device. The more PEBs you have, the more you do.

It is OK, and it is a great improvement anyway!

--=20
Best Regards,
Artem Bityutskiy

--=-uepf/RHG9PYSFfmK9qxE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPs3WIAAoJECmIfjd9wqK0Mu4QAKAkGwuQmCRX1AVfWfrnRQ2g
PpRhwbIIZn8Vh7hyqkGSWeKgOTjSc2rclFcrXDik35uqKvZKgHh18ank8ert+2fT
I1IkrnqFFJZdVTaFctvfhE+5qQYUM6ABlYYZXJMtzwxsWlTX7tT5RkS1waR7h/WB
WSCLaF2QfG3dtzZh4+2+sIzXugYGuPVCGkj216tX1ETGey6WJ7JDkIFXHx6XRwVl
tV7S0HtKsdrliS+eqlzpNbdr3g3YtsMEgR/qaKX0G5lNsP1TPq35rMOzqN5c6yzp
L6Ld4uL7Tw6O80plwfLA0y05ytbEU/kMtJbALoXyplK+DRN8BRxL/PthtQbV3Vs+
EoFJ9aSwwHAzPALKUhd2m6txjS50Fm4UhguuiYC/JXqBAlVMoiNEAl/I9picmN3A
RpgVmgqwDqvvmUaBt4eRNEe7uI3hu7tVqijkFLunKNTdQB1STGU7WttyiZRdheDL
7/9rn4GXhPoh6wZT5EGfohhjNoPYA+el5pSehVtoX1jrugmtTUcDcto7zrhOF9nt
fiLp9IJAFwHokZYd3ZO2Y+PbLVItDGYMpYX+sz8zgJX9VIBiJWVTriG7QCFych4/
t5UaDyHbidN9SsjzTUdE1lDNGpSqxs8mB05ekHKurP0DzdLgZamVdhuKP+2SwGFP
m2HGlypI7oHb3JBv8w1k
=eSks
-----END PGP SIGNATURE-----

--=-uepf/RHG9PYSFfmK9qxE--

