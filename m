Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab0H3Bfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 21:35:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51407 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab0H3Bfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 21:35:33 -0400
Date: Mon, 30 Aug 2010 11:35:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Graf <agraf@suse.de>
Subject: linux-next: build failure after merge of the kvm tree
Message-Id: <20100830113523.28e6fa9e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_Aug_2010_11_35_23_+1000_k2AbCgCp80YfFQO2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Aug_2010_11_35_23_+1000_k2AbCgCp80YfFQO2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/kernel/asm-offsets.c: In function 'main':
arch/powerpc/kernel/asm-offsets.c:470: error: invalid use of undefined type=
 'struct kvm_vcpu_arch_shared'
arch/powerpc/kernel/asm-offsets.c:472: error: invalid use of undefined type=
 'struct kvm_vcpu_arch_shared'
arch/powerpc/kernel/asm-offsets.c:474: error: invalid use of undefined type=
 'struct kvm_vcpu_arch_shared'
arch/powerpc/kernel/asm-offsets.c:476: error: invalid use of undefined type=
 'struct kvm_vcpu_arch_shared'
arch/powerpc/kernel/asm-offsets.c:478: error: invalid use of undefined type=
 'struct kvm_vcpu_arch_shared'
arch/powerpc/kernel/asm-offsets.c:479: error: invalid use of undefined type=
 'struct kvm_vcpu_arch_shared'

Caused by commits 3623fdb1aa54678f73da95e797eb6e4756d4bd0e ("KVM: PPC:
Convert MSR to shared page") and 158a244474a6620715c626d4647fec4d61aaeee7
("KVM: PPC: Generic KVM PV guest support").

I have used the kvm tree from next-20100827 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_Aug_2010_11_35_23_+1000_k2AbCgCp80YfFQO2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMewrbAAoJEDMEi1NhKgbsj8MH/2n7ax5uDVbQIVHpYuY8093/
3b9b9FVmonpIs+jGH+C8BR/8zkmLeksZdFWrxevf+4N+JagfBfHviBvZtP6XriRm
xNeSeT39pv/ZNZlM3FVy9ZhzwG528/148muoKdOVl6nqhsYC3deGSlpjgOVm8ziv
QJ18lx4SSFUaQIJ/Q5LA0X3VdeRPsp+96Pi3FB6bIkYNlh3BYilkERgQK0kcA3mg
HVYXf4l3PZIFIeorZPONEflIXOQUQVLcFRHXX2cMLZX/eoNaKfHMCGfrGNChQ0yd
OvRDHhsjqHo01bnXb6g0w7tx1JgQPM0fk9kfws+3yM/8MjNFDT/T3EUc7ucHfdI=
=Osus
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Aug_2010_11_35_23_+1000_k2AbCgCp80YfFQO2--
