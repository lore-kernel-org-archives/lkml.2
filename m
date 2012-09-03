Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2ICHNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 03:13:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:4630 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab2ICHN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 03:13:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,359,1344236400"; 
   d="asc'?scan'208";a="217091137"
Message-ID: <1346656701.3061.8.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/3] mtd: cmdlinepart: make the partitions rule more
 strict
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <shijie8@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, shmulik.ladkani@gmail.com
Date: Mon, 03 Sep 2012 10:18:21 +0300
In-Reply-To: <1346001700-26895-1-git-send-email-shijie8@gmail.com>
References: <1346001700-26895-1-git-send-email-shijie8@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-9fZP69khWFNkhHgyu8ei"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9fZP69khWFNkhHgyu8ei
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-08-26 at 13:21 -0400, Huang Shijie wrote:
> + *
> + * Note:
> + * If you choose to set the @offset for the <partdef>, please set all
> + * the partitions with the same syntax, such as:
> + *     gpmi-nand:100m@0(boot),100m@100m(kernel),1g@200m(rootfs)
> + *
> + * Please do _NOT_ set the partitions like this:
> + *     gpmi-nand:100m@0(boot),100m(kernel),1g@200m(rootfs)
> + * The `kernel` partition does not set with the @offset, this is not per=
mitted.
>   */

I guess it is indeed OK to sort the partitions, just makes things a lot
simpler. But we probably then should also do the following:

1. Make sure there is only one partition without offset. If there are
several - error out.
2. Check that partitions do not intersect - I did not notice that we do
this in the code.

So AFAICS, this patch is not needed and we better have the following
patches:

1. Add sorting
2. Add a check that partitions do not overlap and there is only one
offset-less partition.

How does this sound?

--=20
Best Regards,
Artem Bityutskiy

--=-9fZP69khWFNkhHgyu8ei
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQRFm9AAoJECmIfjd9wqK0alEP/2N4sLMc+BCZORu/hH7gEHQd
99Rb8zTcZKASwJac0Mj1aRDwFO91Cf/vQGNbQ/kjKq+Sx3R/MjODDss5Ltq8cldb
1QwUiBfnz70Dgp7sIjTBlM36d/udYI0Nv8VkyS1WTHZcXWxPXnmIW24o7JwXkktP
VDZypdRUoW1pqif4CrevKBmPcDqmrChFRLgSpZDBJkV3zTSW08yylNhFYelbVc6H
m/yR45uuOKytpNE0S/GTJZmSMKuJr0yR0CYZxNIvrDUihuZYvERQuP8a98R8NEa8
RRgX0FctkRhxDreuco07U74g1pooI1q12QBsUzSotkpqrjf5jbKVSz1fElNYqIX1
LIMz6VWIDNs8Ro0/N/ei31VaBFLBCumMkWsDmZ/+AUcGoUmQ/tCpNDIc7g5l4j1I
nf8LTytu0vWNCPMc3rQI3vNFDoC1WhikrxevitXJg8CLcAESHKJeq32KJUsOeVLC
UFO8TWM5Npk8Pj4N5QVuZ0QE/Ms15Z5hS4SYKzbInXcWAS8JDhZEKL1ULViiWvd0
5x+fiOCzLblDnF5LNLFZI0fieU8Pywnh9z5OgX+6xkXH2kiSQgg1kuYSLjk9Qcdk
gqYayBB+qDu/vQ5F/lX8CNt3z4Ycr8NXeBzKzDzediz2THDlqx5vic2vHk2V+DCf
hzs5tWaRF+dm4KkXkZ1U
=OYQ/
-----END PGP SIGNATURE-----

--=-9fZP69khWFNkhHgyu8ei--

