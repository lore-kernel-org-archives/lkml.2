Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965950Ab2B2G1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 01:27:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38184 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab2B2G1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 01:27:42 -0500
Date: Wed, 29 Feb 2012 17:27:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120229172722.af9a7c25887a5b9a4106d78d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Feb_2012_17_27_22_+1100_26Nt=RdS9qezKnZT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Feb_2012_17_27_22_+1100_26Nt=RdS9qezKnZT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in arch/x86/Kconfi=
g between commit 0bf6276392e9 ("x32: Warn and disable rather than error if =
binutils too old") from the tip tree and commit "ipc: provide generic compa=
t versions of IPC syscalls" from the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary,
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/Kconfig
index 3ccd69a,f50b52a..0000000
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@@ -2221,7 -2221,8 +2221,8 @@@ config X86_X3
 =20
  config COMPAT
  	def_bool y
 -	depends on IA32_EMULATION || X86_X32_ABI
 +	depends on IA32_EMULATION || X86_X32
+ 	select ARCH_WANT_OLD_COMPAT_IPC
 =20
  config COMPAT_FOR_U64_ALIGNMENT
  	def_bool COMPAT

--Signature=_Wed__29_Feb_2012_17_27_22_+1100_26Nt=RdS9qezKnZT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTcVKAAoJEECxmPOUX5FEZPEP/irkn78XTVZlU7oPaMLVTvpj
HUUHIsw7FSjUBZMEdYpvKDlAkaQXvIrFC1sQTB/eTOV9K8pzlwymIlKdvxecrL1l
hm6rrYRY9nIwYE+DcvMk51w8wZ0HeNQl5J01ntSYLJHij194G/uR2d4xlk+QTwd3
bz3ETZIJdjBJeXav17Xh1zOkg6u2m+JsBk/Z4T0MHrpeE0nkf+o3qufkrHPidXna
SoiQvC9nyWHeUYWenR5MJlp7f0/2oDzemlteurUd9WyVLaKTiqPltF3GYmr/PtWG
8nfJtHF28tnkX9nLKoG9FUtGPKhRFhxjcLXAxYLRT/au0ZOynZmChrDNINPkZnZw
wH9bfPqyVLT7u4vatzSApLT3m0hgHuWp0rlhzUubA9Xh2qdtiT86DJLNY3RVy5dS
tXdoa5CoTKvPheTPqyAhBjJxrB7mQQhFIL7RdFHTow6Y+Vd9HS8gkwB2gvQ0eu3C
iL37fCe+rfKOzEvWTgEbSlQaEDbzmAJXO7QeEYQCUMgQ5Rmb8PVqkTeE6DA3HQrh
kLbF87o+7EAlSe87y6wkIQ3MaFKutsF9bMz4PH59wZQV+pHfzIggHWtZgdAOD8co
Pel5I00KCW2a3kmIuwdqXehjheknXUNHgwFJydrE8QP/e3nKOBxAeepHBvc6KqH0
xrMLJUTOnilwxvLLjzhj
=mw9k
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Feb_2012_17_27_22_+1100_26Nt=RdS9qezKnZT--
