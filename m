Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2DENhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 09:37:48 -0400
Received: from amber.schedom-europe.net ([193.109.184.92]:44995 "EHLO
	amber.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab2DENhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 09:37:37 -0400
Date: Thu, 5 Apr 2012 15:37:27 +0200
From: Marc Leeman <marc.leeman@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marc Leeman <marc.leeman@gmail.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH]: expose FORCE_MAX_ZONEORDER on x86
Message-ID: <20120405133726.GS2473@scorpius.homelinux.org>
Reply-To: Marc Leeman <marc.leeman@gmail.com>
References: <CAH+fs=-WkbLgB-wsNEPS_OnvqwK9eChMCrMOudjtg7bu2ZtqHg@mail.gmail.com> <20111205125107.GH3143@elte.hu> <20120405124322.GQ2473@scorpius.homelinux.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UbqA5qh2E+WCbFAw"
Content-Disposition: inline
In-Reply-To: <20120405124322.GQ2473@scorpius.homelinux.org>
X-Operating-System: Linux harvey 2.6.29.1
X-Religion: Church of Tux
X-Registered-Linux-User: #138583
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UbqA5qh2E+WCbFAw
Content-Type: multipart/mixed; boundary="UNifc18z8z6e1QHx"
Content-Disposition: inline


--UNifc18z8z6e1QHx
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > I guess we could do this - but you forgot to sign off on your=20
> > patch.
>=20
> It took me some time, but I finally rebased the patch against 3.3

Sorry, the previous patch gave a (sloppy) whitespace warning, refreshed
it.

--=20
  greetz, marc
harvey 2.6.29.1 #1 PREEMPT Mon Apr 6 22:33:31 CDT 2009 GNU/Linux

--UNifc18z8z6e1QHx
Content-Type: text/x-diff; charset=iso-8859-15
Content-Disposition: attachment; filename="0001-KConfig-x86-enable-FORCE_MAX_ZONEORDER-updated.patch"
Content-Transfer-Encoding: quoted-printable

=46rom 463bf232150089ee114ebc9712890ff5b0aca9c5 Mon Sep 17 00:00:00 2001
=46rom: Marc Leeman <marc.leeman@gmail.com>
Date: Thu, 5 Apr 2012 14:25:22 +0200
Subject: KConfig x86: enable FORCE_MAX_ZONEORDER

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


Signed-off-by: Marc Leeman <marc.leeman@barco.com>
---
 arch/x86/Kconfig |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d14cc6..ba4ed6a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1296,6 +1296,22 @@ config ILLEGAL_POINTER_VALUE
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


--UNifc18z8z6e1QHx--

--UbqA5qh2E+WCbFAw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFPfaAWUQpj09NWLeERAoXaAKDBDN35V96u3pAFJN0uoy4v0Jr9gQCg3067
BUor5kShYphqTcOmL5Mucb4=
=UhZE
-----END PGP SIGNATURE-----

--UbqA5qh2E+WCbFAw--
