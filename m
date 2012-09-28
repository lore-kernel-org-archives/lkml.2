Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab2I1DiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 23:38:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37778 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab2I1DiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 23:38:18 -0400
Date: Fri, 28 Sep 2012 13:38:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the tip tree with the rr tree
Message-Id: <20120928133816.85dd67a7276558b9a7e574d5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Sep_2012_13_38_16_+1000_ydTYTSOJhJiFdlqR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Sep_2012_13_38_16_+1000_ydTYTSOJhJiFdlqR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/Kconfig between commit 9a9d5786a5e7 ("Make most arch
asm/module.h files use asm-generic/module.h") from the rr tree and
commits fdf9c356502a ("cputime: Make finegrained irqtime accounting
generally available") and edf55fda35c7 ("x86: Exit RCU extended QS on
notify resume") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/Kconfig
index ede3e92,56e7a25..0000000
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@@ -97,11 -102,12 +102,14 @@@ config X8
  	select KTIME_SCALAR if X86_32
  	select GENERIC_STRNCPY_FROM_USER
  	select GENERIC_STRNLEN_USER
 +	select MODULES_USE_ELF_REL if X86_32
 +	select MODULES_USE_ELF_RELA if X86_64
+ 	select HAVE_RCU_USER_QS if X86_64
+ 	select HAVE_IRQ_TIME_ACCOUNTING
 =20
  config INSTRUCTION_DECODER
- 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
+ 	def_bool y
+ 	depends on KPROBES || PERF_EVENTS || UPROBES
 =20
  config OUTPUT_FORMAT
  	string

--Signature=_Fri__28_Sep_2012_13_38_16_+1000_ydTYTSOJhJiFdlqR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQZRuoAAoJEECxmPOUX5FEj+gQAI0Fmkp3l3oPiF3myEB3I688
m73sKJB9vY6R+q9oUxiPmnwkB2plO7elIQx8tR/WMj1aXYHSeRiV9VO8uEFG1Rrr
FIO8nWUcJInYcIiFwbxYnIsMo3RMIOrUj+xDryc1tprxbmkzXr1H69AqXA7/T6zg
YHH/VUnvFdOxal00nxBKn0HzlbtVafjKwXEJsjbb7e8LYrUvnMvUOU4r3ZY4mFiS
gPrJiWzb5C2vXWJwW2drTdEyiFG8zPooe/fmUrwKka+Z+Hx0p7xyNjswEQJVaTGN
yqO6NUIp8ozyQx7l72lS1py7Iz3L6ep1mFsFDZ3ADPir5Bk5DUNs2wlBypALhXaR
JYWm2l4qsSr8FFPCqOZ1r7s/cYMRroCSGFd1gvB2zcoe2tR1rvITWNZIlnqqCdAp
tVhuJfvasyWRocafjaxucZ4qpW9hR8dKCogGBmIQpLyIo7KVItRNuIpFnTUeWoaT
THr46bbwTn7mcyKNDZdIVFW7NSW89tgUsqR//EHLOFSSJjXM+RWUDtO2/Ovyadnw
mpw9vycUrKRbGxDAXe2Qn7sHM9wBzRJMzwXRrkiTCpkzF5ACAlilSeCDEpFCbRNs
VW1QFN7CyYrw+dR/zrglMazcbqcR0P+jl8UAz8RSiEXWKSURuMBPXvZseLa1cp1r
POyvtuHnyr7zRxyrY/yp
=/CjF
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Sep_2012_13_38_16_+1000_ydTYTSOJhJiFdlqR--
