Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2HaOGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 10:06:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:50203 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab2HaOGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 10:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,347,1344236400"; 
   d="asc'?scan'208";a="187385414"
Date: Fri, 31 Aug 2012 17:06:27 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH, RFC 7/9] thp: implement splitting pmd for huge zero page
Message-ID: <20120831140627.GA29891@otc-wbsnb-06>
References: <1344503300-9507-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1344503300-9507-8-git-send-email-kirill.shutemov@linux.intel.com>
 <20120816192738.GO11188@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20120816192738.GO11188@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 16, 2012 at 09:27:38PM +0200, Andrea Arcangeli wrote:
> On Thu, Aug 09, 2012 at 12:08:18PM +0300, Kirill A. Shutemov wrote:
> > +	if (is_huge_zero_pmd(*pmd)) {
> > +		__split_huge_zero_page_pmd(mm, pmd, address);
>=20
> This will work fine but it's a bit sad having to add "address" at
> every call, just to run a find_vma().

Hm. address is also used to calculate haddr..

It seems we need pass address anyway. I mean vma + address.

--=20
 Kirill A. Shutemov

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQQMTjAAoJEAd+omnVudOMUnEQAJnGckuJQxNR9+SXTgTGEHj7
Ut9b9Bm4MhUG/LgXcu5TXNasugeisovFxFqAecJfxM32J2qr0DFcxXUA6zr4M1rg
5ogvBFWDCW1ZJVhoFbhs6EClMLsOf9wHqD0sHsGE4mrBMZyxxbDFH5gcUqv6NHpA
pq2Xk7IE4px6DQ1EvZ54gVa/6dz5tp4msUDQqIMHEMIlAIuLQF3Hw1Sdc6J2tWaU
riuJ8A52toHUFO/zpaTSilyBQNFcOtvcKvMY2fj+n/US7cmVJS34U33IUF64nUCO
tboBo+KQj1E4oGloSpmJ0Hr80PuERBOo4sDOD3sGMYjyRVm9+brb4PPVvKX9k7XG
rKvxlAlSx3ZHRkVOeGDQaXUa9ShVfGOG8RKCuNohCBg1gGFbMfqfMnbvP+nDqeL3
qNqrOvarwQrA9vCz9GcH4jFeLxE2BYVn1rEUDI8F4MwyEKQgdMVHkCXFGIuin4MD
VqMD0pZgqeDz2RpvB8FFOGhalBaNc5PSYGkddWjpMSZupqYGZzyMvHaUo7+Cmh9W
kDTfvJ4P47RgMkdn4ZCO53CtsKu3AA3Ixy2Df8utL6Ql+Eh/q5t6XhV/+e7U2hIx
f1KV4z6JL97MOZ4W6LkYUXtdcyGsEzcGLeavLLu0YSrp1VwH7lqTjhKaLvCSh/4D
80OHnxAl/COvW9b3dknI
=YKwD
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
