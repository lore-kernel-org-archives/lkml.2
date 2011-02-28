Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1B1CQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 21:16:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35832 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab1B1CQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 21:16:08 -0500
Date: Mon, 28 Feb 2011 13:15:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree (kvm
 tree related)
Message-Id: <20110228131556.3822f3ca.sfr@canb.auug.org.au>
In-Reply-To: <20110221175658.2dc4d1ac.sfr@canb.auug.org.au>
References: <20110221175658.2dc4d1ac.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Feb_2011_13_15_56_+1100_IGf8G/kfy/bYPeBD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Feb_2011_13_15_56_+1100_IGf8G/kfy/bYPeBD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All,

On Mon, 21 Feb 2011 17:56:58 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
>=20
> mm/memory.c: In function '__get_user_pages':
> mm/memory.c:1584: error: 'EHWPOISON' undeclared (first use in this functi=
on)
>=20
> Caused by commit b1c4f2836370f5c8207d4c61e91c93bd6a4ce27a ("mm: make
> __get_user_pages return -EHWPOISON for HWPOISON page optionally") from
> the kvm tree.
>=20
> Not all architectures use include/asm-generic/errno.h ...
>=20
> I have reverted that commit (and commits
> d47b742c5661385b927c03188549b2d2004b80f4 "KVM: Replace
> is_hwpoison_address with __get_user_pages" and
> eef8839430b72deac59e9ec51eb56c44512fcc66 "mm: remove is_hwpoison_address"
> which depend on it) for today.

I am still doing those reverts ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Feb_2011_13_15_56_+1100_IGf8G/kfy/bYPeBD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNawVcAAoJEDMEi1NhKgbsSf4H/1Y5qYEvU0g1lD0oqmDwL0DV
Dn5+LFsG+AIcGc6RbwVn36IvdjXc7DSQVrv1d8CQvchYphZVRxZlX/ImBPLVzrxY
2N3/G4F3oRFcz2SqPkF1ahSK4hA7AlQrm3jQPKjNwwla3aWclP4HPjPc1oep9WjO
lSlXWdHVWij3OtGLzyKzjx0XhPX60kOREm4Hua4aABaKyhZjqOdA2F7XhPYr/1lx
NyitkJTjr/TfyNK9LfPXcUSD0t7H5hBo3t9/j2L2DjFvIE/VmhY84Vg14kwdQV5x
VDIWTQSsQ3wcIZvPQ4AQZVOoGB8PG2GMembjYtieSsZp8WgFTjteKAGJVBXSHLU=
=iwhp
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Feb_2011_13_15_56_+1100_IGf8G/kfy/bYPeBD--
