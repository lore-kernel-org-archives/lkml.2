Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992672Ab2KOGZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 01:25:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59769 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab2KOGZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 01:25:45 -0500
Date: Thu, 15 Nov 2012 17:25:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the akpm-current tree with the  tree
Message-Id: <20121115172535.45e27b63355827f9451c4b4b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Nov_2012_17_25_35_+1100_ppMMdqb+S4YJHlNM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Nov_2012_17_25_35_+1100_ppMMdqb+S4YJHlNM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
mm/memcontrol.c between commit 2ef37d3fe474 ("memcg: Simplify
mem_cgroup_force_empty_list error handling") from the cgroup tree and
commit 4bfe8322f427 ("memcg: fix hotplugged memory zone oops") from the
akpm-current tree.

I fixed it up (as suggested by Andrew - see below) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/memcontrol.c
index 08adaaa,dd39ba0..0000000
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@@ -3673,32 -3712,30 +3706,32 @@@ unsigned long mem_cgroup_soft_limit_rec
  	return nr_reclaimed;
  }
 =20
 -/*
 +/**
 + * mem_cgroup_force_empty_list - clears LRU of a group
 + * @memcg: group to clear
 + * @node: NUMA node
 + * @zid: zone id
 + * @lru: lru to to clear
 + *
   * Traverse a specified page_cgroup list and try to drop them all.  This =
doesn't
 - * reclaim the pages page themselves - it just removes the page_cgroups.
 - * Returns true if some page_cgroups were not freed, indicating that the =
caller
 - * must retry this operation.
 + * reclaim the pages page themselves - pages are moved to the parent (or =
root)
 + * group.
   */
 -static bool mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
 +static void mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
  				int node, int zid, enum lru_list lru)
  {
- 	struct mem_cgroup_per_zone *mz;
+ 	struct lruvec *lruvec;
 -	unsigned long flags, loop;
 +	unsigned long flags;
  	struct list_head *list;
  	struct page *busy;
  	struct zone *zone;
 =20
  	zone =3D &NODE_DATA(node)->node_zones[zid];
- 	mz =3D mem_cgroup_zoneinfo(memcg, node, zid);
- 	list =3D &mz->lruvec.lists[lru];
+ 	lruvec =3D mem_cgroup_zone_lruvec(zone, memcg);
+ 	list =3D &lruvec->lists[lru];
 =20
 -	loop =3D mem_cgroup_get_lru_size(lruvec, lru);
 -	/* give some margin against EBUSY etc...*/
 -	loop +=3D 256;
  	busy =3D NULL;
 -	while (loop--) {
 +	do {
  		struct page_cgroup *pc;
  		struct page *page;
 =20

--Signature=_Thu__15_Nov_2012_17_25_35_+1100_ppMMdqb+S4YJHlNM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQpIrfAAoJEECxmPOUX5FETOkP/3PbiFMvtWym8v3Mtou/WHl9
LsxgDFixS7DRgprheGYYjt02B/zWctfFlKlFMrJ4w547IMs87ojWj/9Ye+UVWLaF
teaCP6pr1Shpni+IiWV+ljcnIOezcGFO7lSIK/bOIL6Ty/lXqmNLPosPdFqFfskE
Lx7jC8zlwmdS0lOBZGyw4CqESkIvA3lw20VVHbI/XaI9nxYVoT5Q3P9/SLGBHNu2
givgMiv7mZjB3TBaNYrcZcmr7BqOhgcBDYwzSSZNJpb9c/ZEZpX2+Hv28+ZJuH9K
GN+qdQEzr2up3iPu/VF+mV6nxkIgqlKQFYLcqdf0qAFSen9beyxYcbsD1AqbHRxF
tj/aN8uZRqjs9TeAASaNLRw1SxbGgUeezUjyPEZomMZgEmoi2dorDirWQUNDBb5b
ca0+/kYvVoa3+02ISuPezUklZ2YFPLol5fAsbEmhQ3W0thYXi4488KhxA+8zw0XH
keB5cNL74TvcWus4gOTimBiVl868kCLSgClMwpZVjqTS8ck855dXzUfOgWd1InB/
o0cSD/cZoQJrlg7yvuNTqiMbcfUZV0oxwmmJvTNSwufooBX05eCq2233I6K093FD
69/SzHdlnFNuP+wqmykeOHKl6eoTsRTflaz+iPxQbB/YOJggKbbuFgxlBkSd0geU
xIXTFLSSkF/5TJ1alXkg
=zU2x
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Nov_2012_17_25_35_+1100_ppMMdqb+S4YJHlNM--
