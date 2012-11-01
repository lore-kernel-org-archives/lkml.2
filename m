Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab2KAGie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:38:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab2KAGid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:38:33 -0400
Date: Thu, 1 Nov 2012 17:38:54 +1100
From: NeilBrown <neilb@suse.de>
To: Shaohua Li <shli@kernel.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Problem with DISCARD and RAID5
Message-ID: <20121101173854.62061307@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j6eYuHkAH2w63CaJKxOfIEX"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/j6eYuHkAH2w63CaJKxOfIEX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Shaohua,
 I've been doing some testing and discovered a problem with your discard
 support for RAID5.

 The code in blkdev_issue_discard assumes that the 'granularity' is a power
 of 2, and for example subtracts 1 to get a mask.

 However RAID5 sets the granularity to be the stripe size which often is not
 a power of two.  When this happens you can easily get into an infinite loo=
p.

 I suspect that to make this work properly, blkdev_issue_discard will need =
to
 be changed to allow 'granularity' to be an arbitrary value.
 When it is a power of two, the current masking can be used.
 When it is anything else, it will need to use sector_div().

 Could you look into this please?

Thanks,
NeilBrown

--Sig_/j6eYuHkAH2w63CaJKxOfIEX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUJIY/jnsnt1WYoG5AQK7mQ/+KFhc+tpDbo4B4OKz+LkG4tM0tVXBfA6+
s2i0lAWDYpPP4NnzhTYkDzuI6GkudVQshKRfZflsFYkyjl5ozoqqO53/RFDNmsNh
lklKSyXy+hkMBKNUJv2pV66wUtv8xD3Q2RBrUAQpvyU2zLcE+pFxHZIRMi4C1SF7
gzxq4Jt572xGn4djbflWqPXxkyO2zNh+AOIsNVvWSYJ9mN+VDotzAP8ldgTaix5q
sMh7Av191x2X6MtAf5AVrJKI9DLXILbMK95rEAuUNJR6O8PMpiqdF2MLz4hoLSSf
5+LSsXVaWNA+lzIo/AciNy6JVpg2J/cRmdnig6WM9unFS+V1hNvoNzhyj/axm0ZC
4Wy3Rf3oQwYrjl+IJgaoLbI2gtDqQg1NvN+bG9PG2WHM4v+8LZqPScCyuruvK1K9
vldzRKuz9jVIdsiPjNh8qSZYh4dUtJQjaAIZYi7LCJ9rpkoMYJrgAJj5/lnySlbc
Q3DGUKu+CI3AOF4JS4t9K9LzvoTy7pYF00sjeG4KUKEgfRk1HcxF8rh37Df+k828
WkdneY+tzcJ2w9lMhuw8MpVijpC1Dl2Ipngq1ApbqlVapzwXFefhrz/nHMxsfSft
/4u31mk+Jl0yXABvX+qj1hBMOb+OItkT8mskGZuYt3IYFxblDKUpAqr1u959F3Zs
WjovdL93D+c=
=WpqW
-----END PGP SIGNATURE-----

--Sig_/j6eYuHkAH2w63CaJKxOfIEX--
