Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0LMThb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:37:31 -0500
Received: from mail-pz0-f66.google.com ([209.85.210.66]:58044 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab0LMTha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:37:30 -0500
Date: Mon, 13 Dec 2010 12:37:22 -0700
From: Eric B Munson <emunson@mgebm.net>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] mm: kswapd: Keep kswapd awake for high-order
 allocations until a percentage of the node is balanced
Message-ID: <20101213193722.GD3401@mgebm.net>
References: <1291995985-5913-1-git-send-email-mel@csn.ul.ie>
 <1291995985-5913-3-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+B+y8wtTXqdUj1xM"
Content-Disposition: inline
In-Reply-To: <1291995985-5913-3-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+B+y8wtTXqdUj1xM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Dec 2010, Mel Gorman wrote:

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
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: Eric B Munson <emunson@mgebm.net>

--+B+y8wtTXqdUj1xM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBnXyAAoJEH65iIruGRnNtC0H/2UJny4+pkLGMhHc4ukwJNf7
N0JhCeV5qEfs0nFgcRpgeQEQxDGmYle7M5X/x4yRU3QnNKwuqux4sVEOxuIWLlaE
r99Ek+Ia/waV6tX31LYTsbdakIHuqTpzJwssg6+6TIqqhcEaB9yHlWMzN1itgfCa
2L4W9WDac0Xd4lg/m5MXgSCxH4LiLSXcr9VzRNncESBq6AsDQnueW9oDX7M6Y0+T
Q9PJECL9YI125dsAOAK3rhOS4xQGnlrDSKVwohxAEYI8Ssd+MLrOCJfAnPlbQsQI
+rfHZifHmeyGnGHerXMXcZs24k9jsSoQNP8klvW2FBw5L8pCDKmFRSJqWuvE0jY=
=z+ui
-----END PGP SIGNATURE-----

--+B+y8wtTXqdUj1xM--
