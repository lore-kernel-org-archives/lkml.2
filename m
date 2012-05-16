Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab2EPHOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:14:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44796 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272Ab2EPHOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:14:47 -0400
Date: Wed, 16 May 2012 17:14:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>
Subject: linux-next: manual merge of the kvm tree with the tip tree
Message-Id: <20120516171435.3b0a9c8a531081ff290763aa@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_17_14_35_+1000_YqFdg7bL5Rj8xtiO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_17_14_35_+1000_YqFdg7bL5Rj8xtiO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/x86/include/asm/kvm_para.h between commit c3709e6734da ("x86, kvm:
KVM paravirt kernels don't check for CPUID being unavailable") from the
tip tree and commit 9b72d3b07dd9 ("KVM guest: make kvm_para_available()
check hypervisor bit reading cpuid leaf") from the kvm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/kvm_para.h
index 183922e,a7a7a94..0000000
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@@ -170,17 -178,16 +178,19 @@@ static inline int kvm_para_available(vo
  	unsigned int eax, ebx, ecx, edx;
  	char signature[13];
 =20
 +	if (boot_cpu_data.cpuid_level < 0)
 +		return 0;	/* So we don't blow up on old processors */
 +
- 	cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
- 	memcpy(signature + 0, &ebx, 4);
- 	memcpy(signature + 4, &ecx, 4);
- 	memcpy(signature + 8, &edx, 4);
- 	signature[12] =3D 0;
+ 	if (cpu_has_hypervisor) {
+ 		cpuid(KVM_CPUID_SIGNATURE, &eax, &ebx, &ecx, &edx);
+ 		memcpy(signature + 0, &ebx, 4);
+ 		memcpy(signature + 4, &ecx, 4);
+ 		memcpy(signature + 8, &edx, 4);
+ 		signature[12] =3D 0;
 =20
- 	if (strcmp(signature, "KVMKVMKVM") =3D=3D 0)
- 		return 1;
+ 		if (strcmp(signature, "KVMKVMKVM") =3D=3D 0)
+ 			return 1;
+ 	}
 =20
  	return 0;
  }

--Signature=_Wed__16_May_2012_17_14_35_+1000_YqFdg7bL5Rj8xtiO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs1PbAAoJEECxmPOUX5FEu6kP/11Dgj2tMgqIpl+Yj1ayxKrh
p8BghuRZAt9ke/Sz0bTYJlUnPctUAtnULCYs2stQjEfncow0tklCQPB4E95q/DVZ
3SVSuv5OH2pfkxHHavKX+uf3ktrK3Xs/EqbJWJ0pyuBNJvWlUd/10Bo7s7BVIvS0
8ATjlYGaqhbV9ihZ3F+5wqdhBCnY52YGbRMBOo3/jpGwGQAIG9W1KLNLXQwaEpDh
s2w10QjQ5FUPsJdDBx+Trvr9OepJQW0OnahynWMweZoCEDYZCKipXeB6R5IVXyMo
M+NRmrL5o0ZsVVd/t/2YieHt8N4Ri0NAYnZr6UBJkFCwzrCaFAsAbw/aqAJ6U1zT
g5qivUu5viZrp939ijZ6CCNF6yPQMylrUkH95nBwJuaagyE/s1tLctDgInuPjP3f
ATuMthJkvDFFoqAR+aiXooTvvxBCXVrck3PfYoP25ovbuzdVVv/vQmlJxmD8aLY3
/2GHWeu/VcmmFcqrf+xrQ8SjR+nsTLiQKtohBt+Jig1gDKX6xOqCYIdc84otytDs
ThippfT+KI6ntW2uJCrYb4D0vgzGr2O2KWYPCV+q0RBwXMmxZmHtmkCwCzjv+GR2
A9bTK49D8lU6Wb1xueGMv4poPinj6VNEKlLZZuWXWOSOI4zni0pzIB1xAPC1UyRX
TS06F/Dq1UfDrnrpodSw
=xlsL
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_17_14_35_+1000_YqFdg7bL5Rj8xtiO--
