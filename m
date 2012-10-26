Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab2JZOeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:34:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:42922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933313Ab2JZOeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:34:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="asc'?scan'208";a="238796036"
Date: Fri, 26 Oct 2012 17:34:54 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org, Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] numa, mm: drop redundant check in
 do_huge_pmd_numa_page()
Message-ID: <20121026143454.GA10898@otc-wbsnb-06>
References: <1351256077-1594-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1351256885.16863.62.camel@twins>
 <20121026134129.GA31306@otc-wbsnb-06>
 <1351258992.16863.77.camel@twins>
 <20121026135750.GA16598@otc-wbsnb-06>
 <1351260464.16863.80.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <1351260464.16863.80.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 26, 2012 at 04:07:44PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-10-26 at 16:57 +0300, Kirill A. Shutemov wrote:
> > > > Yes, this code will catch it:
> > > >=20
> > > >     /* if an huge pmd materialized from under us just retry later */
> > > >     if (unlikely(pmd_trans_huge(*pmd)))
> > > >             return 0;
> > > >=20
> > > > If the pmd is under splitting it's still a pmd_trans_huge().
> > >=20
> > > OK, so then we simply keep taking the same fault until the split is
> > > complete? Wouldn't it be better to wait for it instead of spin on
> > > faults?
> >=20
> > IIUC, on next fault we will wait split the page in fallow_page().=20
>=20
> What follow_page()?, a regular hardware page-fault will not call
> follow_page() afaict, we do a down_read(), find_vma() and call
> handle_mm_fault() -- with a lot of error and corner case checking in
> between.

Yeah, you're right. Then, it seems we're spinning on the fault until the
page is splitted.

I'm not sure how long spliting takes and if splitting itself can fix some
fault reason.

--=20
 Kirill A. Shutemov

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQip+OAAoJEAd+omnVudOMppYP/RlkBQIfIz8WnB67L+ZpdScQ
ki2oWRraf3VkmcSfomfvL6Gyv5iraWWqbsDIARBA+v5iXjiKuzQArLzVkQPYnVMK
C3kh4b6jTrueAK+lcnT8c/bvd/VnGj5AHcm0QNx1VEByCjeZYEHhKCzVHzbDBQZn
pzDPXaNtD1Y7tIGd/8HtM+Znq5ifogLzlJecef1eGNxGs/0apay2npFhW6UzYEPG
u/Y4LjoaecBPc3ydh/UGlTWXaiD241a00TZfovFj/CywUAcRrD0EQSyfW2/t134v
dGCbK9tqXPa3P/NCa5WquS4Ayod9iS89cn7QZdF+hDIHz3Bxih5mQDP0yED0mFE2
aOVp/ZOu+cK9sCu3VDFL8N+dSBp6yBryNFjoji2cdbIrFu9twMNZL/BLSykytXvm
SPiYj3JAkRipVb7hiSnyvbLhW1plVKqm3G5P+zuGDokHG8fEaTtu1HUQrUgQ8d58
bu5zDgBm2/0LuKhkdR1g3aHqHo/OlH3Oru48NpzMQmjKxRfMGOoNu+6qvGaSyvY4
qXknj36Ss4R7SQgTQdZRslNcAqvE5n48Jk9zHRQEvgafEfEDc+LooA95xVka9jDF
4YjaARQkFV5AIEfBnVQKt7TnyasaKm5ruwyGHMukCGgq7ez6Cln7cyFbW6JKhy/g
LlyIM5I1n6HR40aNSJr3
=5aLN
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
