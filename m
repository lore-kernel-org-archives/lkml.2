Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0K2BLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:11:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59479 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab0K2BLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:11:41 -0500
Date: Mon, 29 Nov 2010 12:11:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20101129121131.f3e7798b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Nov_2010_12_11_31_+1100_EHsax_wZVIbqy_ax"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Nov_2010_12_11_31_+1100_EHsax_wZVIbqy_ax
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

kernel/sched.c: In function 'sched_destroy_group':
kernel/sched.c:8098: warning: 'i' is used uninitialized in this function
kernel/sched.c:8088: note: 'i' was declared here

Introduced by commit 3d4b47b4b040c9d77dd68104cfc1055d89a55afd ("sched:
Implement on-demand (active) cfs_rq list").  I think this is a real bug.

[The wrong function is mentioned above, the actual function is
unregister_fair_sched_group() - presumably gcc has confused itself via
inlining.]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Nov_2010_12_11_31_+1100_EHsax_wZVIbqy_ax
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM8v3DAAoJEDMEi1NhKgbsG+wIAItMmmSf15f71tBlJHK2H/Ur
V2TxmeFeY/2WLUIPmef9WKRMMvc5d7q8xI0i30wUoC+mURZMS3OB7U/1MlNYXyfh
d402CYbLPnLZgg27Ou05CrF8tcWVd1mx9XFNJ49A7U3X3gLMhtFQ6zUvi9LD9CTN
ms2kxIlXdRxGZHG9VkaObW+xintD4HHyrZq0B8Zsu326ckA+6NhKk6PzMuoGrjE2
WPwuicctT1tQvcB+ownRKbiBU8qMstCI5fGURi9cX1FQGvWWJYR7xPYbGG2bY7Vq
CUgs9ZgczIBm8t3sNaLRZ/B+Clntl5MMolxBshy75sjySPrXap1QRnBAtFZsnr4=
=xr5H
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Nov_2010_12_11_31_+1100_EHsax_wZVIbqy_ax--
