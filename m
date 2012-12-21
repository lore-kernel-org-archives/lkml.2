Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2LUP1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:27:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab2LUP1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:27:11 -0500
Date: Fri, 21 Dec 2012 09:26:51 -0600
From: Clark Williams <williams@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.11-rt24 (apocalypse release)c
Message-ID: <20121221092651.55b44bfb@redhat.com>
In-Reply-To: <alpine.LFD.2.02.1212211413200.3148@ionos>
References: <alpine.LFD.2.02.1212211413200.3148@ionos>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/g3NKqU3gkaxQotzOcEjh4hl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/g3NKqU3gkaxQotzOcEjh4hl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Dec 2012 14:50:38 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:
> Index: linux-stable/block/blk-ioc.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-stable.orig/block/blk-ioc.c
> +++ linux-stable/block/blk-ioc.c
> @@ -110,7 +110,7 @@ static void ioc_release_fn(struct work_s
>  			spin_unlock(q->queue_lock);
>  		} else {
>  			spin_unlock_irqrestore(&ioc->lock, flags);
> -			cpu_relax();
> +			cpu_chill();
>  			spin_lock_irqsave_nested(&ioc->lock, flags, 1);
>  		}
>  	}
> @@ -188,7 +188,7 @@ retry:
>  			spin_unlock(icq->q->queue_lock);
>  		} else {
>  			spin_unlock_irqrestore(&ioc->lock, flags);
> -			cpu_relax();
> +			cpu_chill();
>  			goto retry;
>  		}
>  	}
>

Thomas,

I had to add this to get -rt24 to compile:

commit cb25d4b84a6d8f155134f6d9aa2997a452ab1dca
Author: Clark Williams <williams@redhat.com>
Date:   Fri Dec 21 09:22:26 2012 -0600

    [RT] pull in include/linux/delay.h to get cpu_chill()
   =20
    Signed-off-by: Clark Williams <williams@redhat.com>

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 2332787..fb21ad5 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <linux/bootmem.h>     /* for max_pfn/max_low_pfn */
 #include <linux/slab.h>
+#include <linux/delay.h>
=20
 #include "blk.h"
=20

--Sig_/g3NKqU3gkaxQotzOcEjh4hl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlDUf8QACgkQHyuj/+TTEp0zVQCgs6Sx4dgW1+oim5Ce/V9siEhu
2goAnjV3/vhABZ2tTUPgJbJMN93YbXCz
=QuPB
-----END PGP SIGNATURE-----

--Sig_/g3NKqU3gkaxQotzOcEjh4hl--
