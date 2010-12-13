Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0LMTeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:34:20 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49398 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab0LMTeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:34:18 -0500
Date: Mon, 13 Dec 2010 12:34:08 -0700
From: Eric B Munson <emunson@mgebm.net>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] mm: kswapd: Stop high-order balancing when any
 suitable zone is balanced
Message-ID: <20101213193408.GC3401@mgebm.net>
References: <1291995985-5913-1-git-send-email-mel@csn.ul.ie>
 <1291995985-5913-2-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/e2eDi0V/xtL+Mc8"
Content-Disposition: inline
In-Reply-To: <1291995985-5913-2-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Dec 2010, Mel Gorman wrote:

> When the allocator enters its slow path, kswapd is woken up to balance the
> node. It continues working until all zones within the node are balanced. =
For
> order-0 allocations, this makes perfect sense but for higher orders it can
> have unintended side-effects. If the zone sizes are imbalanced, kswapd may
> reclaim heavily within a smaller zone discarding an excessive number of
> pages. The user-visible behaviour is that kswapd is awake and reclaiming
> even though plenty of pages are free from a suitable zone.
>=20
> This patch alters the "balance" logic for high-order reclaim allowing ksw=
apd
> to stop if any suitable zone becomes balanced to reduce the number of pag=
es
> it reclaims from other zones. kswapd still tries to ensure that order-0
> watermarks for all zones are met before sleeping.
>=20
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Started reviewing before I saw this series.

Reviewed-by: Eric B Munson <emunson@mgebm.net>

--/e2eDi0V/xtL+Mc8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBnUwAAoJEH65iIruGRnNYksH/0Q6qqkuy5cHyFc5tXrSAcuZ
mBmDyjuxATuedCeuMtBoNhjTTAomuPp6RqJzeqFPptWSzaDMMcXlkh8ToNJPuniH
B7lIYHPe1qLP5YCRQ1OAl+U8u+EBFg6h5GgxKGSzJXgAE/sNNkZpysnL6spcOHXk
0CXS4dGiGNZVef4zBIkB+/cQ4pgj46okdNGGDbAfkAXah9Le8+3oL5zNSLoEhK6J
s6PxkDoycJcH61fKQC6P9cZZ8EPZk+rJFrKEQ4nDjdBwfZCLI3EQ2t9Njr1bmJtt
e9n6H3DCj+vOuz1QNyrjlwPL9N6D7yhyHKdZWCrEsCT0PIqLaysQTZVmh+PPPwI=
=W6G+
-----END PGP SIGNATURE-----

--/e2eDi0V/xtL+Mc8--
