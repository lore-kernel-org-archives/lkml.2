Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab2CNALK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:11:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52352 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab2CNALJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:11:09 -0400
Date: Wed, 14 Mar 2012 11:10:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: manual merge of the tile tree with Linus' tree
Message-Id: <20120314111057.499d4901f51264c2012fd2b1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Mar_2012_11_10_57_+1100_zALu6s2BheQjTHzv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Mar_2012_11_10_57_+1100_zALu6s2BheQjTHzv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the tile tree got a conflict in arch/Kconfig
between commit 43570fd2f47b ("mm,slub,x86: decouple size of struct page
from CONFIG_CMPXCHG_LOCAL") (and a couple after) from Linus' tree and
commit ca3a3d347e23 ("ipc: provide generic compat versions of IPC
syscalls") from the tile tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/Kconfig
index 4f55c73,dfb1e07..0000000
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@@ -185,18 -181,7 +185,21 @@@ config HAVE_RCU_TABLE_FRE
  config ARCH_HAVE_NMI_SAFE_CMPXCHG
  	bool
 =20
 +config HAVE_ALIGNED_STRUCT_PAGE
 +	bool
 +	help
 +	  This makes sure that struct pages are double word aligned and that
 +	  e.g. the SLUB allocator can perform double word atomic operations
 +	  on a struct page for better performance. However selecting this
 +	  might increase the size of a struct page by a word.
 +
 +config HAVE_CMPXCHG_LOCAL
 +	bool
 +
 +config HAVE_CMPXCHG_DOUBLE
 +	bool
 +
+ config ARCH_WANT_OLD_COMPAT_IPC
+ 	bool
+=20
  source "kernel/gcov/Kconfig"

--Signature=_Wed__14_Mar_2012_11_10_57_+1100_zALu6s2BheQjTHzv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPX+IRAAoJEECxmPOUX5FEvgsQAKXrAOsJhLBvCmUbyV8NNhqv
VK5tLcg927vOS4JuaBvjcUmrdI9Cw3lrEU80u6mbiC/dt5o8W//iPaPrrL8Yw8aK
lPKig2hQVX71s2XFq1qOzVeeE6RYXhx59uSdkfyTk8hthprvdf2tNpe6VcNxhfBX
vZFwzD//Tvem7w4nQ1TsT/JJQX6lC0Mlzbe9mT739G3Atd2SvoPk18fES7qn0dhR
9rZVekf0EJLR+3RxNuwLBQsJIUyg0qgYo0zkzyb//ry/VFMeOb5qqq9AmlomBHYB
rsAyqmdhkL5iL4FuXbrGf21VUTb8UJrkiReyPwoifr8S/MPgykBYv44L1/VltY3S
RjwL4fdKabTXhslE0NcivqLnBv/BKivL8g5R5erKqTl4ifvKnjvBek5EVkFza+SO
XcBSB1pGEJ/wMDEnB7rsMp8p54sPhwgBek24RhcddeLQVg8fN44tKfIjETdYsJr5
xH+xtzJiQHPN+ncOgtZz/5I8t5tEzZyBMapTPhKuaP5SOyC2BnSEveyhM5f2Kkxt
QlbCBS+azz307DVKcZpizyEuh0biIixIHbw+alFnU2pr7gO313n1d+Y5rVR1B/o4
7qOONpcVb1g0KhxSAuJIw/t5tw7QpS7YkET3YaG0DEi7k8I1fHuSbgS3BkhqkS+L
OLJR2Lpjk0PuB/+J9bMP
=3kvj
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Mar_2012_11_10_57_+1100_zALu6s2BheQjTHzv--
