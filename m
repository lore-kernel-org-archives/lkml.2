Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab1KVBXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:23:16 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58167 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab1KVBXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:23:14 -0500
Date: Tue, 22 Nov 2011 12:22:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the at91 tree with the arm tree
Message-Id: <20111122122250.0ea392605bac51e69331b9a2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Nov_2011_12_22_50_+1100_ClLzGPotq5.YCD4T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Nov_2011_12_22_50_+1100_ClLzGPotq5.YCD4T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the at91 tree got a conflict in
arch/arm/mach-at91/setup.c between commit cf48c02e3bf0 ("ARM: mach-at91:
remove arch specific special handling for ioremap") from the arm tree and
commit 6a5f01336ed8 ("ARM: at91: make DBGU soc independent") from the
at91 tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-at91/setup.c
index cf98a8f,3c309dc..0000000
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@@ -73,9 -75,24 +75,6 @@@ static struct map_desc at91_io_desc __i
  	.type		=3D MT_DEVICE,
  };
 =20
- #define AT91_DBGU0	0xfffff200
- #define AT91_DBGU1	0xffffee00
-=20
 -void __iomem *at91_ioremap(unsigned long p, size_t size, unsigned int typ=
e)
 -{
 -	if (p >=3D AT91_BASE_SYS && p <=3D (AT91_BASE_SYS + SZ_16K - 1))
 -		return (void __iomem *)AT91_IO_P2V(p);
 -
 -	return __arm_ioremap_caller(p, size, type, __builtin_return_address(0));
 -}
 -EXPORT_SYMBOL(at91_ioremap);
 -
 -void at91_iounmap(volatile void __iomem *addr)
 -{
 -	unsigned long virt =3D (unsigned long)addr;
 -
 -	if (virt >=3D VMALLOC_START && virt < VMALLOC_END)
 -		__iounmap(addr);
 -}
 -EXPORT_SYMBOL(at91_iounmap);
 -
  static void __init soc_detect(u32 dbgu_base)
  {
  	u32 cidr, socid;

--Signature=_Tue__22_Nov_2011_12_22_50_+1100_ClLzGPotq5.YCD4T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOyvlqAAoJEECxmPOUX5FEmoEQAJ3r8kHAGPw350g4mZChLU81
gvGIUpA9ojolgiGDN+BuPlJ/AUXURQtNtZ6txFTKzb16N00QJUG3JejxwoYrGVnc
9iMXVsQOIsl4yUHNlyQgaFcAvtQvmcpuVgKu555Rzpm40XPW8kaoUH2S0M9xGRKN
9fVuHrVJkJPi/c5CqTHPrigUgcRroiVZb60tHOMrmM+WZvpTGUYzUW5y8FvfOULx
N0yq902Tv+cy5L0GrmxQgmDOkrWi1DQKlZhFr+26pSrriErtOthrSAoTGmBHpjyR
MyF/0v48hRUiRfNTMnB4GDG2HBLD05oRtwVd0jjG4hO9BQP6wBoMIsdRoto6VrUL
rjAzxAxCOLVBDySTAO7vn3s/e7v/stK2vfK9QnZTU58yKpNhJJ2raMWqzd4ayAV9
0m5XchYVUTOljomhH3Wqp5YoChcAyfzCX5t1x6bshGKZJH9+093ws/JyEuqbDHA2
i/shmAGOE6kKGPy5+q4z/aEQGtcnxKi6FSWqCruWv1H7NhLLbDlLBsmZH3kpP1s9
B5MJJUASJ2sIrLJjxG0ymLaFd8Uz+f9/7UY2YJur0ZVU0j95x04aLUBUV6dTLA83
Z100CWjahgP3y83W5tTdTPBueYIBuigF66P90E5Y2KacPFDQNsJWSPI6BDhDEvT/
l2cerOUfd1IWCB/h+Hhb
=14G1
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Nov_2011_12_22_50_+1100_ClLzGPotq5.YCD4T--
