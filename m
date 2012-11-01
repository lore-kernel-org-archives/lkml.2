Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123Ab2KADlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 23:41:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35186 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757555Ab2KADlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 23:41:07 -0400
Date: Thu, 1 Nov 2012 14:40:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: linux-next: manual merge of the tmem tree with the xen-two tree
Message-Id: <20121101144059.a8350c24499f1beffe59a64a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Nov_2012_14_40_59_+1100_9k9XJOdi2dg8w7/v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Nov_2012_14_40_59_+1100_9k9XJOdi2dg8w7/v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

Today's linux-next merge of the tmem tree got conflicts in
arch/x86/include/asm/xen/interface.h and drivers/xen/cpu_hotplug.c
between commit 6c6067f26388 ("xen/pvh: Extend vcpu_guest_context, p2m,
event, and XenBus") from the xen-two tree and commit 7282a68f5aea ("PVH:
Basic and preparatory changes") from the tmem tree.

I fixed it up (see below and using the xen-two version for cpu_hotplug.c)
and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/xen/interface.h
index 20e738a,104fa50..0000000
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@@ -145,16 -136,8 +145,17 @@@ struct vcpu_guest_context=20
      struct cpu_user_regs user_regs;         /* User-level CPU registers  =
   */
      struct trap_info trap_ctxt[256];        /* Virtual IDT               =
   */
      unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ent=
s) */
 -    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ent=
s).*
 -					     * PV in HVM: it's GDTR addr/sz */
 +    union {
 +	struct {
- 		/* PV: GDT (machine frames, # ents).*/
++		/* PV: GDT (machine frames, # ents).
++		 * PV in HVM: it's GDTR addr/sz */
 +		unsigned long gdt_frames[16], gdt_ents;
 +	} pv;
 +	struct {
 +		/* PVH: GDTR addr and size */
 +		unsigned long gdtaddr, gdtsz;
 +	} pvh;
 +    } u;
      unsigned long kernel_ss, kernel_sp;     /* Virtual TSS (only SS1/SP1)=
   */
      /* NB. User pagetable on x86/64 is placed in ctrlreg[1]. */
      unsigned long ctrlreg[8];               /* CR0-CR7 (control registers=
)  */

--Signature=_Thu__1_Nov_2012_14_40_59_+1100_9k9XJOdi2dg8w7/v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQke9LAAoJEECxmPOUX5FECyoP/j7NEdaYnJ3YiVnHloH3o+Cj
kN8+6mUgch6v9j+LKIOx/xcN074k6MuZCOty7W1U8yWq0+l6PjaXSUAvDHufSqjL
N0bpOA9u1v/2deGL04DjPXpi1rkocRtoN07qItpbuG1ZgnEJ+VBehofDkvIHRIIe
jgAH2YnHX59n8K1L4F3vlZhUEsTxpWWKFEcaYkxdJcMtw05X/z5oceR7E3WG9Uy8
17j/5yI5P7w+cJt2QZo1jE+n+8EYRlAgVjR+HukIYye1QZ2LVEBKwZvWxlRmppHc
lQ0jZheCFrNmLBhrgEhGHpdXjjOWdx5iqc+BhyzH6JVHVFdfSTu950wpclDgVfal
30ZMEHJ/a/sxC3ZeraQHqKjatZ7UCeoLUMiu4Cu9y9n2DRRFmSuy7UzmIb2Yb/S8
eefr17lGmYlQNitVfqRkwgFC85gqx8fw0wFFk+F56DZizd0H/abwLa0RxoSoS+8B
X3uxRGf078/Ndij5dn3Z5HCqSWhTnwm8mCrZAcT0e75j1xDdVMWcjNz65tcERzG3
Ozb7crFQD2A56z/hWr43w+RF4A6mJXbIGWwlTpqK3F3lGdTbt2n+GhvWzCiWv+Rt
IPBdgUZIE61jjsvB87obIN9hOx5VcrGdO990T00qY8W14rC31yVB2QagRUwq+O40
XzbpHffM/8hHSRE38KMy
=Yq7j
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Nov_2012_14_40_59_+1100_9k9XJOdi2dg8w7/v--
