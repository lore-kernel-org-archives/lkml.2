Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2DNLBw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 07:01:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52167 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2DNLBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 07:01:50 -0400
Subject: Re: [PATCH v2 4/4] fat: switch to fsinfo_inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Sat, 14 Apr 2012 14:01:45 +0300
In-Reply-To: <87bomuha77.fsf@devron.myhome.or.jp>
References: <1334326795-2446-1-git-send-email-dedekind1@gmail.com>
	 <1334326795-2446-5-git-send-email-dedekind1@gmail.com>
	 <87fwc6hazv.fsf@devron.myhome.or.jp> <1334399379.2263.8.camel@koala>
	 <87bomuha77.fsf@devron.myhome.or.jp>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-MXK3X5C572v0NSdM8jDz"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1334401307.2263.24.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MXK3X5C572v0NSdM8jDz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-04-14 at 19:36 +0900, OGAWA Hirofumi wrote:
> Artem Bityutskiy <dedekind1@gmail.com> writes:
>=20
> >> Hm, does this guarantee to flush FSINFO at umount?
> >
> > Of course, and I checked it. It is just a dirty inode. If you do not
> > worry that any other inode won't get written-beck, then you should not
> > worry about this one.
> >
> >> FSINFO is last part of data dependency. I.e. inode change can dirty
> >> FSINFO. So, FSINFO has to be flushed after normal inodes.
> >
> > Sorry, I do not see how this can be true. You have a just bunch of dirt=
y
> > inodes, and it does not matter in which order you flush them. See
> > __fat_write_inode() - it does not change the FAT table and does not
> > affect the FSINFO block.
> >
> > Besides, the _current_ code first writes out FSINFO, because VFS calls
> > ->sync_fs() first, then it starts writing back, then VFS calls
> > ->sync_fs() for the second time.

This is actually not exactly correct, but anyway, the first
->sync_fs(sb, 0) may come to FAT FS while it is in the middle of writing
out the inodes.

BTW, fat_clusters_flush() does not wait on the FSINFO block, which I
think is a bug. I mean, it should call 'sync_dirty_buffer()'. I can
submit a separate patch later.

> Common case is delayed allocation though, in the case of FATfs, it would
> be only truncate by last iput().

Sorry, I do not understand what you mean. Do you still want me to take
care of the order or not? If yes, could you please explain why?

--=20
Best Regards,
Artem Bityutskiy

--=-MXK3X5C572v0NSdM8jDz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJPiVkZAAoJEJtuLFy+q7fe0J4IAIhovj1lOFrIz4bDLwaBC6RE
H0aaXdaEBaejjP6i+t/17kSzKHTx8L3lFc7L85gTYEQtqaL/7WF9cjBN7u9XyCTf
QNc/QGKkcB+ccu47y+OkoQ2SsmUB8/3S/8gvdG+Xi9ImwS8+aSpJIM9lewlKjzaN
mT7h2sp+w0EB/XQFMBhUthFpIKmRdBBgTSj3GbGUlIByBF596Jw9UoXopWXi7jdt
h0wqFf1yzePsjHofm0XsFdEZ6yR+akUsClnQYmZiumRSE5INjGMFZZ4h4kmdkrwf
U4rwC/T2Ye+Ro2M86vdu1NSYeQMoePjwSJ5N2NW3lbsdnHBPWNVmex4iJVV6Ll0=
=nOo5
-----END PGP SIGNATURE-----

--=-MXK3X5C572v0NSdM8jDz--

