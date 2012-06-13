Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2FMWPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:15:15 -0400
Received: from 74-92-214-37-Colorado.hfc.comcastbusiness.net ([74.92.214.37]:33938
	"EHLO zlynx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2FMWPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:15:14 -0400
X-Greylist: delayed 1406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2012 18:15:14 EDT
Message-ID: <1339624293.2080.24.camel@knife>
Subject: Re: [PATCH 1/2] msync: support syncing a small part of the file
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Date: Wed, 13 Jun 2012 15:51:33 -0600
In-Reply-To: <20120613142614.6af42ef5.akpm@linux-foundation.org>
References: <1338497035-13014-1-git-send-email-pbonzini@redhat.com>
	 <1338497035-13014-2-git-send-email-pbonzini@redhat.com>
	 <20120613142614.6af42ef5.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-RbT3ajMiRDRefmjpqVCd"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20120613/1SevTa-0005AB-CR-linux-kernel@vger.kernel.org:zlynx@acm.org:74.92.214.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RbT3ajMiRDRefmjpqVCd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-13 at 14:26 -0700, Andrew Morton wrote:
> On Thu, 31 May 2012 22:43:54 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> > msync does not need to flush changes to the entire file, even with MS_S=
YNC.
> > Instead, it can use vfs_fsync_range to only synchronize a part of the f=
ile.
> >=20
> > In addition, not all metadata has to be synced; msync is closer to
> > fdatasync than it is to msync.  So, pass 1 to vfs_fsync_range.
>=20
> Would be nice, but if applications were previously assuming that an
> msync() was syncing the whole file, this patch will secretly and subtly
> break them.  Convince me that this change won't weaken anyone's data
> integrity ;)

As an interested observer and a programmer who uses msync()...

I never assumed msync() did the whole file. It has an address and length
argument. I always assumed it only looked for dirty pages within that
range. That is also what the msync() documentation claims.

As for weakening data integrity because of assumptions programmers *may*
have made, I think this is a bad argument which followed to its logical
conclusion can only lead to requiring an implicit sync() before and
after every system call. :-)

Asking programmers to use sync_file_range() is not a replacement for
improving msync() because msync() is POSIX and can be used everywhere.
sync_file_range() requires Linux specific code.

--=20
Knowledge Is Power
Power Corrupts
Study Hard
Be Evil

--=-RbT3ajMiRDRefmjpqVCd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJP2QtlAAoJENwGilc5WTdRgnEH/1lq3Oi6re8Nz5z7PNYYloFv
H7NT5uKZLGGfX9NXNCHo9o7Fsva3JvxB4y22OH2OCmZSic6K0c3oFsUat66RbMHp
CalKNKhI6vkvFErOAsUbhGW/ncyNnuWFQBvNBx7SMu6ZGsmQbEXj1nU9cdiUmKLR
XjvQ7XsM8dOJl+neR4DrkWmSb2Nw0afvJNkqRliSuM5x1ObgOkS/ebXJAkWGjf/X
jLPvBTwMdJfMi0O+pPY9H9fN/Bkx3XkjJXJIULaPxUXpakwWr/oc2RtlYCXGvUq9
VnAiEu0hAQ8ET3v1RfSg6WgPxeqi5yjPyCpwo7rbdEedE7+zntLchC6qSIDAO9M=
=ZJJa
-----END PGP SIGNATURE-----

--=-RbT3ajMiRDRefmjpqVCd--

