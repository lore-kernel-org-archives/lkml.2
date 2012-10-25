Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755Ab2JYOU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:20:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44981 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519Ab2JYOUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:20:24 -0400
Date: Fri, 26 Oct 2012 01:20:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the akpm tree
Message-Id: <20121026012022.16c84e1f1a01bd30c3f2bb93@canb.auug.org.au>
In-Reply-To: <20121025130952.GA4730@richard.(null)>
References: <20121025142854.1924363d6a607004f918ac63@canb.auug.org.au>
	<20121025130952.GA4730@richard.(null)>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Oct_2012_01_20_22_+1100_q4.sQAL12Rh7M7PT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Oct_2012_01_20_22_+1100_q4.sQAL12Rh7M7PT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

On Thu, 25 Oct 2012 21:09:52 +0800 Richard Yang <weiyang@linux.vnet.ibm.com=
> wrote:
>
> On Thu, Oct 25, 2012 at 02:28:54PM +1100, Stephen Rothwell wrote:
> >
> >After merging the akpm tree, today's linux-next build (powerpc
> >ppc64_defconfig) produced these warnings:
> >
> >drivers/infiniband/hw/cxgb3/cxio_resource.c: In function '__cxio_init_re=
source_fifo':
> >drivers/infiniband/hw/cxgb3/cxio_resource.c:62:3: warning: comparison of=
 distinct pointer types lacks a cast [enabled by default]
> >drivers/infiniband/hw/cxgb3/cxio_resource.c:74:4: warning: comparison of=
 distinct pointer types lacks a cast [enabled by default]
> >drivers/infiniband/hw/cxgb3/cxio_resource.c:81:4: warning: comparison of=
 distinct pointer types lacks a cast [enabled by default]
> >drivers/infiniband/hw/cxgb3/cxio_resource.c:86:4: warning: comparison of=
 distinct pointer types lacks a cast [enabled by default]
> >drivers/infiniband/hw/cxgb3/cxio_resource.c:89:7: warning: comparison of=
 distinct pointer types lacks a cast [enabled by default]
> >drivers/infiniband/hw/cxgb3/cxio_resource.c: In function 'cxio_init_qpid=
_fifo':
> >drivers/infiniband/hw/cxgb3/cxio_resource.c:123:4: warning: comparison o=
f distinct pointer types lacks a cast [enabled by default]
> >drivers/infiniband/hw/cxgb3/cxio_resource.c: In function 'cxio_hal_get_r=
esource':
> >drivers/infiniband/hw/cxgb3/cxio_resource.c:184:6: warning: comparison o=
f distinct pointer types lacks a cast [enabled by default]
> >drivers/infiniband/hw/cxgb3/cxio_resource.c: In function 'cxio_hal_put_r=
esource':
> >drivers/infiniband/hw/cxgb3/cxio_resource.c:193:2: warning: comparison o=
f distinct pointer types lacks a cast [enabled by default]
> >drivers/infiniband/hw/cxgb3/cxio_resource.c:193:2: warning: comparison o=
f distinct pointer types lacks a cast [enabled by default]
> >drivers/infiniband/hw/cxgb3/cxio_resource.c:193:2: warning: comparison o=
f distinct pointer types lacks a cast [enabled by default]
> >
> >Probably introduced by commit "include/linux/kfifo.h: replace open-coded
> >type check code with typecheck()".
>=20
> You test this on ppc64 platform?

I use a ppc64 cross compiler.

> As I reading the code, the second parameter of kfifo_in() should be type
> "const void *".=20

That is probably true.

> Hmm. I am not sure this error is there before the patch?

There was no warning before the patch.   There are also lots of similar
new warnings in a x86_64 allmodconfig build.

Given that your patch just exposes already existing problems, we need
patches that fix those problems.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Oct_2012_01_20_22_+1100_q4.sQAL12Rh7M7PT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQiUqmAAoJEECxmPOUX5FEBnQP/2C0Rsm4CbS2sx0eQOFHo+do
AYfKdT+Svk2sWJb2g5+miWoaYDN+AOnEj3ULDoC0GsqadaMYd2moR9ZSOctUA0Hx
ajzPykpDhlpzd1HQ5PnxhiEOyO89rvmYVpxEIFZ/poV9y9D1av6BEHEIEDZWnEb4
rjbBdj0vZvwp/zatey2OBSEladSTzrBetYJTeNrkvghIh411efsZEUpluFQBtxcP
bm865fc99+GogfbDrVBHTh1AF3YNL0Otjo5gxdrLiUsE6SxQlFeAbS0GFj8FQgqI
uAosHlek7yaw8mPlLimtMfzMzrR6sIGHum/Y9Ax9djm2NHTChqaJqsRjFN7usIVX
RpL7nRjWsaHaUoFi0QfWsJO7uMEbsEqb2VEXoZeui+Zw4pE03evSRiKMIKYDbrqE
K8KUoH+YZQBEd4NVf9cu7CkLomCZ8iXpOAPlcYoiwVx/ZGKLz7raagtxN7jALeHU
LHOz9KnalzvmWGZKOd7FKAS/m82zY/AEgsUH5auS43GfUuINXD3As6LzPbj1Iulf
W96vGpYJMO8C+azf5jiIcV4LEn6iAqHrWlTVdgpdkPiB5ZfEEJOXlHQhIfz4MaD4
nRzUuEXMrJ0Es/JlHgG06bvKmItRp3PdpdFBqiK9Oh0cLXqwY3gpdwRcUCOrxqLX
r/cHbryM1fyTCddekfX2
=WjYj
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Oct_2012_01_20_22_+1100_q4.sQAL12Rh7M7PT--
