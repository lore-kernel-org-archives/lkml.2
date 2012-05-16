Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030238Ab2EPLFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:05:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:10115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966952Ab2EPLFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:05:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="153575320"
Message-ID: <1337166556.24809.42.camel@sauron.fi.intel.com>
Subject: Re: [RFC v4] UBI: Fastmap support (aka checkpointing)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Date: Wed, 16 May 2012 14:09:16 +0300
In-Reply-To: <4FB38683.7030306@nod.at>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
	 <1337161096.24809.36.camel@sauron.fi.intel.com> <4FB38683.7030306@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-9i3NT4KyHxumJmGx0nlo"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9i3NT4KyHxumJmGx0nlo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-16 at 12:50 +0200, Richard Weinberger wrote:
> On 16.05.2012 11:38, Artem Bityutskiy wrote:
>   >> This case can happen if the complete fastmap fits into one PEB, the=
=20
> fastmap
> >> super block is the first PEB on the MTD partition and the fastmap pool=
 is empty.
> >> On the other side, in the worst case fastmap has to scan UBI_FM_MAX_ST=
ART +
> >> UBI_FM_MAX_BLOCKS + UBI_FM_MAX_POOL_SIZE PEBs.
> >
> > When N ->  inf, UBI_FM_MAX_BLOCKS ->  inf as well. Each PEB requires
> > little space in the fastmap table.
>=20
> No, UBI_FM_MAX_BLOCKS does *not* depend on the MTD partition size.
> When N -> inf, UBI_FM_MAX_BLOCKS is still a constant.
> --> O(1)

This cannot be true, you cannot fit information about infinite amount of
erase counters to a constant number of PEBs.

>=20
> > O(N) would be: N ->  inf, UBI_FM_MAX_BLOCKS ->  C, where C is a constan=
t.
> >
> > Or did I completely forgot math basics?
> >
> >> With the current default settings this would be 192 PEBs.
> >> So, attaching via fastmap has a complexity of O(1).
> >
> > No :-) Again, for each PEB you have a little data structure in a fastma=
p
> > which you have to (a) store, (b) read, and (c) process when attaching
> > the device. The more PEBs you have, the more you do.
>=20
> The maximum size of a fastmap is limited to UBI_FM_MAX_BLOCKS.
> As I said, in worst case we'd have to scan 192 PEBs, which is a constant.

In this case you cannot use O notation at all because it is just used
when talking about asymptotic things.

--=20
Best Regards,
Artem Bityutskiy

--=-9i3NT4KyHxumJmGx0nlo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPs4rdAAoJECmIfjd9wqK0iFYQAJ600nJvYyBW714i6ncLgl8H
R1PGB0DlAcEo59b9xF1UzQqfejCfcA8xMRrh6ttMOxJ6zbGR12N8O5ia3Zw/WlxL
/81kam7dCWfVGPUQ7wUHUApb4VVXXU4HtULvgvSaekqLEh2Fp1SUDJmhKwGz3zmS
NIXXOr0K1iRDY30VfPsvOfE+Jh/osf2zfwoHruOmJ1UvEkixQdb2MuGSf2Qoidyf
Dok9LNGfSkaxiV/ADwE7v7jJ01jqwI69ACKL9fkQNnfusIGip8uPaDAAt4NqjOOD
hrxeIrISs9yO8JRHeYINPt6tuNFw0HE9LOOVP5aUjO9JI4Yng46qQ+mkS1VmbhJS
wVnvS/tvhsldcjLQ5doj2o+WXKxZPAhCBwDrGO82lVuWWqKpeAVsZgAzrjYBcQoh
T4bqjmSQiImDwof+XNwIyuatxfDZo54Yqraer6pykL6UbhbNaF3lR6XjmwHIKWuh
xZVTjNOD8Hk8SWY/VEVvW5vu3K796ddozSDJxJu+GpbMKyVsAtOFif5zCIbxKSvK
cuafZZNntkzsFTTtubR6NmagY1J810unZhSSjlCebbYvsElYIxMtznJZlSCeHA0d
gfjsw3FdDSyzDk46Bn+AQFluG0eSmj7VuT/gcO7leWPcQ9VywToNSL7BVbbI8wT8
GGMPImsmxMOXLtIZATl6
=I78F
-----END PGP SIGNATURE-----

--=-9i3NT4KyHxumJmGx0nlo--

