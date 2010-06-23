Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab0FWQb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:31:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53321 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab0FWQb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:31:26 -0400
Date: Thu, 24 Jun 2010 02:31:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: build failure after merge of the final tree (tip tree
 related)
Message-Id: <20100624023117.219953e4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Jun_2010_02_31_17_+1000_ILM9iCXMaFf5L7bd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Jun_2010_02_31_17_+1000_ILM9iCXMaFf5L7bd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sh allnoconfig -
in fact, all the sh configs) failed like this:

cc1: warnings being treated as errors
In file included from include/linux/ftrace_event.h:8,
                 from include/trace/syscall.h:6,
                 from include/linux/syscalls.h:75,
                 from arch/sh/kernel/sys_sh32.c:9:
include/linux/perf_event.h:937: error: 'struct regs' declared inside parame=
ter list
include/linux/perf_event.h:937: error: its scope is only this definition or=
 declaration, which is probably not what you want
include/linux/perf_event.h: In function 'perf_fetch_caller_regs':
include/linux/perf_event.h:952: error: passing argument 1 of 'perf_arch_fet=
ch_caller_regs' from incompatible pointer type

This started after next-20100618.

Caused by commit b0f82b81fe6bbcf78d478071f33e44554726bc81 ("perf: Drop
the skip argument from perf_arch_fetch_regs_caller") which contained a
typo in the type of the first argument to perf_arch_fetch_caller_regs()
in the case that the architecture did not define
perf_arch_fetch_caller_regs.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Jun_2010_02_31_17_+1000_ILM9iCXMaFf5L7bd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwiNtUACgkQjjKRsyhoI8yu8gCeKREkmNlazieVGXmPwBA7nj8b
NxsAoIIlA2FIWWF8wFMh1PiO1k78aeCw
=Rjfq
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Jun_2010_02_31_17_+1000_ILM9iCXMaFf5L7bd--
