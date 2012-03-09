Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab2CIFaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 00:30:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54876 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707Ab2CIFaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 00:30:01 -0500
Message-ID: <1331270953.3022.89.camel@deadeye>
Subject: Re: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Jiri Slaby <jslaby@suse.cz>, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        raven@themaw.net
Date: Fri, 09 Mar 2012 05:29:13 +0000
In-Reply-To: <20120305223338.GE2930@1wt.eu>
References: <20120304180911.GA7336@kroah.com> <4F54A46A.6000305@suse.cz>
	 <20120305120241.GA3627@osiris.boeblingen.de.ibm.com>
	 <4F54B618.1090301@suse.cz> <20120305223338.GE2930@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RpAgxA6VwcZ+BUG8vH9Q"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RpAgxA6VwcZ+BUG8vH9Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-03-05 at 23:33 +0100, Willy Tarreau wrote:
> Hi,
>=20
> On Mon, Mar 05, 2012 at 01:48:24PM +0100, Jiri Slaby wrote:
> > >>> Linus Torvalds (2): Fix autofs compile without CONFIG_COMPAT
> > >>
> > >> But who defines is_compat_task *with* CONFIG_COMPAT on ia64?
> > >>
> > >> fs/autofs4/inode.c: In function 'autofs4_fill_super':
> > >> fs/autofs4/inode.c:345: error: implicit declaration of function
> > >> 'is_compat_task'
> > >=20
> > > The ia64 compat code got entirely removed, since it was broken:
> > >=20
> > > 32974ad4907cdde6c9de612cd1b2ee0568fb9409 "[IA64] Remove COMPAT_IA32 s=
upport"
> >=20
> > Yes, but that is even in 2.6.34. So the fix for autofs is incomplete in
> > .32 as it breaks build on configs which used to work.
>=20
> So in the end, does anybody have an idea what is missing from this patch =
?
> I'm not sure that reverting the autofs fix is a right solution either :-/

Either cherry-pick commit 32974ad4907cdde6c9de612cd1b2ee0568fb9409 or
use this reduced version.

Ben.

---
From: Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 9 Mar 2012 04:21:03 +0000
Subject: [PATCH] [IA64] Remove COMPAT_IA32 support

commit 32974ad4907cdde6c9de612cd1b2ee0568fb9409 upstream

This just changes Kconfig rather than touching all the other files the
original commit did.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/ia64/Kconfig |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 1ee596c..20fc9c5 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -502,23 +502,6 @@ config ARCH_PROC_KCORE_TEXT
 	def_bool y
 	depends on PROC_KCORE
=20
-config IA32_SUPPORT
-	bool "Support for Linux/x86 binaries"
-	help
-	  IA-64 processors can execute IA-32 (X86) instructions.  By
-	  saying Y here, the kernel will include IA-32 system call
-	  emulation support which makes it possible to transparently
-	  run IA-32 Linux binaries on an IA-64 Linux system.
-	  If in doubt, say Y.
-
-config COMPAT
-	bool
-	depends on IA32_SUPPORT
-	default y
-
-config COMPAT_FOR_U64_ALIGNMENT
-	def_bool COMPAT
-
 config IA64_MCA_RECOVERY
 	tristate "MCA recovery from errors other than TLB."
=20
--=20
1.7.9.1



--=20
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.

--=-RpAgxA6VwcZ+BUG8vH9Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT1mVKee/yOyVhhEJAQrnFhAA0pfLte4UmidGLxWW9lPK6QPuvEZqtTak
XvDMDGHBUWgUIEoA02FLTaZpZKh5M63FaClM9vPpsikTwnkfWnDlOjbvkGktiWrN
GFUk2e7oTMdzmyShr5G+XUX5ZgTM5kVOtiDNicLHGWqX7s+EWhR+swE7mfgewo3Y
h3YEUJOx0T9YmNMQ5BdwZYKV6sxBhTHon26scmloShQ1U+DSOh8zSg1nX404oILu
dUdwsuG/aailFR391dABuiFxeU5Zcq3gO0mySJU8EqvJ+Oord/8wZ3NWlfSCAoha
1b+nn7Zn0dBcPXylwoUvHFgLjQOYzsVqaNr4aXxoEL8j9yZGanyVuJZD8p/PBZRK
x9EZNAVnVMWszSf8/5kyFRc6SiDI9MOfGB2aWRmEqeaPmUDhHyS20fLQW1TaEz6h
Ish5STd717Vx13dhwQBHJwsdyCh72S6s14sQazlNe+a7jGjLXH3kAmnZQjIbjLSo
GHCrO/cPC1JNcf2UQi9kEkYnCW79bXxX5u9WDjv9E+hb1wDjXRBHo5SZ2DYH7CLp
64vBIO3O1+g3/kZTq8marZiVhhZIP/6gWWmx9uYspL6OiMyoKKLI9MUR+oj3j+eX
wZMBjIvq0cMzKuiHU08u66zpTkuC6imLuwF1dn58i6mIROP317S43ftFq7M54hPn
yKLaXNNz/Ok=
=iO6G
-----END PGP SIGNATURE-----

--=-RpAgxA6VwcZ+BUG8vH9Q--
