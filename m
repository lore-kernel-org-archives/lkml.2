Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab2EUFVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 01:21:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37574 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2EUFVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 01:21:30 -0400
Date: Mon, 21 May 2012 15:21:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: linux-next: manual merge of the kvm-ppc tree with the kvm tree
Message-Id: <20120521152116.4e0c2e8d908771e6fe88e6f6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_May_2012_15_21_16_+1000_wS=1puE2X70kXgnG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_May_2012_15_21_16_+1000_wS=1puE2X70kXgnG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Today's linux-next merge of the kvm-ppc tree got a conflict in
include/linux/kvm.h between commit 1526bf9ccf31 ("KVM: s390: add
capability indicating COW support") from the kvm tree and commit
6e8fce2c6cd3 ("KVM: PPC: Book3S HV: Make the guest hash table size
configurable") from the kvm-ppc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/kvm.h
index 09f2b3a,fcc98df..0000000
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@@ -616,7 -616,7 +616,8 @@@ struct kvm_ppc_smmu_info=20
  #define KVM_CAP_KVMCLOCK_CTRL 76
  #define KVM_CAP_SIGNAL_MSI 77
  #define KVM_CAP_PPC_GET_SMMU_INFO 78
 -#define KVM_CAP_PPC_ALLOC_HTAB 79
 +#define KVM_CAP_S390_COW 79
++#define KVM_CAP_PPC_ALLOC_HTAB 80
 =20
  #ifdef KVM_CAP_IRQ_ROUTING
 =20

--Signature=_Mon__21_May_2012_15_21_16_+1000_wS=1puE2X70kXgnG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJPudDMAAoJEECxmPOUX5FEhdQP90GHY4qlMVvzYt2kt5oGeJzE
sXbN4CIoIb8HEV9k1TuZfHVxW0wtQ5FI+g74G6iC6q8DMkXZ+dmBZKC1VpBGolAc
q3LcWjtYBnnucIbTvpRPFPNxfRJQIjf9+6neUM1tnOBHhj5oSIuP5rjaw6F8f2vb
gGI13sHIJFm+CK0/zHN2W919lr+RXibXtQDjVUCpfmdrrLfi0AfnZNEFtPVUiqhG
GFT8ft7RwBjxD3uuPMFYoG3a3k1F3AcKPRDPHQI69m7fla7oX3T9tE4DaIKid8WE
bUAUjJPRfFDGjnIhkcd3jzNz5Kq62esJkvB064y8bOZs+WkQ2eRHDKAi+fEQgUcc
YfhGOoCMo1AV1TAl7ZgVuJy/h2GeSkhJU38aJ8HOlNftb3atJQ2WGcKBQM2D48wo
B/7xUTU+CGOAjHaPCK8QWKs8UBnf5u8FEPynl2ALmL2uLkemTmS9DR/UI9U5+Js2
w3SiYvP8a5cDrDsTrnCzwshvNmgWG6oIcE/0OGeGeQ+EEETAcibNNU0U5NYf+vCm
OafdMM8yi80uoTr7Xt73o8bDEBrez1RWlJO0lLQjV1Irm9C2w3Y3PcbgT3DoNojm
+jzRn1xPsKVFGNosgzoWNHop3jvNthuIguHVqD7qqw2jDOiimv+ToCuDb1fcwguR
eIR+CDYkvic0WcPdKEE=
=Nbg4
-----END PGP SIGNATURE-----

--Signature=_Mon__21_May_2012_15_21_16_+1000_wS=1puE2X70kXgnG--
