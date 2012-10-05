Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab2JEDdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 23:33:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48232 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2JEDdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 23:33:09 -0400
Date: Fri, 5 Oct 2012 13:32:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm64 tree
Message-Id: <20121005133248.cca53b84a9dace0c1052a502@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Oct_2012_13_32_48_+1000_YYD8iuWrDwgiK_TR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Oct_2012_13_32_48_+1000_YYD8iuWrDwgiK_TR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm64/include/asm/unistd32.h between commit cce72b4219ee ("arm64:
Use the generic compat_sys_sendfile() implementation") from the arm64
tree and commit 890139529d45 ("UAPI: Fix the guards on various
asm/unistd.h files") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/include/asm/unistd32.h
index ec61180,3ba1f1a..0000000
--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@@ -754,6 -752,3 +752,4 @@@ __SYSCALL(__NR_syncfs, sys_syncfs
  #define __ARCH_WANT_SYS_SIGPENDING
  #define __ARCH_WANT_SYS_SIGPROCMASK
  #define __ARCH_WANT_COMPAT_SYS_RT_SIGSUSPEND
 +#define __ARCH_WANT_COMPAT_SYS_SENDFILE
-=20
- #endif /* __ASM_UNISTD32_H */

--Signature=_Fri__5_Oct_2012_13_32_48_+1000_YYD8iuWrDwgiK_TR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQblTgAAoJEECxmPOUX5FEUWAP+wbDbQ5Nb1qyMoaNp4LPf1qm
02z9y8HRA8xBfPvjJD1Ih8q0kUgf3Y4V9zZ73QonQ+yjr+TTv/5mDhzly29R3v7L
w2aW2avAPmd8MO+xV42vZt99WgVj/BAFecnrl3AJ3lbcF6dgcig+aPKrHSuTKStj
mwIuTXLhWraZRDpY+fLaCAAd0+U571avxXMphO7SLXDYGA9Tg8yfr4KsU8pr+cbI
ouze4FDI6v5bUy1iCb1WBLSj5225otc23N3m2bd81ymP5hRAgl1IEG7TIpKjD7y8
uIDPRzG9w+xfmdm+ZMvB4Z5TweaUZKkAkhpRX1mavXcx8vV0YojaaMJnv0NXBu52
8ao97CqllsF1+ePdk76TnB/1JidTAqNAciEPbq2pkOY0+s9gRlh/dIl2HU9RTQZG
xfwW63eExI9tsuhdyF8ZhKXSxoE0qmi+3WKQ8y8XKa1elDtfuR4tQEXlBu4pRFbh
OAZVqGFRAzOdlxzK2cFvhRGBMgqPRuiscDShqdfWAt45XZgVRnz6tIarD/2dKVdY
w0hLFZQwpXsWsD0xo77IR4sD+b5ZDJHXC5i8I3/kvb7nZF9WvydiGq2rqP7OWRHl
S7hAjhUMqIOOV+G5Dlpv7Ejx1ZTiAEyFpsC+1d9Cyqc8Tre8qjwDbXDOExrn4IWg
M/0iWw97u9t4eQDOc/Pd
=YjDV
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Oct_2012_13_32_48_+1000_YYD8iuWrDwgiK_TR--
