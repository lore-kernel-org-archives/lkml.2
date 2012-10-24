Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934628Ab2JXK0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:26:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48470 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab2JXK0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:26:31 -0400
Date: Wed, 24 Oct 2012 21:26:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, xemul@parallels.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch added
 to -mm tree
Message-Id: <20121024212620.da7147354d523151c97de962@canb.auug.org.au>
In-Reply-To: <20121024095959.GA30240@moon>
References: <20121023220300.1185C200057@hpza10.eem.corp.google.com>
	<20121024084515.GB30983@moon>
	<20121024204746.8a8c0fa14b6495b5d5013db4@canb.auug.org.au>
	<20121024095959.GA30240@moon>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Oct_2012_21_26_20_+1100_kLh9o+cWp_BP.4FQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Oct_2012_21_26_20_+1100_kLh9o+cWp_BP.4FQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cyrill,

On Wed, 24 Oct 2012 13:59:59 +0400 Cyrill Gorcunov <gorcunov@openvz.org> wr=
ote:
>
> On Wed, Oct 24, 2012 at 08:47:46PM +1100, Stephen Rothwell wrote:
> >=20
> > On Wed, 24 Oct 2012 12:45:15 +0400 Cyrill Gorcunov <gorcunov@openvz.org=
> wrote:
> > >
> > >  static void show_smap_vma_flags(struct seq_file *m, struct vm_area_s=
truct *vma)
> > >  {
> > > +#define __VM_FLAG(_f, _s)	[ilog2(_f)] =3D {(const char [2]){_s}}
> >=20
> > I really don't think you need the cast (and it may hide bad usages) or
> > the second set of braces.  Thus:
>=20
> Hi Stephen, could you please elaborate, which bad usage hiding could be t=
here?

I though it might suppress a warning if someone added an entry with a >2
character string, but testing shows that it does not, so that is OK.
There is still no need for the cast, though, or the second set of
braces.  The C standard allows fixed length char arrays to be initialised
by string constants and discards the trailing NUL if necessary.

> > Further is there any reason for the struct?
> >=20
> > #define __VM_FLAG(_f, _s)	[ilog2(_f)] =3D _s
> >=20
> > static const char mnemonics[BITS_PER_LONG][2] =3D {
> > ...
> > };
>=20
> Well, good point, though the benefit of using stucture here
> could be easier way for extension if needed. The compiled result
> is the same as for plain array or structure, so I would rather
> stick with struct here, until contrary proved (I mean it's not
> a problem to update the patch and use array here but I still
> think struct it better in long term). If you guys think that I
> should move it to array -- no problem, i may update ;)

One thing we learn about early (especially working at IBM) is to resist
the temptation to over engineer :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__24_Oct_2012_21_26_20_+1100_kLh9o+cWp_BP.4FQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQh8JMAAoJEECxmPOUX5FEGtgQAKmw18dVL1JC0+rWLtcyUyFo
/nBbXZ14T7rgCwIA8WtGfURp1hYH4+8bzuJoOKqIB3x+Xw9L2kSKuwnaJerfHC7V
pt0UjUKtE7s6ShUv9lhA6zIhSm4+i96n/8KBf/1rfF+rFnhbMQjDUjfkHHwwBpNt
uHKd8eP644cojBE2f50Ew4x+juAuQ6EM1+SiBGMS7dmBwOYnWVbDa9BM1xoFEVJD
SuETvc7UxyjQI1IpOzFpPuffQQ8ElC1dRBFtXy8Vr+mc9HaBYExTnIpi40HDUDBB
7QSO02BssWzqMWfSJGICmTORi+6TY1x3rxHXziEOFC0TsNCelRGjiZKBBtqypuos
68RBTwlHKIj0AUXr8Cf7f7dRmKAVMdce0ybzAPDsfzqGJ2WS7clmXF2TSOfkxFSs
wBCTeqKhRlhVffpaCj8fblD3L2Z6Mrj4dLFKI24Y1Gh31UHlKk4EdgG9eONbDmEg
6RkzhH8BPDRZZlaqI6yaTS3x6z1A+HVssgCl/MArWgaXNk70OHBvI9jjTjiZNfVA
oLdGg1ATHUyxtRDvj/rrCtlrgMxGGiO449QQJGapABLoxrThAlIgHfISCPN97URn
0qFleUGXEe71b/eB0y9HNFLJUhNtTnkD2xDG3uJ+WvGZYugT1xu+/AtSuTKWfFgq
rJP3g1T7LDsxUT2R6ben
=8dLL
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Oct_2012_21_26_20_+1100_kLh9o+cWp_BP.4FQ--
