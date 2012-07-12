Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974Ab2GLOpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:45:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:12594 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530Ab2GLOpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:45:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="176503703"
Message-ID: <1342104572.18274.108.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 0/3] fs/sysv: stop using write_supers and s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>
Date: Thu, 12 Jul 2012 17:49:32 +0300
In-Reply-To: <1342103878.18274.98.camel@sauron.fi.intel.com>
References: <1341323008-29414-1-git-send-email-dedekind1@gmail.com>
	 <1342103878.18274.98.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-lqX4SuRsl41hQqEmdhNq"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lqX4SuRsl41hQqEmdhNq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-07-12 at 17:37 +0300, Artem Bityutskiy wrote:
> On Tue, 2012-07-03 at 16:43 +0300, Artem Bityutskiy wrote:
> > This patch-set makes sysv file-system stop using the VFS '->write_super=
s()'
> > call-back and the '->s_dirt' superblock field because I plan to remove =
them
> > once all users are gone.
>=20
> Hi Andrew,
>=20
> would you please pick this patch-set as well? I also sent you an update
> for hfs and hfsplus file-systems today - found a bug while doing some
> more testing. Also, I sent UFS changes today, very similar. Most
> probably no one will reply and I hope you would pick them as well.

Just to let you know about the overall picture. Pending FSes (no one
picked them) are:

1. ext4 - Ted is still being busy.
2. sysv, ufs - I hope you'd pick

After this we will be able to kill sync_supers() completely and get rid
of another source of regular wake-ups in the kernel. And interestingly,
it will be the final end of pdflush - at old times it woke up
periodically and flushed everything (forked itself as well). Then Jens
cut off the data write-back part and put it to per-block device bdi
threads. They originally also waked-up every 5 seconds, but I fixed this
in v2.6.36 (6467716) and they stopped misbehaving. Jens transformed the
superblock write-out part of pdflush 'sync_supers()', and I could not
kill it because I did not have enough time and Al's request to change
all users sounded unrealistic to me. But now I hope to actually finish
this.

--=20
Best Regards,
Artem Bityutskiy

--=-lqX4SuRsl41hQqEmdhNq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/uP8AAoJECmIfjd9wqK0iLEQAI0suEj+J6VOquDG3jyMZWaQ
Y0IpfdpXjk3uYnXJZssQFSNCowcmMkZZUu2pKgpU80b+L1bGx3P0+jef9iONz3T8
bjSzwbvlH2heMhHC7fg/YzAlZhUdCkddH41gfJSXIp1NOxzn5x5YT1IA07WzMkAK
uTt4/4KQOXCxrYCXZNJTg7y6eyspEBCd3ndbxXZMvhKwZjQkynSCui5BTCroxBJj
qOV5ZY1MYRTm4yjiAsWG8EcAqM4cnmx3uVsalOUkzRGvnZMbHshFZI5+c29T6HFM
2qUX+xV6pmKr6H9DoeKZsOfs3N9PYDeBnCQj9DZvKWsK8AYMdxRPMSPMGcF1AlSh
Rs3x6rTEEoB3hKWNeXwzvKRzWQdEAYBjMw98vEI3Nw/r6MsZUbybs7/Cr9m63D69
zSHM+o/MGBiGa6Ep6eLzm6RWlX8hpHPIR4PNazDoMZztr8wCLSu+Kzwy+F3hxQFp
RsBJqSK+fY0NAj060uuKyHx+wEzsRogGxyeaQWLp4MabVuwu/NM3/I1E1EK+qWKS
rgN+4u+2RCgyrtfWOLCOb50d2ECDYIcTanqz6KcqT7Ex6rPbgKy4DLxfJ0ZHUuel
axJvGUmAdRp+8CGLePg1jHJM6IoILnFo1etbWc2KqlneQvyQz3ErdiLagkDvDGkq
BltmKQdGOI4Y7b8sLIFi
=Ps72
-----END PGP SIGNATURE-----

--=-lqX4SuRsl41hQqEmdhNq--

