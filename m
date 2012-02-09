Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab2BIEO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 23:14:26 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42881 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2BIEOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 23:14:24 -0500
Date: Thu, 9 Feb 2012 15:14:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>
Subject: linux-next: manual merge of the irqdomain tree with the arm tree
Message-Id: <20120209151413.0dfec71771dd156843c0f4fa@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_Feb_2012_15_14_13_+1100_9lqNTERhG_HGU3og"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Feb_2012_15_14_13_+1100_9lqNTERhG_HGU3og
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the irqdomain tree got a conflict in
arch/arm/common/gic.c between commit c11907f588d6 ("ARM: 7318/1: gic:
refactor irq_start assignment") from the arm tree and commit 7da5a66bbf1f
("irq_domain: Remove 'new' irq_domain in favour of the ppc one") from the
irqdomain tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/common/gic.c
index ca6b5dd,8cf934c..0000000
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@@ -348,12 -344,15 +345,11 @@@ void __init gic_cascade_irq(unsigned in
 =20
  static void __init gic_dist_init(struct gic_chip_data *gic)
  {
- 	unsigned int i, irq;
+ 	unsigned int i;
  	u32 cpumask;
  	unsigned int gic_irqs =3D gic->gic_irqs;
- 	struct irq_domain *domain =3D &gic->domain;
  	void __iomem *base =3D gic_data_dist_base(gic);
 -	u32 cpu =3D 0;
 -
 -#ifdef CONFIG_SMP
 -	cpu =3D cpu_logical_map(smp_processor_id());
 -#endif
 +	u32 cpu =3D cpu_logical_map(smp_processor_id());
 =20
  	cpumask =3D 1 << cpu;
  	cpumask |=3D cpumask << 8;
@@@ -694,12 -689,13 +686,12 @@@ void __init gic_init_bases(unsigned in
  	 * For primary GICs, skip over SGIs.
  	 * For secondary GICs, skip over PPIs, too.
  	 */
 -	hwirq_base =3D 32;
 -	if (gic_nr =3D=3D 0) {
 -		if ((irq_start & 31) > 0) {
 -			hwirq_base =3D 16;
 -			if (irq_start !=3D -1)
 -				irq_start =3D (irq_start & ~31) + 16;
 -		}
 +	if (gic_nr =3D=3D 0 && (irq_start & 31) > 0) {
- 		domain->hwirq_base =3D 16;
++		hwirq_base =3D 16;
 +		if (irq_start !=3D -1)
 +			irq_start =3D (irq_start & ~31) + 16;
 +	} else {
- 		domain->hwirq_base =3D 32;
++		hwirq_base =3D 32;
  	}
 =20
  	/*

--Signature=_Thu__9_Feb_2012_15_14_13_+1100_9lqNTERhG_HGU3og
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPM0gVAAoJEECxmPOUX5FEOWgP/RLudBov5wlVHInZ/nC4fq0G
mWjygeWpBjJqrAAuegzrUJIw/zbyFBIguOC00bEb+KrbSVRukJX2btQOrDPWn0Me
EKsFGLl017D/I7RaN0om4//2EEOf9+6evMfgis5hMdbyyPDsNhs+uUqQduIE/y8Q
v1fkTNE5S/Rys5M1Sd3PzNN7AQi+2nnf0jLo4XP63p6jR7dsQUMslCaQ0+b4OWpG
Tjqa6bnmRMzfaKao7XLSxNMPoXfWoR5b7r8muab9bSMmGDTJNNUXZYsRZHm9uM/8
h3TZXFjf2JK1wf12D0xyiShW9rx3aHDMT59KIWB9ClM3Li7+d36thngMrrOOSLTd
Js//eaQpK6qtR7kKW2+8TOrhWARgck+6Q4g2MWxS0w9gb7pfypGPligf1QVtLOHq
kTJ7XGXh9TJHDU1YrnD13NDUje86xo0WyCfkc/x4BLIhIeaDl9TWJb8nLRwgojSc
+ugibW2ghdDHWwk69DAR8soUToNEeS4g1BPKoEG9RiK8LLT6tbVpSfzR2AAI9Wnp
C4Q2DF9b8ElkwpN0cJWgsTDiO8h+1wPa0/KuhntPxNKkWMY23YqcjFYkuH3Ft6IP
4kS7Gb7zC0A5I0oM6vySOIn6NOu+xprjgTjlpyHYbPagv5o8fzS5EVgix4zxOwbK
Aox+BdwhmPsISUkC/S6L
=awqU
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Feb_2012_15_14_13_+1100_9lqNTERhG_HGU3og--
