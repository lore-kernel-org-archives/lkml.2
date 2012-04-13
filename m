Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab2DMPLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:11:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:5024 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2DMPLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:11:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="141360180"
Message-ID: <1334330040.2544.79.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V2] jffs2: Fix lock acquisition order bug in gc path
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Josh Cartwright <joshc@linux.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 13 Apr 2012 18:14:00 +0300
In-Reply-To: <20120329233453.GA23698@joshcartwright.net>
References: <20120329233453.GA23698@joshcartwright.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Xp1EoIUnUiBY2+1hfeuD"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Xp1EoIUnUiBY2+1hfeuD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-29 at 19:34 -0400, Josh Cartwright wrote:
> The locking policy is such that the erase_complete_block spinlock is
> nested within the alloc_sem mutex.  This fixes a case in which the
> acquisition order was erroneously reversed.  This issue was caught by
> the following lockdep splat:

I've added the follwing:

This was introduce in '81cfc9f jffs2: Fix serious write stall due to
erase'.
   =20
Cc: stable@kernel.org [2.6.37+]

and pushed to l2-mtd.git, thanks! CC-in Joakim to let him know that his
patch has a bug and that he might want this fix in his system(s) as
well.

--=20
Best Regards,
Artem Bityutskiy

--=-Xp1EoIUnUiBY2+1hfeuD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPiEK4AAoJECmIfjd9wqK05zUP/1iA2yfnpUynoubnUDQz0n22
Zzy7y0giMeRyKAIGR/IRgafqTEojB4/aRXzrjx7pgP5mjw+rQ72QwBbsnhRx5+nW
EJurYdwBbUjVcf6DeLGf9EPJfpz5E+bLx+yyl4m3Fvo/PQnSf+JCaJ1O5a3GJC0G
jf9K3g5NcanYONcNA3tc8QJI6Rs/Q/6Us7CRPwKcDnOmE5EE5SMSNjTOD/n1nyEe
TXbAGbnWNlHCg1CUrJ+ExrPTcTrsDXHs46+eZMFKcHwKb13w0Am7KkoKTEXD7bEB
5JkBHBW4BCeqFYPsTc9o0zm1MryGfFaENd2Uk6sg588A8qcWvNHctKvO6JlFLxGs
CBi6Gf5QSu+wxsNtURd6bzwBcl6V7FlkO0dy3UFw0Bls8nkgj4Z3I7SF52CU1pAi
BZe5DA28JqUBePR2m92L5wcTrJJ2NCd4xli+CIF7pRnyxwDGa1bHsFHp4T79IDar
Fw8tnZoDUeg0RzMPFdQc8BtSo9bkilAgT4ZO20you5WCyBRoY54R7QI70GNgoPnx
2RWm5MkG5FuGwvRGIWsyPProi9bqK0FnLvBggXSbPscPrgaZZ0Ev7zm70fJnE9vx
6qeTnKjxfK6nivC6ACb1X0sxH1fPs0lHozl/dSzi9hipU3v0Bj+JOohrjvzoO10n
G/O5yjEYfVIU+Hgp79Rv
=Tp4R
-----END PGP SIGNATURE-----

--=-Xp1EoIUnUiBY2+1hfeuD--

