Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1C1WtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:49:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36846 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab1C1WtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:49:04 -0400
Date: Tue, 29 Mar 2011 09:48:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] memstick: make enable_dma less generic in r592
Message-Id: <20110329094856.3f61a0ce.sfr@canb.auug.org.au>
In-Reply-To: <20110329092416.a4b1d98f.sfr@canb.auug.org.au>
References: <20110328144458.efedbefc.sfr@canb.auug.org.au>
	<20110329092416.a4b1d98f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Mar_2011_09_48_56_+1100_j0YicqYxaV1Zizvs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Mar_2011_09_48_56_+1100_j0YicqYxaV1Zizvs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

ignore this ...  I will send a fixed version soon, sorry

On Tue, 29 Mar 2011 09:24:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 28 Mar 2011 14:44:58 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > Hi all,
> >=20
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >=20
> > drivers/memstick/host/r592.c:26: error: 'enable_dma' redeclared as diff=
erent kind of symbol
> > arch/powerpc/include/asm/dma.h:189: note: previous definition of 'enabl=
e_dma' was here
> >=20
> > Caused by commit 926341250102 ("memstick: add driver for Ricoh R5C592
> > card reader").
> >=20
> > enable_dma() is also defined in a few other architectures including x86
> > (presumably asm/dma.h does not get included there).
> >=20
> > I just reverted that commit for today.
>=20
> I will, instead, apply this patch for today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 29 Mar 2011 09:12:53 +1100
> Subject: [PATCH] memstick: make enable_dma less generic in r592
>=20
> Fixes this build error:
>=20
> drivers/memstick/host/r592.c:26: error: 'enable_dma' redeclared as differ=
ent kind of symbol
> arch/powerpc/include/asm/dma.h:189: note: previous definition of 'enable_=
dma' was here
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Alex Dubov <oakad@yahoo.com>
> Cc: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/memstick/host/r592.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
> index 767406c..ecf3d7d 100644
> --- a/drivers/memstick/host/r592.c
> +++ b/drivers/memstick/host/r592.c
> @@ -23,7 +23,7 @@
>  #include <linux/swab.h>
>  #include "r592.h"
> =20
> -static int enable_dma =3D 1;
> +static int r592_enable_dma =3D 1;
>  static int debug;
> =20
>  static const char *tpc_names[] =3D {
> @@ -267,7 +267,7 @@ static void r592_stop_dma(struct r592_device *dev, in=
t error)
>  /* Test if hardware supports DMA */
>  static void r592_check_dma(struct r592_device *dev)
>  {
> -	dev->dma_capable =3D enable_dma &&
> +	dev->dma_capable =3D r592_enable_dma &&
>  		(r592_read_reg(dev, R592_FIFO_DMA_SETTINGS) &
>  			R592_FIFO_DMA_SETTINGS_CAP);
>  }
> @@ -898,7 +898,7 @@ static void __exit r592_module_exit(void)
>  module_init(r592_module_init);
>  module_exit(r592_module_exit);
> =20
> -module_param(enable_dma, bool, S_IRUGO);
> +module_param_named(r592_enable_dma, enable_dma, bool, S_IRUGO);
>  MODULE_PARM_DESC(enable_dma, "Enable usage of the DMA (default)");
>  module_param(debug, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(debug, "Debug level (0-3)");
> --=20
> 1.7.4.1
>=20
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Mar_2011_09_48_56_+1100_j0YicqYxaV1Zizvs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNkRBYAAoJEDMEi1NhKgbsL88H/j0QA2CUUylxNX+ntUB2I2/V
EgMYLYbxuoYJIZ1AaTxCxrQE5Oi3wfMi6S/2DDwQfKd6OQE3JrYlnAQC6mtCWP3w
dEQQJW3AEhAmwfaG7nTiBpEfOumXaRc3ptVXnVcj9dVP1t1RRUaHYJ/IZDpHsy1L
mJB5aC1bTDdu+PJHyYjShGqr9FjtGJzqSsedVtFlWqwX7gAxPkstcS9QR8VxrFv9
rXYUwZv+c3NH1SzIeEuX+bA3YUFELjccK1toq1GZJ3GKFST6hFP1W3PBucF4ecX7
qQ/0HyYSXT4uHPsXxry8fDg+sYB/mpIQi+4rdsh4WM8GaVXRwdcXztsaFpOGPgM=
=nJBQ
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Mar_2011_09_48_56_+1100_j0YicqYxaV1Zizvs--
