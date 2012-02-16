Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2BPEX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 23:23:29 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38689 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2BPEX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 23:23:26 -0500
Date: Thu, 16 Feb 2012 15:23:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20120216152316.821ac82e04a5ee30327b81c3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Feb_2012_15_23_16_+1100_7a2csSZoc5eXdZ/j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Feb_2012_15_23_16_+1100_7a2csSZoc5eXdZ/j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/ramster/zcache-main.c:2969:2: error: unknown field 'invalid=
ate_page' specified in initializer
drivers/staging/ramster/zcache-main.c:2969:2: warning: initialization from =
incompatible pointer type [enabled by default]
drivers/staging/ramster/zcache-main.c:2969:2: warning: (near initialization=
 for 'zcache_cleancache_ops.put_page') [enabled by default]
drivers/staging/ramster/zcache-main.c:2970:2: error: unknown field 'invalid=
ate_inode' specified in initializer
drivers/staging/ramster/zcache-main.c:2970:2: warning: initialization from =
incompatible pointer type [enabled by default]
drivers/staging/ramster/zcache-main.c:2970:2: warning: (near initialization=
 for 'zcache_cleancache_ops.flush_page') [enabled by default]
drivers/staging/ramster/zcache-main.c:2971:2: error: unknown field 'invalid=
ate_fs' specified in initializer
drivers/staging/ramster/zcache-main.c:2971:2: warning: initialization from =
incompatible pointer type [enabled by default]
drivers/staging/ramster/zcache-main.c:2971:2: warning: (near initialization=
 for 'zcache_cleancache_ops.flush_inode') [enabled by default]
drivers/staging/ramster/zcache-main.c:913:13: warning: 'zcache_do_remotify_=
ops' defined but not used [-Wunused-function]
drivers/staging/ramster/zcache-main.c:1002:13: warning: 'ramster_remotify_i=
nit' defined but not used [-Wunused-function]

I do wonder if any of this was build tested with CONFIG_CLEANCACHE enabled =
...

Caused by commit 19ee3ef5f4bb ("staging: ramster: local compression + tmem"=
).

I have used the staging tree from next-20120215 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_Feb_2012_15_23_16_+1100_7a2csSZoc5eXdZ/j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPIS0AAoJEECxmPOUX5FEaE4P/0TaIcTAwY4fICzCxIKSWQHE
W6U3zEXS29E5DdRnkXCAUuM9Gq4eY7SYsSkfGlXaVWDzEoo5zJTVCMmHbbvvHwOa
a4PJTdoZ01CRxtd9X1XBjkXz8ntRei4zUolc2fQncheKXNVxIjCzbICszr7jd5hi
vYL/+ttVoeqihCBW29/tF8mIVfnAePKcmhbEZlofrvI+1z6/hUJm4DPTPOW+UYmd
8FFzIiCm1b5gw76mwd2iNI63g17bwkRvx45Jxjuiinmd7rs9Z33VdPfk8v61BS0E
WAUhCmGMV2G1hE03TY0h+3HtXIrzCgIn9L4QToHC30wbENi+L+DPU6Cwvcl1Y9v8
+0nw/VduWQQY/hnIr7nNKAz+z7zKscKFrOn+j+M5mDscHID/tVi1+Z3CU8RwyNuu
rTUqTlvQh19sRxC4+4N7DlorusfkC1Iu4WURhl6FXI2koh0bZVnU32K+DxgiwGIz
CPCkuEbkwyJe9zC7TMhjaOkqE/o2ALGwoIIMogdYOyMOSX/D4R2xQBLRkS+3k002
czMvx997PztmHLcTMQfvb97Aw35X2Av0zqvpslE4jmWE/o06oyFx8C5wALfP5A9K
Z9CUntQ6tVcw9nF8rDAMdrX2qFvnPmFzK/M2gv868CBAake9EyTbHUHwCLQJ+cYJ
UFaXCTUTPfRXLVDkzM3L
=oEdT
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Feb_2012_15_23_16_+1100_7a2csSZoc5eXdZ/j--
