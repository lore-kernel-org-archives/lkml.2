Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2DBAha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 20:37:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55199 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2DBAh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 20:37:29 -0400
Date: Mon, 2 Apr 2012 10:37:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the tile tree with Linus' tree
Message-Id: <20120402103719.c65942de252fc39af503acf4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Apr_2012_10_37_19_+1000_9CHuYFvz76nZOYK6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Apr_2012_10_37_19_+1000_9CHuYFvz76nZOYK6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the tile tree got a conflict in
arch/tile/include/asm/pgtable.h between commit bd119c692393
("Disintegrate asm/system.h for Tile") from Linus' tree and commit
7dc0069e58f6 ("arch/tile: Allow tilegx to build with either 16K or 64K
page size") from the tile tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/tile/include/asm/pgtable.h
index 6749091,ff01704..0000000
--- a/arch/tile/include/asm/pgtable.h
+++ b/arch/tile/include/asm/pgtable.h
@@@ -27,8 -27,11 +27,10 @@@
  #include <linux/slab.h>
  #include <linux/list.h>
  #include <linux/spinlock.h>
+ #include <linux/pfn.h>
  #include <asm/processor.h>
  #include <asm/fixmap.h>
 -#include <asm/system.h>
+ #include <asm/page.h>
 =20
  struct mm_struct;
  struct vm_area_struct;

--Signature=_Mon__2_Apr_2012_10_37_19_+1000_9CHuYFvz76nZOYK6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPePS/AAoJEECxmPOUX5FEAvQQAJ2iimowTopOreYgzH9WZdBm
Aaa6Be6ATClOUMTgWLDjPXArBUzGOOYI06GMH17YmT9RkHZ9N6c6/Gdgk+0Qoih4
nLQOyfTqMJN9cHkln7PIbKUfCWp9GFo2/T9o86WelDmXnGSHbq2Vp9wSLtHxFY+1
PofVqaijh5UX3myn17xq58vbN6Q/+CEI+tfUHykd6Qk0db25xCzpgIT3M8Z4uhts
Xcs8G+7wBFr7Kt4gLppF81W2uCdXOuQ2R5vWcDXfI4y8oNyw69bjwcit41Uhq/wC
Xf88ggQ/gUKu39ArwMMfYN3MjpoOR+eyjQiPbn0l7DFV5wvMIDtaPEG15YaSq2Zf
8eaYqlNug3EQqphqfpkjGGrS//iglixMbzQ8ms/FgoFBlS0zm9Op2IGrz+j9ec88
SJXvp+aTNjRyQPixCzqcjfmnXICCZqsw6iWdMgqcDqKMiOsUcAPfCUQH9sGYbPDi
oK56NU/tr4wAIvCjU0Zd1Set/oLlgmcuE77VCIiWCb+yZ8JaJ++vIK2Sp0z1ylkn
n7S7K3OaDNOyhGdZkXRNHLUtvQ2G8QNvyILTw2jvqHLHgzaqm97Tw9S6JOs3F3Di
1/WIcxJukC5OvhlLgpNPED0t7oyDiAip7im/8cEFly3evgEsrv/1SDyfHmz0dyNN
rCJI3NlSSXpEfnoroP1t
=KV+r
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Apr_2012_10_37_19_+1000_9CHuYFvz76nZOYK6--
