Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab0LMRAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:00:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61547 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab0LMRAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:00:21 -0500
Date: Mon, 13 Dec 2010 10:00:12 -0700
From: Eric B Munson <emunson@mgebm.net>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] mm: kswapd: Keep kswapd awake for high-order
 allocations until a percentage of the node is balanced
Message-ID: <20101213170012.GB3401@mgebm.net>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
 <1291893500-12342-3-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <1291893500-12342-3-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 09 Dec 2010, Mel Gorman wrote:

> When reclaiming for high-orders, kswapd is responsible for balancing a
> node but it should not reclaim excessively. It avoids excessive reclaim by
> considering if any zone in a node is balanced then the node is balanced. =
In
> the cases where there are imbalanced zone sizes (e.g. ZONE_DMA with both
> ZONE_DMA32 and ZONE_NORMAL), kswapd can go to sleep prematurely as just
> one small zone was balanced.
>=20
> This alters the sleep logic of kswapd slightly. It counts the number of p=
ages
> that make up the balanced zones. If the total number of balanced pages is
> more than a quarter of the zone, kswapd will go back to sleep. This should
> keep a node balanced without reclaiming an excessive number of pages.
>=20
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

With Minchan's requests this looks good to me.

Reviewed-by: Eric B Munson <emunson@mgebm.net>

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBlEcAAoJEH65iIruGRnNLgwH/2gIp6ds9wOkMCEyyhUIgFr1
V379Z0ggBaLzz6/JfJAzzVG6PvyZ3rwJPti7JElgKl6fPf1AMt0kYfn7L7v1wBbg
YP93xWLv6LCXJbx/KLN+7wvjKvILvM57K6Q5wmSqLD/SG5uHnsnYZFurf4GHi3XQ
Tww94tBE37s068+BWHvpU+dDxmAp1wi/GFh6yR3WD0cl2v0FaJV2e+DNSH1/Sxcl
jwVm0kHA+A2rRBroO0ewNl8rVk0Ka0mQqSfLWBkJNbDG94oPX7a5AYq7bM90BCbF
4+ThnHxp1cfuKezU5rE6j6xPHXOgshRBasWe2jqWAfUl4CKIFPSnHrilA/Qf7po=
=WGaR
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
