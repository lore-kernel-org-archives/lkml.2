Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2I0Gtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:49:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34882 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab2I0Gth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:49:37 -0400
Date: Thu, 27 Sep 2012 16:49:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120927164927.03f9dafeb014f11738daa2af@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Sep_2012_16_49_27_+1000_gxoyf51dLhmolkLq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Sep_2012_16_49_27_+1000_gxoyf51dLhmolkLq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/mm.h between commit 1dbd3d35fe64 ("mm/pgprot: Move the
pgprot_modify() fallback definition to mm.h") from the tip tree and
commit "mm, x86, pat: rework linear pfn-mmap tracking" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mm.h
index 4adea2c,a66f646..0000000
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@@ -160,37 -160,6 +160,19 @@@ extern pgprot_t protection_map[16]
  #define FAULT_FLAG_TRIED	0x40	/* second try */
 =20
  /*
-  * This interface is used by x86 PAT code to identify a pfn mapping that =
is
-  * linear over entire vma. This is to optimize PAT code that deals with
-  * marking the physical region with a particular prot. This is not for ge=
neric
-  * mm use. Note also that this check will not work if the pfn mapping is
-  * linear for a vma starting at physical address 0. In which case PAT code
-  * falls back to slow path of reserving physical range page by page.
-  */
- static inline int is_linear_pfn_mapping(struct vm_area_struct *vma)
- {
- 	return !!(vma->vm_flags & VM_PFN_AT_MMAP);
- }
-=20
- static inline int is_pfn_mapping(struct vm_area_struct *vma)
- {
- 	return !!(vma->vm_flags & VM_PFNMAP);
- }
-=20
- /*
 + * Some architectures (such as x86) may need to preserve certain pgprot
 + * bits, without complicating generic pgprot code.
 + *
 + * Most architectures don't care:
 + */
 +#ifndef pgprot_modify
 +static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 +{
 +	return newprot;
 +}
 +#endif
 +
 +/*
   * vm_fault is filled by the the pagefault handler and passed to the vma's
   * ->fault function. The vma's ->fault is responsible for returning a bit=
mask
   * of VM_FAULT_xxx flags that give details about how the fault was handle=
d.

--Signature=_Thu__27_Sep_2012_16_49_27_+1000_gxoyf51dLhmolkLq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQY/b3AAoJEECxmPOUX5FExoQP/Av4nyX+H+lRb/y1p9WQbZrB
9zl6WQlgSesgeqUfVQ+22VAyuLRkZWGjVsWLj4dH1ayVgCSV/VmsnawM1SRIkqRl
VccxWzFWqlpiZ01KiBadtRUNlTKZZVGBxpNK+Y/mIfUOEYu8xcZyII4/hV1mEdTy
cqhC9ZGW1LIkpi9mcqY/sE99tcyJyyJ50lhFBSUflBXGac6GbkRb3zVKKknsHhOp
roym/cRSERF//TAZ3OaTwWu5oggOt4TtY4kpSAI2HZMh1S8IxmQtin+a8nSkYR7y
fU5qLAr4117CuDAQngHCwP6cTUBB/pafvYz3VYdNWEBmsrrsZ5U9qEnXHh016iok
47d2XyYYVwA772mZGTdzDQ3Sz+5BQ7TS2VL7ofeibCDjWKCLpXjlTaE0/ijXNpbg
K4cX4+/+phQVvjWSYheDx02ilxvQz3OdbarrvPR6xIgniWAi3vFxlO+587lONMMK
Qx0sV6pjU88Ypku3nVi9uitFPuMRl/ItLiN3/ZlCpevnWmGXzU9iloJg/q8KtkKZ
xluckH46DgpNkDRcB/urvUqJtP5vzzzMnqhfSqHrMYezs+0vaNZBRBJJwueo6/fn
Ilrr7AV5I0cpHRoYpaSugjrnDs2zEe+z0eeNfiSu9B1tJQ5HdJ8tuFKxh7q5UTen
vdM3Zz2L7Wi3ITMa0sbx
=8if8
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Sep_2012_16_49_27_+1000_gxoyf51dLhmolkLq--
