Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0D0B2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 21:28:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47279 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab0D0B2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 21:28:46 -0400
Date: Tue, 27 Apr 2010 11:28:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the wireless tree
Message-Id: <20100427112842.3eec02a1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_11_28_42_+1000_+3+63NX9bx67tWzz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_11_28_42_+1000_+3+63NX9bx67tWzz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless tree, today's linux-next build (x86_64 allmodcon=
fig)
produced these warnings:

In file included from drivers/net/wireless/libertas_tf/main.c:12:
drivers/net/wireless/libertas_tf/deb_defs.h:12:1: warning: "pr_fmt" redefin=
ed
In file included from arch/x86/include/asm/percpu.h:44,
                 from arch/x86/include/asm/current.h:5,
                 from arch/x86/include/asm/processor.h:15,
                 from arch/x86/include/asm/thread_info.h:22,
                 from include/linux/thread_info.h:56,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:12,
                 from drivers/net/wireless/libertas_tf/main.c:10:
include/linux/kernel.h:376:1: warning: this is the location of the previous=
 definition
In file included from drivers/net/wireless/libertas_tf/cmd.c:12:
drivers/net/wireless/libertas_tf/deb_defs.h:12:1: warning: "pr_fmt" redefin=
ed
In file included from arch/x86/include/asm/percpu.h:44,
                 from arch/x86/include/asm/current.h:5,
                 from arch/x86/include/asm/processor.h:15,
                 from arch/x86/include/asm/thread_info.h:22,
                 from include/linux/thread_info.h:56,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:50,
                 from include/linux/mmzone.h:7,
                 from include/linux/gfp.h:4,
                 from include/linux/slab.h:12,
                 from drivers/net/wireless/libertas_tf/cmd.c:10:
include/linux/kernel.h:376:1: warning: this is the location of the previous=
 definition

Presumably this is caused by the merge fixup I did that explicitly
includes linux/slab.h before deb_defs.h.  So you may want to try a
different merge fix.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Apr_2010_11_28_42_+1000_+3+63NX9bx67tWzz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWPcoACgkQjjKRsyhoI8zlnQCfdgoWmKbsMm5zJWvcHljWUtO8
mlIAnjmoL37V6N5lbJIwqvLoyjIiE4FD
=ZAbZ
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_11_28_42_+1000_+3+63NX9bx67tWzz--
