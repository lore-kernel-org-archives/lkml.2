Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab2LCIOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 03:14:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:45034 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab2LCIOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 03:14:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,205,1355126400"; 
   d="asc'?scan'208";a="250929747"
Date: Mon, 3 Dec 2012 10:15:04 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/2] thp: fix anononymous page accounting in fallback
 path for COW of HZP
Message-ID: <20121203081504.GA12070@otc-wbsnb-06>
References: <50B52E17.8020205@suse.cz>
 <1354287821-5925-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1354287821-5925-2-git-send-email-kirill.shutemov@linux.intel.com>
 <CAA_GA1ds_=50SrqvxsGrtM9UPg5w=2e5xpi5CrLbKmE4M6X0gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <CAA_GA1ds_=50SrqvxsGrtM9UPg5w=2e5xpi5CrLbKmE4M6X0gw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 03, 2012 at 11:14:38AM +0800, Bob Liu wrote:
> On Fri, Nov 30, 2012 at 11:03 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >
> > Don't forget to account newly allocated page in fallback path for
> > copy-on-write of huge zero page.
> >
>=20
> What about fallback path in do_huge_pmd_wp_page_fallback()?
> I think we should also account newly allocated page in it.

No. Normal huge pages has already accounted on fork(). See
copy_huge_pmd().

Huge zero page (as 4k zero page) doesn't contribute to RSS, so we need to
account the page which replaces huge zero page on COW.
--=20
 Kirill A. Shutemov

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQvF+IAAoJEAd+omnVudOM5c0P/2KnH2ESWBaxS22I1Vw8duyq
waWNt1kE5tV8kN0k9iqIXK+8nwwW81iEnOkMhmSF7edyPcV340OuIgwYS03x64FF
sN9dUfKBLYfazPCkg/ucU+keO0m0HxZ6yL+jvNdH/aGEBqqRyL8cvWMIrtYH/keN
8P3GZ4SR4uKatFKyIGAc37GZTLRJN+0FpfzKd2xjx6Szjri7bVYHCQjfRLehJuHT
DKWmReMvDvsIMSsE+EHl4nHRWsd2JhtXiWjVmWEXDozXvea5Vh3LhYNdfkusiVKh
yodcs3H7E5o1nCTUAWRbJl2JjpAo302i4Bw3xyj1aQHzxiOhXwZlbXEN6eAQnmtk
xGufRrJSrYTI5LX3ZS/7H5UAGi4yzfvVDN8BG0iy8V75crRFKZi6iZzzjrqgjvoz
DBKUUvCQtIKktAXy2JqB0etbnB31hL0gHSETDwnzA/WEOwUyrcCSJAs0tlReY9g0
6MDw3A8OSL9Dt6N50/k/IlImonE3FbzgUrFYK/8VIG5nXoM3cnUyulhuPJGrAIWS
vEZ3ERGhSunrfOKj0WZFxmL+nRuMhWwCEeIbunDcoLqTiiwe8/HuYnqZXzOMC5LK
YzNye1LCMjRwGqd6lOo5pEY31iG8MvoCroCvf+eaSdyOgmwvE0CFaTKyg8ZpB/Lp
ddxbLJV9s8yu5GIZ+zP2
=d9cz
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
