Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab2HVF76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:59:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51758 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab2HVF7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:59:52 -0400
Date: Wed, 22 Aug 2012 15:59:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120822155941.ae0b4c163fc15346a9863e5e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__22_Aug_2012_15_59_41_+1000_shjchiW+qPyt5LSs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__22_Aug_2012_15_59_41_+1000_shjchiW+qPyt5LSs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/page_alloc.c between commit c67fe3752abe ("mm: compaction: Abort async
compaction if locks are contended or taking too long") from Linus' tree
and commit "mm: remove __GFP_NO_KSWAPD" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/page_alloc.c
index 5b3cc33,cefac39..0000000
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@@ -2436,11 -2429,10 +2435,10 @@@ rebalance
  	/*
  	 * If compaction is deferred for high-order allocations, it is because
  	 * sync compaction recently failed. In this is the case and the caller
 -	 * has requested the system not be heavily disrupted, fail the
 -	 * allocation now instead of entering direct reclaim
 +	 * requested a movable allocation that does not heavily disrupt the
 +	 * system then fail the allocation instead of entering direct reclaim.
  	 */
- 	if ((deferred_compaction || contended_compaction) &&
- 						(gfp_mask & __GFP_NO_KSWAPD))
 -	if (deferred_compaction)
++	if (deferred_compaction || contended_compaction)
  		goto nopage;
 =20
  	/* Try direct reclaim and then allocating */

--Signature=_Wed__22_Aug_2012_15_59_41_+1000_shjchiW+qPyt5LSs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNHVNAAoJEECxmPOUX5FEL+8P/2G97GqOartwonS/sV11xvod
eHagUWREkNHVMG9Mp09s8ujP1c1bNeF6b7kBuPW8t9izRpojCssHESQloPS9qBmY
S0FHoMdv88nWNcMmIB2iUjnr9VrLGBsBDsSsh7XmAVFogp5ul2ZtJVNzUMLSY6FW
IETCWBas3JuMGUzNgAc0V8EFtGnezsgi4u+ii9+x6utb0Kyp+edvpX1lInH2OlwG
6K59TebRMqtZNaiPooooyI6NXCGzHd6QNJVYMGaJzH4GI74/7Zx+hDQehJz4N7Hr
Xgh10u9qPDXu4wMaVioE0oNiDkha79QW64HYV92l2WvAD2YCWeDD4fMwPAPGQSeG
eZktQsk4QFjfYz0yNQYlke7OFB6hNHAnZErf2kkLem1sVcROyMpPD0f2cCXO9oiI
Sh5+4+sgT97gfpK24wvLXAbcq2LU8VV6oISP28gpVckFV4VVbNnuBG2MzYm6HpeC
WoXuNWqsWlH8Fk5hKuNpijAYPgeHCDZN7tKnfnlHFVOR3fhksEdvlL67Oa24SZ7q
w4cBkZcPhvryQqqUIWrijFhDGWJVomZmrH7SmZURxYyFCgwPWHNckK6HYddc/aoj
8OXHuZLTzAACTEumrS5WNwzb409/uplqhnK64Hm6W7Weo4hxyRZPE6Tl13P+FuzD
qlV7KLrH95lXhh5GkCBA
=AU86
-----END PGP SIGNATURE-----

--Signature=_Wed__22_Aug_2012_15_59_41_+1000_shjchiW+qPyt5LSs--
