Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751145Ab2F2EgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 00:36:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43618 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2F2EgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 00:36:18 -0400
Date: Fri, 29 Jun 2012 14:36:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwp@linux.vnet.ibm.com>, Hugh Dickins <hughd@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the trivial tree with Linus' tree
Message-Id: <20120629143607.5f1e97318ddfe6f027bfcc5b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Jun_2012_14_36_07_+1000_lJ1uJFQwEfM_Xj2C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jun_2012_14_36_07_+1000_lJ1uJFQwEfM_Xj2C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
include/linux/mmzone.h between commit 89abfab133ef ("mm/memcg: move
reclaim_stat into lruvec") from Linus' tree and commit 46028e6d10cb ("mm:
cleanup on the comments of zone_reclaim_stat") from the trivial tree.

The former moved the code that was updated by the latter.  I applied the
latter to the new position (see below).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mmzone.h
index 2427706,5463177..0000000
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@@ -185,25 -185,8 +185,25 @@@ static inline int is_unevictable_lru(en
  	return (lru =3D=3D LRU_UNEVICTABLE);
  }
 =20
 +struct zone_reclaim_stat {
 +	/*
 +	 * The pageout code in vmscan.c keeps track of how many of the
- 	 * mem/swap backed and file backed pages are refeferenced.
++	 * mem/swap backed and file backed pages are referenced.
 +	 * The higher the rotated/scanned ratio, the more valuable
 +	 * that cache is.
 +	 *
 +	 * The anon LRU stats live in [0], file LRU stats in [1]
 +	 */
 +	unsigned long		recent_rotated[2];
 +	unsigned long		recent_scanned[2];
 +};
 +
  struct lruvec {
  	struct list_head lists[NR_LRU_LISTS];
 +	struct zone_reclaim_stat reclaim_stat;
 +#ifdef CONFIG_CGROUP_MEM_RES_CTLR
 +	struct zone *zone;
 +#endif
  };
 =20
  /* Mask used at gathering information at once (see memcontrol.c) */

--Signature=_Fri__29_Jun_2012_14_36_07_+1000_lJ1uJFQwEfM_Xj2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP7TC3AAoJEECxmPOUX5FExVYP/A/vFj/fYKD2hDbHka5Oe0zp
0VQ7ZTl+cXTPDuJX55icRwuC18mR8geh0JIWyQbmapAsAY2Wriv9F7oDRMTZxO5u
vZ1yWoIQxMfL8Gw8cx8PMhVRmr69BRFoKGB3wR14B4wgsu6g73zL8o3/c0vqzrdY
p4ED2M0A2VnN+Pe7yNJUg37xemiVqGeIFpCmJNLJur1QmNsu48IN+fj7HGiD1Fu6
ljrWsyQZVNBF+dmrZCPtEMIPraaUBK0anFTwFKsmuKmBlXSTV71OQmnDb/B7+8De
4oGC4DLsGKSwnIYcE+t7r6jNbgfz9IURbKzYW123yt96md8pc/QTcHQ/e4KfMDeF
RbJeVyD2C9OFOsuhf/vYoUpwn/lc+AmmDToWfr+frZ1Xw5ilR/RtOqRDdKl2pNKJ
r9XD9tqngdqrwr0GMXUUEv0x9yZdDP+U44MBiESyM3aagidTUb/iIwYDoz9vKqZk
kBwf1Daps15oRU2xPK+9OHv4F4ZFpk8hQtb7FK5Y758QVK27LNgss/c1BYkq3dL/
VBMsBPHd/PXoCV+6BW2fDuhXGRza2BA2O5drz4dIEZCQeNQABJ7sFY0czxwwmsL6
h+9IZexNVUT5Cdv2HqZn8Y46mFvDHvz9TJ88v+TNySkpq9IPOqQ1a0G+O4AGqLC3
3Xu25h+ABQttEIc8EETy
=+NmA
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jun_2012_14_36_07_+1000_lJ1uJFQwEfM_Xj2C--
