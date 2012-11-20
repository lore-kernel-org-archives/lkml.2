Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab2KTP7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:59:32 -0500
Received: from mga14.intel.com ([143.182.124.37]:35058 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab2KTP7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:59:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,286,1352102400"; 
   d="asc'?scan'208";a="220206654"
Date: Tue, 20 Nov 2012 18:00:40 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v5 05/11] thp: change_huge_pmd(): keep huge zero page
 write-protected
Message-ID: <20121120160040.GA15401@otc-wbsnb-06>
References: <1352300463-12627-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1352300463-12627-6-git-send-email-kirill.shutemov@linux.intel.com>
 <alpine.DEB.2.00.1211141512400.22537@chino.kir.corp.google.com>
 <20121115084635.GC9676@otc-wbsnb-06>
 <alpine.DEB.2.00.1211151344100.27188@chino.kir.corp.google.com>
 <20121116181321.GA18313@otc-wbsnb-06>
 <alpine.DEB.2.00.1211161208120.2788@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211161208120.2788@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 16, 2012 at 12:10:39PM -0800, David Rientjes wrote:
> On Fri, 16 Nov 2012, Kirill A. Shutemov wrote:
>=20
> > > > > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > > > > index d767a7c..05490b3 100644
> > > > > > --- a/mm/huge_memory.c
> > > > > > +++ b/mm/huge_memory.c
> > > > > > @@ -1259,6 +1259,8 @@ int change_huge_pmd(struct vm_area_struct=
 *vma, pmd_t *pmd,
> > > > > >  		pmd_t entry;
> > > > > >  		entry =3D pmdp_get_and_clear(mm, addr, pmd);
> > > > > >  		entry =3D pmd_modify(entry, newprot);
> > > > > > +		if (is_huge_zero_pmd(entry))
> > > > > > +			entry =3D pmd_wrprotect(entry);
> > > > > >  		set_pmd_at(mm, addr, pmd, entry);
> > > > > >  		spin_unlock(&vma->vm_mm->page_table_lock);
> > > > > >  		ret =3D 1;
> > > > >=20
> > > > > Nack, this should be handled in pmd_modify().
> > > >=20
> > > > I disagree. It means we will have to enable hzp per arch. Bad idea.
> > > >=20
> > >=20
> > > pmd_modify() only exists for those architectures with thp support alr=
eady,=20
> > > so you've already implicitly enabled for all the necessary architectu=
res=20
> > > with your patchset.
> >=20
> > Now we have huge zero page fully implemented inside mm/huge_memory.c. P=
ush
> > this logic to pmd_modify() means we expose hzp implementation details to
> > arch code. Looks ugly for me.
> >=20
>=20
> So you are suggesting that anybody who ever does pmd_modify() in the=20
> future is responsible for knowing about the zero page and to protect=20
> against giving it write permission in the calling code??

Looks like we don't need the patch at all.

IIUC, if you ask for PROT_WRITE vm_get_page_prot() will translate it to
_PAGE_COPY or similar and you'll only get the page writable on pagefault.

Could anybody confirm that it's correct?

--=20
 Kirill A. Shutemov

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQq6koAAoJEAd+omnVudOMAEEP/A5QE4q0HHCEfBXTI0f12fpq
l9jlOV9Dw958+Gv4+TE2lu25JNiFZmb5G76W77dIq+wLBWL6VWRB+8PCtyNhKZfK
4bBt8cBYFdt+V09905afAH5D6oKA03DROgxgSexahCkgj+nF/yhHoCyAv5P1c75O
lxCpkmuQjgt9iwtPEisjT3VaU8ez2sukS2gE18L+xHnPzGyoBuORO1XN92suL/81
39hHCs4wcsOkmzqXJ/UBdrafAg/Zs+iZ0VD4obJcdAspf7Uz23HKg8Uh7tOxFg4O
je2DgU7jpjeAjk3DAEUX8JUEfLYWE5po/N2eKVNbLhtFA4kwi1jGyjgZDc9AyWPx
UOWEZzfx+MW8cSorZvSm6NNZfTplTLGn+y7dlzcILFpAD+b53q1Dt2+VSG/YWd58
woZO0M1kp3+KAWlwjHHYLa+ZL0BGnI4+npGS2BStR6hGjU6GvpA1kTuCZVrMcEyx
0WE+nsubau5QAEs5wu/DJkzGxT/Z8dyCD5g5LmIXzYQkWWk80Dsc/5XRVd8cTdRU
/faXoQEXfkPCt2Lf44ej0r2d2GJWmB7+2B/n0B/ISUPBti09S7PuojgxpntbS8zO
18KXr7HXkE8NPY9rS+4Y3YPsoz6DvCyBCuCOeqQh0kulnxo/zZhneCXbp3ZCyV2S
v2XD9z9Lx2fBLopyPWBa
=TegU
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
