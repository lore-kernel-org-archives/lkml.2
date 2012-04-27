Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab2D0F7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:59:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53081 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2D0F7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:59:17 -0400
Date: Fri, 27 Apr 2012 13:29:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Daney <ddaney@caviumnetworks.com>,
        Will Drewry <wad@chromium.org>, James Morris <jmorris@namei.org>
Subject: linux-next: manual merge of the tip tree with the security tree
Message-Id: <20120427132934.1b8417677987f817797485be@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Apr_2012_13_29_34_+1000_0vXJVwHi8EBXZogR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Apr_2012_13_29_34_+1000_0vXJVwHi8EBXZogR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/Kconfig between commit c6cfbeb40296 ("x86: Enable
HAVE_ARCH_SECCOMP_FILTER") from the security tree and commit 8b5ad4729917
("Revert "x86, extable: Disable presorted exception table for now"") from
the tip tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/Kconfig
index 3a41c44,83db6b9..0000000
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@@ -82,10 -83,10 +83,11 @@@ config X8
  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
  	select GENERIC_IOMAP
  	select DCACHE_WORD_ACCESS if !DEBUG_PAGEALLOC
 +	select HAVE_ARCH_SECCOMP_FILTER
+ 	select BUILDTIME_EXTABLE_SORT
 =20
  config INSTRUCTION_DECODER
- 	def_bool (KPROBES || PERF_EVENTS)
+ 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
 =20
  config OUTPUT_FORMAT
  	string

--Signature=_Fri__27_Apr_2012_13_29_34_+1000_0vXJVwHi8EBXZogR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPmhKeAAoJEECxmPOUX5FEKJsP/jcuIKm/zYFDx4hdZSHQqwbB
5vMdBF1Fam4i3mEo3E3Kg1/9EIGVv32Nt+EHD3eTSEiLBuglN9wO4C4SjZUgN78+
NYBMG7qmMCI3bIzaKpUcyaXSP90YH9JUYn7Y9/PeLEwWGQeAV+XDGdTnX+94dfG1
6b9WC/loxGeUpm7TcFKhA0f5uzpULi2pyzP5vmiTxY7kPD0GOLubGYJmj2UgTXWn
URgwrAUghuwr19caV9YB1sXx92UwDyNIX3hyp9pn7IWvhvDsuQR0gtIls6t5Wr3B
iZSPpD8pRkNOo6EwHca9T7IWjJZ2fYsG69AL1vI/qsEJPFuh0yWQYH3oc/HtMFcO
vnYBBiqBhTLFbywu+9qRpR+nMWNBYOoQ0OQJS9m6xsBzKql/4e990RFcj9vGlNN9
O+NzDDnbV6es7bOfAgyVDl9oNUUatRBO5GBdnD7/jSOYCSy8u9BWNpzp6t+6PnKR
F74FCMkuUuiSWXq1tMjP76dsR/t1N/8nvU+12WORL6BOUA1iFk4F05FyypxqH0fq
pWpZNwMXouabzUGqeOfSi5AkHj27paU8svJA2oGGNRVNGQarQgQPqNszgeeG7e3W
IXT262uJeHiHGIxiC5vuyrapSmoULsSXkMqFw6pmmzraOq2gYZw2qS3tyzeC5gyW
so1U1uMDiXIJEWwNUJWs
=zdIp
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Apr_2012_13_29_34_+1000_0vXJVwHi8EBXZogR--
