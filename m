Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2EUDma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 23:42:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49614 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2EUDm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 23:42:28 -0400
Date: Mon, 21 May 2012 13:42:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20120521134219.6d6396802bd6a097503bac92@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_13_42_19_+1000_i=NmTkY1Q5CG.FYg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_13_42_19_+1000_i=NmTkY1Q5CG.FYg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

In file included from drivers/mfd/ab8500-core.c:21:0:
include/linux/mfd/dbx500-prcmu.h:614:19: error: redefinition of 'prcmu_abb_=
read'
include/linux/mfd/db8500-prcmu.h:673:19: note: previous definition of 'prcm=
u_abb_read' was here
include/linux/mfd/dbx500-prcmu.h:619:19: error: redefinition of 'prcmu_abb_=
write'
include/linux/mfd/db8500-prcmu.h:678:19: note: previous definition of 'prcm=
u_abb_write' was here
include/linux/mfd/dbx500-prcmu.h:630:19: error: redefinition of 'prcmu_conf=
ig_clkout'
include/linux/mfd/db8500-prcmu.h:643:19: note: previous definition of 'prcm=
u_config_clkout' was here
include/linux/mfd/dbx500-prcmu.h:692:20: error: redefinition of 'prcmu_ac_w=
ake_req'
include/linux/mfd/db8500-prcmu.h:683:20: note: previous definition of 'prcm=
u_ac_wake_req' was here
include/linux/mfd/dbx500-prcmu.h:694:20: error: redefinition of 'prcmu_ac_s=
leep_req'
include/linux/mfd/db8500-prcmu.h:685:20: note: previous definition of 'prcm=
u_ac_sleep_req' was here

Caused (exposed?) by commit d28f1db8187d ("mfd: Remove confusing
ab8500-i2c file and merge into ab8500-core").  I assume that this has
only had very restricted build testing :-(

I have used the mfd tree from next-20120511 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_May_2012_13_42_19_+1000_i=NmTkY1Q5CG.FYg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPubmbAAoJEECxmPOUX5FEheQP/R5ggBGNCC729Dig4WyCb0aE
GJR37ekdQEjCDD5+rWmVyCg/bhoHh1sCdvFYYDB/xSbvIaWmXgF2ksulYU6CsvDn
QV22nFCr3M52ituAssnb73n1LY9wLGU+6XN4Z0498j01yn8qeXS08yWR+NuvNGOu
/AhWYNfh2UTEQsSMHd5g6tJ1VQQG/E2ZEKdgkSIhBaDb45VB687zRmeyqy6M32kS
/VR26Qdw9Z8R/S8q0Pd+Mu63avtrp21d/n5ZnOqqOwEjQ6+Obqnk0Abus4ysphmP
DJq11rkkz+P04FIspXWzQxb9KhISGwAPDHPTnoGalF2wv1H/yPuSUQCtiOiFo8D6
jFaWzR72t7Ef3GDzvFEdLTId5qWC7BZWpCMxDdQGN7eSp6cxNcTItUWH3rgN9+xf
QQ7+8zQtQCMZdG7Y65WpVEZAnOEP///a6iyVpqvjXcVaTWQYbGTvVOrmBEdl8k7V
GigACea0HvfUKl6FWUNCprgElnoqyqeXdW+U55ixxTddsn5ZIITpljcChphQXTaL
LcyGphKVOufKRNmgq3mpUZe9CKwlzKanQMrMJZhzjLGc7eVB2kXgzhCR/mxlYi96
RYq4WcIsCd+iZ8jSkO1k3qn5r2TeX0hJbbxkmu/Rci+TY8jmr6P6MHUwUqvKjtuj
1YUQfR4geRnFQjcQgI+R
=8E9p
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_13_42_19_+1000_i=NmTkY1Q5CG.FYg--
