Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab2LDFiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 00:38:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36328 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2LDFiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 00:38:08 -0500
Date: Tue, 4 Dec 2012 16:37:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: linux-next: manual merge of the akpm tree with the rr-fixes tree
Message-Id: <20121204163750.2dd78499285ede7157b1d5b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Dec_2012_16_37_50_+1100_4twI4MGJQ3hkD=Lh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Dec_2012_16_37_50_+1100_4twI4MGJQ3hkD=Lh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
include/linux/kernel.h between commit cbdbf2abb784 ("linux/kernel.h:
define SYMBOL_PREFIX") from the rr-fixes tree and commit "mm: use
IS_ENABLED(CONFIG_COMPACTION) instead of COMPACTION_BUILD" from the akpm
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/kernel.h
index 69ddcb3,1e98564..0000000
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@@ -684,20 -684,6 +684,13 @@@ static inline void ftrace_dump(enum ftr
  /* Trap pasters of __FUNCTION__ at compile-time */
  #define __FUNCTION__ (__func__)
 =20
- /* This helps us avoid #ifdef CONFIG_COMPACTION */
- #ifdef CONFIG_COMPACTION
- #define COMPACTION_BUILD 1
- #else
- #define COMPACTION_BUILD 0
- #endif
-=20
 +/* This helps us to avoid #ifdef CONFIG_SYMBOL_PREFIX */
 +#ifdef CONFIG_SYMBOL_PREFIX
 +#define SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
 +#else
 +#define SYMBOL_PREFIX ""
 +#endif
 +
  /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
  #ifdef CONFIG_FTRACE_MCOUNT_RECORD
  # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD

--Signature=_Tue__4_Dec_2012_16_37_50_+1100_4twI4MGJQ3hkD=Lh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQvYwuAAoJEECxmPOUX5FE/BUQAJ6QqMXnppeo93c4zPzsJeyH
0qIYNJwl/23y71pQIwzws1hqDjOVf4+O2Nu0WEqHwyMmCELz8GwtgRflzXd+NqmH
lUkFScE3A+ocqE6jHVtVcRw6LPtqz3mb/OVXTXyJq9AG/fJbnJjuoRTncDrA5zGm
p6RmSlYvBadGWV7e5na6LuKze7vkb7sylaLnWIBuGTXRU4JyK0KvgSirOzLYZI/b
rGi5wzxY8e6umYQh7WoOr0GoKf5OFbcXCTtKBhViEvlI57RY76HLvLVwfXQo3PM+
2zsVOyKOcvyfi2gRCJG3vgPNefGLL1Eosb7lqp4HGU/9Wzdsi3DiIRXH7U5kJaRg
prpy+1XZ9l3rd8o7GxNAMzBdsOUjez1fW5lr4sDfqIWW8Uy8ru0L1FOQRXULMjH0
KvTt+cGPZSCO798kUONhTSCiUCT5i98V6Nmb1UjjKVrQCSP8fLNUK8Aam1vh5yyL
7B0byVoTF2WmFK6ULjEF2rg/oNSOQZ+piubUKa5GQt8CgZQNKyQRdQTKk/EpxU/6
IhbK5qKf1l8fwnHH3QTUykwfRLttrrca1amZMk/q3opq9QLSJ6kclFP+EBlGThhy
h6Mk+T6DcsajaYdLDjnxwgArsFSDh2tVk8QTW2s0ZFd5N34UAOV42FzZQB6BxbGF
vzMCaqeSg/X7bavvCs4q
=jVLF
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Dec_2012_16_37_50_+1100_4twI4MGJQ3hkD=Lh--
