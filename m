Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1AaEnJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 23:43:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33507 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1AaEnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 23:43:08 -0500
Date: Mon, 31 Jan 2011 15:42:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, Michal Marek <mmarek@suse.cz>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20110131154259.dca1f7e6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Jan_2011_15_42_59_+1100_4uQ69K9JSwul3z3O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Jan_2011_15_42_59_+1100_4uQ69K9JSwul3z3O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

x86_64-linux-gcc: arch/x86/lib/memmove_64.c: No such file or directory

Caused by commit 9599ec0471deae24044241e2173090d2cbc0e899 ("x86-64, mem:
Convert memmove() to assembly file and fix return value bug") interacting
with our build system.

After removing arch/x86/lib/.memmove_64.o.cmd (left over from the build
before merging the tip tree) from my object tree, it built correctly.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__31_Jan_2011_15_42_59_+1100_4uQ69K9JSwul3z3O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNRj3TAAoJEDMEi1NhKgbsrzEH/1KBzOydqaC0qHpHERoxFqZr
ccQu1ajFjwfilG9V4eSVQRpolbi4D3uYRvlX5ksMYwGqGmIZ2TWNx2VgJTyb9xr1
5RXd6JkuSdMOj7g5kdcUc+njXUROLV49w13JTZW1Xregc+zQfx7VfEL+oJ8lfJ4n
MC3N1pb/Jk6n+HErcLJmw0sRV6nt4Wp4e+7G9H+I/h7W+ky4JkRwM2v8SlLMTgmE
hvqOWFgu72ycOGBvQb/5Fg76BRFUpi2vnsNgMh5MATrUwhOo8vj7Ucc+qlCU+wGO
oWxBEh1LkwpgXCU1Bj/PrY8ctejc5uVwQlz3kPLfioR7dPBt4TlR66Vd/nLri3c=
=JAqb
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Jan_2011_15_42_59_+1100_4uQ69K9JSwul3z3O--
