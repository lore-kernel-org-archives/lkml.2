Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab2JJDMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:12:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44241 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2JJDMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:12:43 -0400
Date: Wed, 10 Oct 2012 14:12:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build failure after merge of the origin tree
Message-Id: <20121010141240.f7e2e7d159f298f94e680c47@canb.auug.org.au>
In-Reply-To: <5074B8B5.3010307@jp.fujitsu.com>
References: <20121010102150.81c192c6fdf60689dc823b20@canb.auug.org.au>
	<20121009164514.b7a7e227.akpm@linux-foundation.org>
	<5074B8B5.3010307@jp.fujitsu.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Oct_2012_14_12_40_+1100_zdQyevsy=QEDJzj2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Oct_2012_14_12_40_+1100_zdQyevsy=QEDJzj2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 10 Oct 2012 08:52:21 +0900 Yasuaki Ishimatsu <isimatu.yasuaki@jp.fu=
jitsu.com> wrote:
>
> 2012/10/10 8:45, Andrew Morton wrote:
> > On Wed, 10 Oct 2012 10:21:50 +1100 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> >
> >> Hi Linus,
> >>
> >> In Linus' tree, today's linux-next build (powerpc ppc64_defconfig) fai=
led
> >> like this:
> >>
> >> arch/powerpc/platforms/pseries/hotplug-memory.c: In function 'pseries_=
remove_memblock':
> >> arch/powerpc/platforms/pseries/hotplug-memory.c:103:17: error: unused =
variable 'pfn' [-Werror=3Dunused-variable]
> >>
> >> Caused by commit d760afd4d257 ("memory-hotplug: suppress "Trying to fr=
ee
> >> nonexistent resource <XXXXXXXXXXXXXXXX-YYYYYYYYYYYYYYYY>" warning").
> >>
> >> I can't see what the point of the "pfn" variable is
> >
> > This:
> >
> > --- a/arch/powerpc/platforms/pseries/hotplug-memory.c~a
> > +++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
> > @@ -101,7 +101,7 @@ static int pseries_remove_memblock(unsig
> >   	sections_to_remove =3D (memblock_size >> PAGE_SHIFT) / PAGES_PER_SEC=
TION;
> >   	for (i =3D 0; i < sections_to_remove; i++) {
> >   		unsigned long pfn =3D start_pfn + i * PAGES_PER_SECTION;
> > -		ret =3D __remove_pages(zone, start_pfn,  PAGES_PER_SECTION);
> > +		ret =3D __remove_pages(zone, pfn, PAGES_PER_SECTION);
> >   		if (ret)
> >   			return ret;
> >   	}
>=20
> I believe the error to be fixed with this patch.
> Could you try it?

The certainly fixes the build problem.  I can't comment in the semantics
of the patch.

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>  (Build only)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Oct_2012_14_12_40_+1100_zdQyevsy=QEDJzj2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQdOeoAAoJEECxmPOUX5FEdKkQAJFxe+cMNnZX4m9DKsJ8MdBU
6usTzt9V34K4bI9vi7bTGS3JsS8yUruqR3WZk4oQYGkBS8YWjlwuXnebf7oVxOgN
H+uqmAznBzI2reEhG8CZS8gvuI86r66Zpru9ZJH38olrDsIm/0qifjGDYH7R/hoU
Si0cAjAf22lN4S/L32nTavlIa/Qwhyg+tbkNg6d49fGsBBpqEQidgEiYjqGWfM5K
+ThgGpaX6Uf0M789zZyt59fnj4O0novvfK9HbYmz6Q1j27yZjyf8mLxwUHB+pOEh
IUhACMrVuwgxzSPWghnoxS8f3P+J67pkjmVwpDnUH9fi+4ltwxuNb3UAgPvmALoC
X6GVbJgspS8xu3KmMwYuNFMVSYlPbfZrjelildmiTypAQoDLyK0v7qWINwWmBCrM
JmZKPr+fy17BS2MUu6TBNbyM/acuBtEEwdCgjFcr4zArhyiPJMNj5/pzm0YU3ydg
kW8ibUBQyJipLX/6Q1Df1fAvG2ODWEbpEUm7auEyinurfqtKtKWko5YnYFoGtPs0
cFm52gm5v/b3jZplGrN+hfV122lvJTrvMWWD/g/sNdcbsHxHvHkvXJFP14qvCd9V
tnS7+dxTM9VSY2sr9K5LfdGROmwL3lOP749449jzQHotY0xv0y77hU+7oF6T8NZ8
PAJBzk+Ry2mtlc18mD3X
=4B8a
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Oct_2012_14_12_40_+1100_zdQyevsy=QEDJzj2--
