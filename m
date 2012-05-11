Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab2EKMRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 08:17:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:16817 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab2EKMRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 08:17:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="142754934"
Message-ID: <1336738864.2625.66.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/7] [RFC] UBI: Add checkpoint on-chip layout
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tim.bird@am.sony.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de
Date: Fri, 11 May 2012 15:21:04 +0300
In-Reply-To: <4FACFFED.40105@nod.at>
References: <1336585125-127220-1-git-send-email-richard@nod.at>
	  <1336585125-127220-2-git-send-email-richard@nod.at>
	 <1336735041.2625.35.camel@sauron.fi.intel.com> <4FACFFED.40105@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-iNt0B3CujsPbsLsXPj0/"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iNt0B3CujsPbsLsXPj0/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-11 at 14:02 +0200, Richard Weinberger wrote:
> > Please, unless it is size-critical, always leave some unused space in
> > on-flash data structure for possible future extensions, and initialize
> > them to 0.
>=20
> If the fastmap on-flash layout changes, I'll increment the "version" fiel=
d.
> But I can leave some space.

But if you have extra space you _often_ have chances to add new features
in a backward-compatible way, without incrementing the version, which
would make new images backward-incompatible. It really may make a big
difference.

This is not _always_ possible, of course, but sometimes it is. So if it
does not hurt, leave extra space in all on flash data structures (but
probably not in those you have large arrays of, though). This is just a
good practice I think. For some reason I have a feeling that we
discussed this already :-) I think I sent you an e-mail with various
questions which you did not answer long time ago, but it was long time
ago, so does not matter anymore.

> > What's the perpose of having these pools - once you read all the
> > information from the fastmap and the wl subsystem inserts it to the
> > RB-trees - you already know this data. Why you need to store this on th=
e
> > flash? This whole pool think look redundant and unneeded.
>=20
> We need this pool to find all PEBs that have changed since we wrote the l=
ast
> checkpoint (or fastmap).

OK, I see, thanks.

> BTW: That's why we named it "UBI Checkpointing".
> If all PEBs in the pool are used (IOW no longer empty) we fill the pool w=
ith empty PEBs
> and write a new checkpoint.
> While reading the checkpoint we know that only PEBs within the pool my ha=
ve changed...
>=20
> Without this pool we'd have to write the checkpoint every time the EBA ch=
anges
> or we'd have to scan the whole list of free PEBs while attaching.

I just had an impression that you write the fastmap only on unmount or
at some kind of "sync" points, and power cuts always would lead to
re-scan.

> > It is weird that you do not have an array of ECs instead for _every_
> > PEB. Why wasting the flash and time writing/reading this data?
>=20
> By array of ECs you mean that all ec values are written to the flash
> and pnum is the index?
> Sounds sane.

Yes, to me it sounds like the only sane way, unless there is a strong
reason to have redundant "pnum" fields. :-)

--=20
Best Regards,
Artem Bityutskiy

--=-iNt0B3CujsPbsLsXPj0/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPrQQwAAoJECmIfjd9wqK08pQQAJKw7tIxZcDh7ATZtE8a6950
l0UdXzorOrrQlCFolgX04oSqZkqMLIajylIjIAjvOsyV/KHH98hO0Gp9qgpDVaMr
L/6sapkYeRH7Y9QVshPUGzUXfWqudQHQYOpaOY2iARyCKFqibt2d/r8pG47ML2Kf
5J6hU229xKG6xkFI0GwXLpKgAJFMT1/yD0A9IeaFquYuwSeoJnZiKd1lfVD9X/TZ
d09UlcxYVWedZ4Upc1UrwNI1opTwRB1URGfI4e368REcu6cuO+Qcaic5DeO/tNTi
O3o7g/q8hpJbvkQyFo0gORu17L0sf3Dedirr/YGNS0MgQBkSOdIBaGpTzgBENSgD
X+t1ubDlNgB5JGU5PnyT6t6/CA3y34DghWM6nzmxBDCS0HQwji+iiYAxcxx4HQYo
9Rzwjm2g9T14geiU3PsMozLJ3TMsGsGHUwzsf1fXMVkeiQaWYdH5YxgjcfkmfuHR
SEhYTdr1GMKjn+4O7YWEzprzLtSpFqsPppwpSrF+z2bx6aC/71oK8+ivDswvxC/3
MoQY6TsNWQnVTF3yGnoyXe0G2eHHaxlVCQvdSPHZwDTEc1MP3fgbbzl9OWYpUMAs
7omZ6WMfrAqUQ8zd2m6buy8Qkfavo4HcOd55BGYv5cP+mK4bO4rsphso4Or4+Z0A
06zGHSua9svUO6QWT1AX
=qAC6
-----END PGP SIGNATURE-----

--=-iNt0B3CujsPbsLsXPj0/--

