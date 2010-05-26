Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab0EZHOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:14:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49217 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933376Ab0EZHOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:14:33 -0400
Date: Wed, 26 May 2010 17:14:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build warning in Linus'tree
Message-Id: <20100526171424.447fac18.sfr@canb.auug.org.au>
In-Reply-To: <20100525234116.71889c71.akpm@linux-foundation.org>
References: <20100526110506.f2f4f22c.sfr@canb.auug.org.au>
	<20100525182040.f1882d0a.akpm@linux-foundation.org>
	<20100526140900.5b091c16.sfr@canb.auug.org.au>
	<OFC00BDFAC.5596A841-ONC125772F.0022984D-C125772F.0023AF14@transmode.se>
	<20100525234116.71889c71.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__26_May_2010_17_14_24_+1000_u5nwQ6BQuoC2bvOE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_May_2010_17_14_24_+1000_u5nwQ6BQuoC2bvOE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew, Joakim,

On Tue, 25 May 2010 23:41:16 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Wed, 26 May 2010 08:29:45 +0200 Joakim Tjernlund <joakim.tjernlund@tra=
nsmode.se> wrote:
>=20
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote on 2010/05/26 06:09:00:
> > >
> > > On Tue, 25 May 2010 18:20:40 -0700 Andrew Morton <akpm@linux-foundati=
on.org> wrote:
> > > >
> > > > hmpf.  Does this fix?
> > >
> > > No.
> > >
> > > The problem is that __LITTLE_ENDIAN is only defined in
> > > linux/byteorder/little_endian.h which is only included by little endi=
an
> > > architectures ...
> >=20
> > Ah, not sure how to fix this ATM. Perhaps best to revert
> >    crc32: use __BYTE_ORDER macro for endian detection
> > for now.
>=20
> yup.

We also need to revert b3b77c8caef1750ebeea1054e39e358550ea9f55 ("endian:
#define __BYTE_ORDER") in order to get rid of the other warning I pointed o=
ut:

In file included from fs/jfs/jfs_types.h:33,
                 from fs/jfs/jfs_incore.h:26,
                 from fs/jfs/file.c:22:
fs/jfs/endian24.h:36:101: warning: "__LITTLE_ENDIAN" is not defined

I get this warning on powerpc builds for most of the files in fs/jfs ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_May_2010_17_14_24_+1000_u5nwQ6BQuoC2bvOE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv8ylAACgkQjjKRsyhoI8y59ACgpTECm6WZS8UakYPQyGVnnC/y
LVUAnRnaZPSNHlxKvaBDe8xR3O1b7qhY
=uAxp
-----END PGP SIGNATURE-----

--Signature=_Wed__26_May_2010_17_14_24_+1000_u5nwQ6BQuoC2bvOE--
