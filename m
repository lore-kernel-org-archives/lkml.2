Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab2DEMuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 08:50:17 -0400
Received: from luna.schedom-europe.net ([193.109.184.86]:49078 "EHLO
	luna.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DEMuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 08:50:16 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 08:50:15 EDT
Date: Thu, 5 Apr 2012 14:43:22 +0200
From: Marc Leeman <marc.leeman@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marc Leeman <marc.leeman@gmail.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH]: expose FORCE_MAX_ZONEORDER on x86
Message-ID: <20120405124322.GQ2473@scorpius.homelinux.org>
Reply-To: Marc Leeman <marc.leeman@gmail.com>
References: <CAH+fs=-WkbLgB-wsNEPS_OnvqwK9eChMCrMOudjtg7bu2ZtqHg@mail.gmail.com> <20111205125107.GH3143@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L0mHLbha4YKvhGtu"
Content-Disposition: inline
In-Reply-To: <20111205125107.GH3143@elte.hu>
X-Operating-System: Linux harvey 2.6.29.1
X-Religion: Church of Tux
X-Registered-Linux-User: #138583
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L0mHLbha4YKvhGtu
Content-Type: multipart/mixed; boundary="b3OyYALfe3DXUU4J"
Content-Disposition: inline


--b3OyYALfe3DXUU4J
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> I guess we could do this - but you forgot to sign off on your=20
> patch.

It took me some time, but I finally rebased the patch against 3.3




--=20
  greetz, marc
harvey 2.6.29.1 #1 PREEMPT Mon Apr 6 22:33:31 CDT 2009 GNU/Linux

--b3OyYALfe3DXUU4J
Content-Type: text/x-diff; charset=iso-8859-15
Content-Disposition: attachment; filename="0001-KConfig-x86-enable-FORCE_MAX_ZONEORDER.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 8ad64edbf92ac8e0253677bd3f9ad376ce3be7d1 Mon Sep 17 00:00:00 2001
=46rom: Marc Leeman <marc.leeman@gmail.com>
Date: Wed, 26 Oct 2011 10:35:24 +0200
Subject: [PATCH 3.3] KConfig x86: enable FORCE_MAX_ZONEORDER

Larger blocks of memory can be required for e.g. higher resolutions on
some capture card drivers; this patch just enables an already
available configuration option on x86 (it was already exposed on other
architectures).

The default is set to 11, as in
=2E/include/linux/mmzone.h

[barco@nmgserver001 linux-3.0]$ find . -name Kconfig | xargs grep FORCE_MAX=
_ZONEORDER
=2E/arch/ia64/Kconfig:config FORCE_MAX_ZONEORDER
=2E/arch/cris/Kconfig:config FORCE_MAX_ZONEORDER
=2E/arch/arm/Kconfig:config FORCE_MAX_ZONEORDER
=2E/arch/s390/Kconfig:config FORCE_MAX_ZONEORDER
=2E/arch/mips/Kconfig:config FORCE_MAX_ZONEORDER
=2E/arch/sh/mm/Kconfig:config FORCE_MAX_ZONEORDER
=2E/arch/blackfin/Kconfig:config FORCE_MAX_ZONEORDER
=2E/arch/powerpc/Kconfig:config FORCE_MAX_ZONEORDER

Signed-off-by: Marc Leeman <marc.leeman@gmail.com>
---
 arch/x86/Kconfig |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9a4a267..68a98e8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1312,6 +1312,22 @@ config ILLEGAL_POINTER_VALUE
=20
 source "mm/Kconfig"
=20
+config FORCE_MAX_ZONEORDER
+	int "Maximum zone order"=20
+	range 11 64
+	default "11"
+	help
+	  The kernel memory allocator divides physically contiguous memory
+	  blocks into "zones", where each zone is a power of two number of
+	  pages.  This option selects the largest power of two that the kernel
+	  keeps in the memory allocator.  If you need to allocate very large
+	  blocks of physically contiguous memory, then you may need to
+	  increase this value.
+
+	  This config option is actually maximum order plus one. For example,
+	  a value of 11 means that the largest free memory block is 2^10 pages.
+
+
 config HIGHPTE
 	bool "Allocate 3rd-level pagetables from highmem"
 	depends on HIGHMEM
--=20
1.7.2.5


--b3OyYALfe3DXUU4J--

--L0mHLbha4YKvhGtu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFPfZNqUQpj09NWLeERArXRAJwJP5Vcu0gVmhvlfp9fy1NvJvUsKQCg1Qe5
7ykhe3YTkFvkzfE+akeRBo4=
=0SK8
-----END PGP SIGNATURE-----

--L0mHLbha4YKvhGtu--
