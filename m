Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab2IDFEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 01:04:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51341 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2IDFEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 01:04:40 -0400
Date: Tue, 4 Sep 2012 15:04:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Bharat Bhushan <r65777@freescale.com>,
        Scott Wood <scottwood@freescale.com>, Liu Yu <yu.liu@freescale.com>
Subject: linux-next: manual merge of the kvm-ppc tree with the kvm tree
Message-Id: <20120904150430.3f8eda1a2021fb386082697c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Sep_2012_15_04_30_+1000_4LaNRv6o8+q_4sla"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Sep_2012_15_04_30_+1000_4LaNRv6o8+q_4sla
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Today's linux-next merge of the kvm-ppc tree got a conflict in
include/linux/kvm.h between commit 4d8b81abc47b ("KVM: introduce readonly
memslot") from the kvm tree and commit 1db21d25a11b ("KVM: PPC: booke:
Add watchdog emulation") from the kvm-ppc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/kvm.h
index d808694,f4f5be8..0000000
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@@ -622,9 -621,7 +625,10 @@@ struct kvm_ppc_smmu_info=20
  #define KVM_CAP_PPC_GET_SMMU_INFO 78
  #define KVM_CAP_S390_COW 79
  #define KVM_CAP_PPC_ALLOC_HTAB 80
 -#define KVM_CAP_PPC_BOOKE_WATCHDOG 81
 +#ifdef __KVM_HAVE_READONLY_MEM
 +#define KVM_CAP_READONLY_MEM 81
 +#endif
++#define KVM_CAP_PPC_BOOKE_WATCHDOG 82
 =20
  #ifdef KVM_CAP_IRQ_ROUTING
 =20

--Signature=_Tue__4_Sep_2012_15_04_30_+1000_4LaNRv6o8+q_4sla
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQRYveAAoJEECxmPOUX5FEJaQP/jcmNHUPmNFLVouJyNTma40g
5fuGXPqvz6kaDDhdi5qMYe8noqLixjGhrksEiHEZ5gIE0619+WGqxpFMwHVUBDmV
CmurQZxQ5nqcrVCpNLgItXNcjZuTZ1gf6sj5fMhP+PhuxKx2Iwlm5hJR7h8kTPZW
rs0GvG6rHto2O06TCHWREMNl0E/duE08xoIlGN3V272ULY4ixd88jVrvrjEDGNWg
YH76KbFp6tpOPLpKB5stLlX56+8YCMoNLEPi0WbjKbhy9pDHIGD60wOeqkaJoRXJ
aLRlhLnH1faxalhX+q/ThQZbGKgF0BMO0HwpNB9KZwNHy6s09zkn4VYwtrXmEm9a
HtMsKA7tR77yQx8O3lgQ1krqx6lnelBC7ue9expI4+SzgAViHLVMqZDJpVwk3u+F
5fsEbrvRaWOCWDVRU2gDM0JHX57lCfyRqh6q6UMs8V1E9FHLmTNHTwe89wlq0bNc
+Q+sLsqyMOcP1/XcGyS7KUfwMNSB7GuhiussH/4/9BTOaR1UkNNBkmw1STkaDo+x
vIwX2/Z9rA6+M3z32WJ2iaG1jralytn6mV/cVxiwLK5+lW06kfOEQFDBGEomRU9s
XtMxzi5lD2o6Wog/0qUV2Mm94aMX/joFR/iGxZeZyi+0ZmZduA82dLh34ZXMVUja
sVMxdSVoJrVf+7qnjehA
=XtJU
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Sep_2012_15_04_30_+1000_4LaNRv6o8+q_4sla--
