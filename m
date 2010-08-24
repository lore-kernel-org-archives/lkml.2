Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0HXCHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:07:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33850 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752227Ab0HXCHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:07:30 -0400
Date: Tue, 24 Aug 2010 12:07:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (slab tree
 related)
Message-Id: <20100824120714.8918f8de.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Aug_2010_12_07_14_+1000_uXutboyzVcA0/CPb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Aug_2010_12_07_14_+1000_uXutboyzVcA0/CPb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

mm/slub.c: In function 'alloc_kmem_cache_cpus':
mm/slub.c:2094: error: 'PERCPU_DYNAMIC_EARLY_SIZE' undeclared (first use in=
 this function)
mm/slub.c:2094: error: (Each undeclared identifier is reported only once
mm/slub.c:2094: error: for each function it appears in.)
mm/slub.c:2094: error: bit-field '<anonymous>' width not an integer constant

Caused by commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe ("slub: Remove
static kmem_cache_cpu array for boot"). PERCPU_DYNAMIC_EARLY_SIZE is only
defined for SMP (and only in linux/percpu.h which is not explicitly
included).  This build does not have CONFIG_SMP set.

I have used the version of the slab tree from next-20100823 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Aug_2010_12_07_14_+1000_uXutboyzVcA0/CPb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMcylSAAoJEDMEi1NhKgbs1pEIAIXZs2/YE8p0xKiJXR3QsrEI
nYClG8vmPZVqQf+wBefHIYL404rk7gu6RYVmNSeAARqTMw4yhawmHPQLPGD7q1+E
Rel+qY2WQb5vkt6dX0dhpTtR27P1iv565zpBMv+bb466LFU4R+YKWLDGD8si7TIx
Du8RasxJzP+XplNh90W1R07UF5hyW7BXVvq/vNP4NiIsZNE+oEczeT/e08pYp4Ou
rW5FN+84/VP5um1adat21ky4oxv3vYbDS0+Tmkpuvc8wtmftW+O1cYdDAMeDzg7q
NLunAHzQ3hM831TCwttw0ms/V3yTi78oXPSiMb+dqMFP5/P0ekJD+QTwHKUZJtc=
=xPau
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Aug_2010_12_07_14_+1000_uXutboyzVcA0/CPb--
