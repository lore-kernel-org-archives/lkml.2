Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0ICCKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:10:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33751 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab0ICCKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:10:31 -0400
Date: Fri, 3 Sep 2010 12:10:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Wu Fengguang <fengguang.wu@intel.com>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20100903121023.54c40e73.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Sep_2010_12_10_23_+1000_gcCRMN1o+E_/FceV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Sep_2010_12_10_23_+1000_gcCRMN1o+E_/FceV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

arch/x86/mm/init_64.c: In function 'kernel_physical_mapping_init':
arch/x86/mm/init_64.c:601: warning: 'addr' may be used uninitialized in thi=
s function

The code does look suspicious ... 'addr' gets declared and then passed to
a function, but is not set anywhere ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Sep_2010_12_10_23_+1000_gcCRMN1o+E_/FceV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMgFkPAAoJEDMEi1NhKgbsiooH/2TMG+1wYhwoefqLM22Y56WR
kEh0AfjeJYQKtgczSroHr+2350RZx6ULG1BpwqAHLQvWk9sh0QXbcYaKZZRZyEWv
W93eqly9v2Ou1f2YjjDnFSEoog3VmHhNGkM3MSqlbV+azU7vZ4pGYJtQBgSd9ORM
s082FiBHhTP/ybBT0776hv7Gd/ktgbGD+BeQSG3R/egoEtRF0l0/Yk0MKrvpv9ue
XDL15Jdu6/NM+8QhTAh6KiMu+ivWar+o/iROomhc7XxNJwV+NGBI3RW3vO/5j935
j/sNJKx3MC1uMRcNDDYp1aZlPgFjQbKxA48G5X9ijAw30zR3MKxYxVhaacbfM0U=
=yvmS
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Sep_2010_12_10_23_+1000_gcCRMN1o+E_/FceV--
