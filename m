Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab2CFExx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 23:53:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43616 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030363Ab2CFExm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 23:53:42 -0500
Date: Tue, 6 Mar 2012 15:53:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>
Subject: linux-next: build failure after merge of the kvm tree
Message-Id: <20120306155332.42d5094876089c8b7bb36bb0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Mar_2012_15_53_32_+1100_T12f_9UMn8.X62m."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Mar_2012_15_53_32_+1100_T12f_9UMn8.X62m.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the kvm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

include/linux/kvm_host.h:813:13: error: 'kvm_vcpu_compatible' defined but n=
ot used [-Werror=3Dunused-function]
cc1: all warnings being treated as errors

Caused by commit ab0bd7dfdaa5 ("KVM: Ensure all vcpus are consistent with
in-kernel irqchip settings").

This function presumably need to be "static inline bool" in the !
CONFIG_KVM_APIC_ARCHITECTURE case.

I have used the kvm tree from next-20120305 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__6_Mar_2012_15_53_32_+1100_T12f_9UMn8.X62m.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPVZhMAAoJEECxmPOUX5FEnRsP/jWmgxiplN8ECqvV7WjRvA0N
j6TU+RJaYe9Pde22C7plJyWjR45NMk7tUwwcEEXJnMo+U/HCQ7EoV6/LGgjiY7+s
CIDOSQyUtsiXgGxsQYxTtd8Gfj0Ak0n9m70XicIQsmtcBj1xF14NkNC+/+MRTxb2
VE33YSyfC7iIYxgrQfEqXl0F8DGroHmr2z/wdj0iH5jueunwf/roPJ4QUsy4Zuab
ooZ19rtZBZSKdzo8DH2fZFJfPS+ERNsIq4R0eftHTIgSr3eALS0waY7vGd0ipXpL
ddzQqKPoyhHscPTraKzSo1US6oy1KQHkV5cWC28UXfSWwae5yV80VsdXRoyM13c4
3WPL60XIIdXJnEDTFdtFuR5doSqiam7/plc68QhI5ha8MFR4INwKmV+plEftfsMs
JqWXyCTR6laX1UAhk0AzBzXo28FYew6qQzvdgxVnNFGaM9eb1brWyZTYZp6ZqjrR
0eRcva7M9zz3VDNvFTIQflQ6kGh/o7feNa08ZzKIPNmLOQkP5QJIkX6RM/JJBz8g
MQTRd4vt087EQ8/J8bthWs5uBg7wcT+lxpNxpRdNSucWy59B4HUmt+8LahwvM+hc
rQmnzwMMooKRgoARDK3EVmPM+uk9QZxyOU5pKaUMVh9vPbwPWvlG6pcqXqgRoW9q
6z2KB6ExMimfLf9cfmge
=KyEH
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Mar_2012_15_53_32_+1100_T12f_9UMn8.X62m.--
