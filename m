Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab1JINra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 09:47:30 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:49333 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab1JINr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 09:47:28 -0400
Date: Sun, 9 Oct 2011 16:47:26 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm00@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: [3.1 patch] x86 vsyscall_64.c: better error message on bad pointers
Message-ID: <20111009134725.GD4586@localhost.pp.htv.fi>
References: <20111005214047.GE14406@localhost.pp.htv.fi>
 <alpine.LFD.2.02.1110052346080.18778@ionos>
 <20111009134539.GC4586@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20111009134539.GC4586@localhost.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

At least some UML versions run into this and need vsyscall=3Dnative
for now.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
---
 arch/x86/kernel/vsyscall_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 18ae83d..4ab7e32 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -206,7 +206,7 @@ bool emulate_vsyscall(struct pt_regs *regs, unsigned lo=
ng address)
 		 * vsyscalls harder, generate SIGSEGV here as well.
 		 */
 		warn_bad_vsyscall(KERN_INFO, regs,
-				  "vsyscall fault (exploit attempt?)");
+				  "vsyscall fault (exploit attempt?) - if this is a legitimate program=
 boot with vsyscall=3Dnative (read kernel-parameters.txt for the security i=
mplications)");
 		goto sigsegv;
 	}
=20


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6Rpe0ACgkQmfzqmE8StADWDgCaAkTJA6n2PySYhko3YXS7oCz8
FjYAnifq31+FAcQnktp2Gsv/lJYnZTph
=vfLG
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
