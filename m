Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2DWGDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:03:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57074 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2DWGDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:03:21 -0400
Date: Mon, 23 Apr 2012 16:03:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the dma-mapping tree with the tip tree
Message-Id: <20120423160309.59622ba2cc2139dd50f742e9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Apr_2012_16_03_09_+1000_th8pjFweVXpQiYT0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Apr_2012_16_03_09_+1000_th8pjFweVXpQiYT0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the dma-mapping tree got a conflict in
arch/x86/include/asm/dma-mapping.h between commit f7219a5300ba ("x86:
Introduce CONFIG_X86_DMA_REMAP") from the tip tree and commit
cfe29d4b429b ("X86: integrate CMA with DMA-mapping subsystem") from the
dma-mapping tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/dma-mapping.h
index 61c0bd2,7b9227b..0000000
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@@ -62,12 -63,10 +63,16 @@@ extern void *dma_generic_alloc_coherent
  					dma_addr_t *dma_addr, gfp_t flag,
  					struct dma_attrs *attrs);
 =20
+ extern void dma_generic_free_coherent(struct device *dev, size_t size,
+ 				      void *vaddr, dma_addr_t dma_addr,
+ 				      struct dma_attrs *attrs);
+=20
 +#ifdef CONFIG_X86_DMA_REMAP /* Platform code defines bridge-specific code=
 */
 +extern bool dma_capable(struct device *dev, dma_addr_t addr, size_t size);
 +extern dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr);
 +extern phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr);
 +#else
 +
  static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_=
t size)
  {
  	if (!dev->dma_mask)

--Signature=_Mon__23_Apr_2012_16_03_09_+1000_th8pjFweVXpQiYT0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPlPCdAAoJEECxmPOUX5FE4XUP/1RG9Vlt6lxYPVjqkZXGPucQ
cCTvFW2/Kq8bEbqnDSKbNQxMRv4tJDlD40fGbrBCcBXT6OFDuUYivVL8p93NW/83
3eClQid4WKx9UsUfJWB2b1mlxpxXpQAPEId2/AKzyHrg6moCEvMW+5AZgRrYMfIy
SWalCNOPXovvWXbUf7RdrKmZdXghedCVfF2LnP9qX8SExPmmmg2TFuToflBVjmnY
4Cc07PVtc576VrbCOyYOpmFnSycEIOJD6iOqh80BnrjrfhTa4OAtu//PvaseFH9K
cwphdTeRBoLI8uKDWKsbPS10tkAxpGdbI30T6fJFhLElTlJuf2yS1L1TXOTuK+6s
47W2rCcqDKyhGz9ubugSqohhjA/xPGgwhcvLbxsVHPXo4epSwVPUNcwqaijHjsMX
yXwWGWGW1YFRXhseqyOQJU4k5IeVi1fnkFNn2Bf6kkitIyB4GkD2FDWIkZ/elyx+
qVeMDCnCFGOHMLCvUgu0VJH/fjsqOQqSEBEY2BWzF8D0SgxlFRp1uzmt5NnX+YfD
E+zrPn1MJ+BgGwhiIXYmy665ec2Ohx4tjPUFT63g1Vx9iPUpB3o+8t1ITE4LPq+c
t7Oj5r8m6O13TAAmctk1C9aD+R+cPtfT05ck5jifwEgwlazOTRDwOqm/t1SiPyOX
6nBTEn/jN3xzz9siNvRf
=ANZS
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Apr_2012_16_03_09_+1000_th8pjFweVXpQiYT0--
