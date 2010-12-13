Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab0LMTyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:54:12 -0500
Received: from mail-pz0-f66.google.com ([209.85.210.66]:48507 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab0LMTyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:54:10 -0500
Date: Mon, 13 Dec 2010 12:38:18 -0700
From: Eric B Munson <emunson@mgebm.net>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] mm: kswapd: Use the order that kswapd was
 reclaiming at for sleeping_prematurely()
Message-ID: <20101213193818.GE3401@mgebm.net>
References: <1291995985-5913-1-git-send-email-mel@csn.ul.ie>
 <1291995985-5913-4-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ns7jmDPpOpCD+GE/"
Content-Disposition: inline
In-Reply-To: <1291995985-5913-4-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ns7jmDPpOpCD+GE/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Dec 2010, Mel Gorman wrote:

> Before kswapd goes to sleep, it uses sleeping_prematurely() to check if
> there was a race pushing a zone below its watermark. If the race happened,
> it stays awake. However, balance_pgdat() can decide to reclaim at order-0
> if it decides that high-order reclaim is not working as expected. This
> information is not passed back to sleeping_prematurely().  The impact is
> that kswapd remains awake reclaiming pages long after it should have gone
> to sleep. This patch passes the adjusted order to sleeping_prematurely and
> uses the same logic as balance_pgdat to decide if it's ok to go to sleep.
>=20
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Reviewed-by: Eric B Munson <emunson@mgebm.net>

--Ns7jmDPpOpCD+GE/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBnYqAAoJEH65iIruGRnNDvgIAKt6gxTnJrGvkVEjA9EtUBKR
m+hOcsCQlzxCz4KSCgxOutFx9NsqO7eFmhCeSFeul77DQlfi/a8lD2jWYtDynmZn
aR39vSQwYhQFb1sFdWTaerNpkbcmqwIYGFTG7/0F9EguDrnGSiP2tKx+ujHlfUC9
b3mKY57WwtG8tRqheIXOs+qplzeVwe5LEvHslArfX4g61P3JT1uXPabeuZiFhTyz
V/lAATt+Qc+WVHhh6HfFG9sP8FnL36TAsnU3NStyIP3wM0b0kNV0O+p3oyKpTrWU
uLOHK0UDGKrFXr1iTYCgwDWsf5NQ3nP1485EAi6RdETovfvOFyLFzWI1M/lnPik=
=w/zD
-----END PGP SIGNATURE-----

--Ns7jmDPpOpCD+GE/--
