Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab2INAO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 20:14:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51212 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2INAOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 20:14:25 -0400
Date: Fri, 14 Sep 2012 10:14:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] add "enable" to the kconfig language
Message-Id: <20120914101414.1e24b28d2cfa8fc030952a58@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Sep_2012_10_14_14_+1000_L/+9UnCGuj90tlHI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Sep_2012_10_14_14_+1000_L/+9UnCGuj90tlHI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have noticed that we use the following paradigm quite a bit theses days:

config <something
	select HAVE_<config1>

config <config1>
	depends on HAVE_<config1>

or similar

I was wondering if it would make sense to replace this with:

config <something
	enable <config1>

config <config1>
	depends on enabled

The advantage of this is that we would not have all the HAVE_ config
names in our .config files and the generated include files.  Of course,
if config1 does not depend on "enabled", then the "enable <config1>"
would have no effect (we may want to warn about this).

Comments?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__14_Sep_2012_10_14_14_+1000_L/+9UnCGuj90tlHI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUnbWAAoJEECxmPOUX5FEsMEQAKOjYet7E4aCMzY2pDSPftQx
hfKPrDIZRakarnZ4fGs8n0rLv9hdcY7BmYUNDZiKvMzHGbCOpVibi4eeeAGo8H71
8TDH3or5J/gpPwqDJ/ICsH39V1hyRoi071mzFSOmt4qyTxocbkrk9xo/SO+jnKsV
1e2es8cR5JsNEZUJ1ZjfkhI3j+mBa3JAH+3e6NpXuJ9NlNQ5ni3Vpu6Lutsb23PN
cmiHu7ziURfVERJ23crMb0xzO+0R/2PeUYa/C5nARkL8L+rHCilupNYQPoGjv4tO
yj4/U9yqUQ91OMjHchHjUue1Z3DteCjRZP9uyEOL0mYsrwVUDVBC9NZUyTKjgiLA
309nVa0XSHprT8jXggyt1e8x67vL/D/KMCJP4B5dDvb19+URM1cUu368PatvObw3
sxxSrvadkqtpKxrbPufB0qa2UhBYld/Kmf0qaTmL0yB1+tOgT54oZLZOJj0Yu/rm
N7r63016jK50VWphlRp4kZ88i1sQBcejXWtkfPCLJxCoec9nSk3bcwTiMu4PLVp+
FIh8FWaPD+SrZwVXScehDgKE/u73/UNRbWMYxEGim9gslVPwzSiDOJfyh7MK4J30
d8ir0Sjxk6EEzpU9cYU83ML2XL+n05UdMxELJJlMFX+Yo0UOHrAsS+V3q0hfGiip
jjinqmnH3d255gniNvBu
=zslX
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Sep_2012_10_14_14_+1000_L/+9UnCGuj90tlHI--
