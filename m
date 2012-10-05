Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908Ab2JECzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 22:55:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38776 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab2JECzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 22:55:49 -0400
Date: Fri, 5 Oct 2012 12:55:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Avi Kivity <avi@redhat.com>, Bharat Bhushan <r65777@freescale.com>,
        Scott Wood <scottwood@freescale.com>, Liu Yu <yu.liu@freescale.com>
Subject: linux-next: manual merge of the kvm-ppc tree with Linus' tree
Message-Id: <20121005125540.ff715548d17f663d784fc6fe@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Oct_2012_12_55_40_+1000_+aOSLusjW6EzD70O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Oct_2012_12_55_40_+1000_+aOSLusjW6EzD70O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Today's linux-next merge of the kvm-ppc tree got a conflict in
include/linux/kvm.h between commit 7a84428af7ca ("KVM: Add resampling
irqfds for level triggered interrupts") from Linus' tree and commit
2b3ac3d5956c ("KVM: PPC: booke: Add watchdog emulation") from the kvm-ppc
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/kvm.h
index 0a6d6ba,99c3c50..0000000
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@@ -625,7 -628,7 +628,8 @@@ struct kvm_ppc_smmu_info=20
  #ifdef __KVM_HAVE_READONLY_MEM
  #define KVM_CAP_READONLY_MEM 81
  #endif
 -#define KVM_CAP_PPC_BOOKE_WATCHDOG 82
 +#define KVM_CAP_IRQFD_RESAMPLE 82
++#define KVM_CAP_PPC_BOOKE_WATCHDOG 83
 =20
  #ifdef KVM_CAP_IRQ_ROUTING
 =20

--Signature=_Fri__5_Oct_2012_12_55_40_+1000_+aOSLusjW6EzD70O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbkwsAAoJEECxmPOUX5FEdnYP/RG6Nz4R9lmmvVbZpmuiOGrj
wFibloi8VA3fKyVlGmNAayVIk8ndHAA7RwHLw+4Y6Pyt1BhSABnZhGs4mCXPJMFV
l6qdx49aOdNnPMzBPEvVsxGkDbiy0z/y14ULtxMlINx2vmeN1K+0AtxqMpMUjX3P
jkejfAJbeHR8LTr6dX+GtL1+z4CqQh/DwPMRd1/t/Ju1C2lZpf63M+rPDYpicw7W
XeyDNOx1T6+C02dbIcVsEL0RlgBexptPJtJT6rIqyEx/BpBtl8ynlaSgX6vq9taU
3TrT0MG0XGI80UfBcCayXx42JaXLIVJI2spdINwMFqCTG+XlzgMx6DFeW90TNVBv
MrTohpUawRCerbAJfnZrNJVxu2uY2fXdCZFSbJ41v76lEKlOP6kCRcfU2L/4gaxl
pDDLj81CHyAgZuhv8O1f4hLAJE7OXant58zRpeK6iLt0PTnxq4/mA1FNBebgYXOT
0ajh8YmHqfGML4iR2beY8aBk62sxnPd+OJSBxL0yE/vPIcwZHgFm19i8FmgJEg19
DqfwZHurXIp8iaGagIsGB/8kSYhzX+lzFSkFin42gGH0lW9Em6trz6ajAEQ2q8pL
CUYUw8vAzyijtww4iwCvhXE6pttb07YSjzM01eZOsrghaliMGi/FxVNGju7AM0nb
nyBafjEtzitfcJ0kQxcG
=hLmH
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Oct_2012_12_55_40_+1000_+aOSLusjW6EzD70O--
