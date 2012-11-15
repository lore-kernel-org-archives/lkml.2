Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423667Ab2KOJlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:41:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:42573 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423608Ab2KOJlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:41:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,255,1352102400"; 
   d="asc'?scan'208";a="249453957"
Date: Thu, 15 Nov 2012 11:41:55 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 09/11] thp: lazy huge zero page allocation
Message-ID: <20121115094155.GG9676@otc-wbsnb-06>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1352300463-12627-10-git-send-email-kirill.shutemov@linux.intel.com>
 <alpine.DEB.2.00.1211141535190.22537@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RDS4xtyBfx+7DiaI"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211141535190.22537@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RDS4xtyBfx+7DiaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 03:37:09PM -0800, David Rientjes wrote:
> On Wed, 7 Nov 2012, Kirill A. Shutemov wrote:
>=20
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >=20
> > Instead of allocating huge zero page on hugepage_init() we can postpone=
 it
> > until first huge zero page map. It saves memory if THP is not in use.
> >=20
>=20
> Is it worth the branch on every non-write pagefault after that?  The=20
> unlikely() is not going to help on x86.  If thp is enabled in your=20
> .config (which isn't the default), then I think it's better to just=20
> allocate the zero huge page once and avoid any branches after that to=20
> lazily allocate it.  (Or do it only when thp is set to "madvise" or=20
> "always" if booting with transparent_hugepage=3Dnever.)

I can rewrite the check to static_key if you want. Would it be better?

--=20
 Kirill A. Shutemov

--RDS4xtyBfx+7DiaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpLjjAAoJEAd+omnVudOMDt4P/iaIJ3VfrEL1qTLYio2ZpsAr
JDKTYckl6UBYyMj3UD671njiSE/iRed9gKvd0g3OaGdGnIrNgeQ9hubniv1eJZQ7
QtIbQVeRql1TYwpXYHB30JLMvnE3CboFVhc1/JqiK5Hrj6qsm3yfshvCl+IPrFL5
NSe4Pipj7L2k75ev2kO4FhmrsVSnF7VhEPsuv/VH2sSyJqtp9JxzZQhcDKw8PxI+
BnwNSLRzV3sL+9efk7NWn6tMQ9Y+5LHUPM0Hwqq5UlThoyZv6ySh350QElsZLf4o
wp7XLd6Ghexe3I38ezHS0wZCApO0xb2h40gCxFN1oiL0Cku23UxSQxindxA+TmZu
vSlEfKSoaH8IPs0bmu+lp3t6k2xGPbpeh66Cv04W9712OAJTRW+aOTjakGF1iZYz
S0kkpV67cLG9gyyYaO3TsqVYxw4JhiTSpMzk/cpFZVg46/VPOfJMOsZB8YPnlxAK
oK3Z9FDiNarQ6qgNTu54ylAb6if9y//bTV1OxgOhOPoKKzONS4S9pm2Lkb9a1Ko7
ok122tx+xrgaLY3HBelNPSgDn3ZfzkBGOFpfmq8dGW2gFTgIGZo3cmqHu6w3za4c
/4Zmd4lE9O00ZKPCexL7Qmnc+2hpGKIE445hFplcfkN/BLKgc13FMq373Y9stYNr
9eFoBXhYZAgVaeGEJbsZ
=2NIk
-----END PGP SIGNATURE-----

--RDS4xtyBfx+7DiaI--
