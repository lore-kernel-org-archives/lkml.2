Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2CNEbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 00:31:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55198 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2CNEbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 00:31:13 -0400
Date: Wed, 14 Mar 2012 15:31:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: build failure after merge of the uprobes tree
Message-Id: <20120314153106.0090c309e7503a7052f11ad0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Mar_2012_15_31_06_+1100_Myt3BkOAidrm25j="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Mar_2012_15_31_06_+1100_Myt3BkOAidrm25j=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

After merging the uprobes tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/compat.h:18:0,
                 from arch/x86/include/asm/ia32.h:7,
                 from arch/x86/include/asm/sigframe.h:17,
                 from arch/x86/kernel/asm-offsets.c:16:
arch/x86/include/asm/compat.h:238:20: error: redefinition of 'is_ia32_task'
arch/x86/include/asm/thread_info.h:272:20: note: previous definition of 'is=
_ia32_task' was here

Caused by commit 081c056eccf3 ("x86: Move is_ia32_task to
asm/thread_info.h from asm/compat.h") which added the function to
asm/thread_info.h but did not remove it from asm/compat.h.  The version
of this patch that is in the tip tree is correct (but that is not in
tip's auto-latest branch (and hence linux-next) today).

I would have used the uprobes tree from next-20130309, but trying that
produced a large number of conflicts, so I just dropped the uprobes tree
for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Mar_2012_15_31_06_+1100_Myt3BkOAidrm25j=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYB8KAAoJEECxmPOUX5FETCkP/j9YOkhnF7XlVHBBpyQMBVPB
C6tzqVBvHtrVQwcioQdKibClrcIIE2anqJDQAJJh5zdqNLcRc66MECcWdOPOMRNF
6XeqLKTTxc0T7JL4/hXNDWyCp35e2cNXKOh+Yvu+Qqz0N+A6xVGV55DxS8zyC6sp
lx3YpKIylh//3M62As8oMZTd3C1mGApJJChAOYvZoeQzAvpFfTY/1r5zVLcr/QFH
G3dlUlWZX6E4olL5zGIA26WjsBDc/zJZGo8/u3Ovq8cbXRgGSZq338a3Fb2Ik9Dv
vM/RpWKsB0Y55dTmkDuyKV+Tgqv0QltWBV8u0xYesOytbDA1B99EOdQ7dlEDN5Om
bcHhAAPqIu6rHUB8fausRs53d28A1EZdoK+9SKvQt4K7knHIVAJaA9+NkWYOomw1
E09EshN9mXHBI2Jv9uk3KcYwMSFc8u2HjSgQ6qf3k8nhcIH7BLcoCsAgyXyzXWUQ
eTBSGYnz56zx9N/5FcVXbef2DxO5X4PTJqacEj//hDLVt7FhF54dMtssAAuiAGS1
MQIEMscBz9G1spJr/OoAQm9nlgb3DBgusAKpZQzAiBdEVl9erKThdLLfkrKyK2YU
7yE7BgPv8pvTAOE8b+I0kRR4lQ06gvkSaRmN6hmwGH3vYodEQjYEgIZSHefGkYkB
+lR8JGD68AmFlu/lbxpS
=bdOo
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Mar_2012_15_31_06_+1100_Myt3BkOAidrm25j=--
