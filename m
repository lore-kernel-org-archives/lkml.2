Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab1BWPak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:30:40 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64979 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1BWPai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:30:38 -0500
Date: Wed, 23 Feb 2011 10:30:30 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, akpm@osdl.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/5] pagewalk: only split huge pages when necessary
Message-ID: <20110223153030.GA2810@mgebm.net>
References: <20110222015338.309727CA@kernel>
 <20110222015339.0C9A2212@kernel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20110222015339.0C9A2212@kernel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Feb 2011, Dave Hansen wrote:

>=20
> v2 - rework if() block, and remove  now redundant split_huge_page()
>=20
> Right now, if a mm_walk has either ->pte_entry or ->pmd_entry
> set, it will unconditionally split any transparent huge pages
> it runs in to.  In practice, that means that anyone doing a
>=20
> 	cat /proc/$pid/smaps
>=20
> will unconditionally break down every huge page in the process
> and depend on khugepaged to re-collapse it later.  This is
> fairly suboptimal.
>=20
> This patch changes that behavior.  It teaches each ->pmd_entry
> handler (there are five) that they must break down the THPs
> themselves.  Also, the _generic_ code will never break down
> a THP unless a ->pte_entry handler is actually set.
>=20
> This means that the ->pmd_entry handlers can now choose to
> deal with THPs without breaking them down.
>=20
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

I have been running this set for serveral hours now and viewing
various smaps files is not causing wild shifts in my AnonHugePages:
counter.

Reviewed-and-tested-by: Eric B Munson <emunson@mgebm.net>

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNZSgWAAoJEH65iIruGRnNCcsH/2dNeUbCWtqFwt4w9xYj/SOH
JcdRS8AMG826/O/8Alp7k2HktNyb50cSB2JgUJuM4xjhR8sskQnEkX6SDrubREhD
vuLEYGGqhmVA2hcRj1ao+bkJnegzzq1xpcAXJuptjgkv/+KrM+cMNGJd0RXaMHYw
spNMkDSzmIZYnBHMl+MAOnErvhVZYaumAxLJRs1TWBfUNm86FA97zlYi7A1gSRfR
1aximEpHTlI8oky099vQnLeO3CgwbJTco0QhwJkU7qNcZyE9gx6UDqLeUlKbuvRb
Uw7UwGnAxgImDbX3NGBduk25eSCsJ2CX8EV7SH2cLuacs9hokxxnSiR5+3jTlOQ=
=ePjJ
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
