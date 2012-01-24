Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2AXLK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:10:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:13373 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab2AXLKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:10:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="110191282"
Date: Tue, 24 Jan 2012 05:10:14 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: disable -Wmissing-field-initializers for W=1
Message-ID: <20120124031014.GA12570@otc-wbsnb-06>
References: <1327290850-5405-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20120123211834.GA3981@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20120123211834.GA3981@sepie.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 23, 2012 at 10:18:34PM +0100, Michal Marek wrote:
> On Mon, Jan 23, 2012 at 05:54:10AM +0200, Kirill A. Shutemov wrote:
> > -Wmissing-field-initializers is too noisy to be useful on W=3D1. Let's
> > move it to W=3D2.
> >=20
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  scripts/Makefile.build |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > index d2b366c..1535a2f 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -62,7 +62,7 @@ endif
> >  ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
> >  warning-  :=3D $(empty)
> > =20
> > -warning-1 :=3D -Wextra -Wunused -Wno-unused-parameter
> > +warning-1 :=3D -Wextra -Wunused -Wno-unused-parameter -Wno-missing-fie=
ld-initializers
>=20
> I would use $(call cc-disable-warning, missing-field-initializers), so
> that W=3D1 has a chance of working with gcc 3.x.

Something like this?

---

=46rom 9ee1c7006d14efddcb7cd52053b97aa39edf6ec3 Mon Sep 17 00:00:00 2001
=46rom: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Mon, 23 Jan 2012 04:59:28 +0200
Subject: [PATCH] kbuild: disable -Wmissing-field-initializers for W=3D1

-Wmissing-field-initializers is too noisy to be useful on W=3D1. Let's
move it to W=3D2.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 scripts/Makefile.build |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d2b366c..ff1720d 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -69,6 +69,7 @@ warning-1 +=3D -Wmissing-prototypes
 warning-1 +=3D -Wold-style-definition
 warning-1 +=3D $(call cc-option, -Wmissing-include-dirs)
 warning-1 +=3D $(call cc-option, -Wunused-but-set-variable)
+warning-1 +=3D $(call cc-disable-warning, missing-field-initializers)
=20
 warning-2 :=3D -Waggregate-return
 warning-2 +=3D -Wcast-align
@@ -76,6 +77,7 @@ warning-2 +=3D -Wdisabled-optimization
 warning-2 +=3D -Wnested-externs
 warning-2 +=3D -Wshadow
 warning-2 +=3D $(call cc-option, -Wlogical-op)
+warning-2 +=3D $(call cc-option, -Wmissing-field-initializers)
=20
 warning-3 :=3D -Wbad-function-cast
 warning-3 +=3D -Wcast-qual
--=20
1.7.8.3


--=20
 Kirill A. Shutemov

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPHiEWAAoJEAd+omnVudOMYUcP/2epf+3BL0V7ruoaNVjt/lPp
LbRfPSxZvUimjhbmd1ShbkDz3KYWtM1fMFkk8ExKjIjpVwx5M9TEWEAmINZf0e6Q
pP0FKtQwfCyLS1K41WA5WEVJfScdJVoY5UQqZkluHvTYu2M6ktsVoCza/OPpHEvh
V2fIjJl+RL0Tclrl36VMwaQzej3HBhWXsKJiewi/Yazc/9pd5ruF/XRanzBMXYmI
9KTlm2NqBTeMwB11lWKpc6npxU3GTr3HxfK2eesaI6W5z2QysLeuvZAYFAikSbag
9KfvPrrPGCrHXmTR1plWvGNMGG5SpEx06+l6XSacNnolPgRw/AmAyPnHVhSwpx20
7RIkT4dlLcBhv8eUjMN7pSXyslvwJP3X/o2Xp+bbk+mkPHGzEPqQvyI667Vju68/
euOqLeqKN+fs6ZHda/5PDQdRIPJ3bbmSQcKgPSH0x0z75EqIi4JikHCuXkLXeHqn
wOEb0cWvcLirhALPLuz0ZT80ZcPAz0guu6qgwW10yCI0rHuc3l+a4nYg5TjWPCog
RamWQFN7CyjF17FW0z8itIk75vDHv5MtNsgDfmdLQhzyVK5EodC/9aDQXf26BAoh
djHKMr+vhK2IdIw/+mOJIYTgPC125mQMx8pu77pfqNH9mc2Wbg/5MmRuCV4GdBzb
0jiuUn1f8eXqh/J0szBM
=aAZg
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
