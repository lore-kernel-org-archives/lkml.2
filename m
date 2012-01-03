Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091Ab2ACFQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 00:16:45 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58501 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab2ACFQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 00:16:43 -0500
Date: Tue, 3 Jan 2012 16:16:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Schwab <schwab@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20120103161635.9ca6b528c313cf459bdf6de2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Jan_2012_16_16_35_+1100_btvs77wHoPR=ABej"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Jan_2012_16_16_35_+1100_btvs77wHoPR=ABej
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got conflicts in
arch/ia64/include/asm/cputime.h and include/asm-generic/cputime.h between
commit 34845636a184 ("procfs: do not confuse jiffies with cputime64_t")
from Linus' tree and commit 648616343cdb ("[S390] cputime: add sparse
checking and cleanup") from the tip tree.

I did the obvious fix up (see below) which may not be completely correct.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/ia64/include/asm/cputime.h
index 5a274af,461e52f..0000000
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@@ -58,9 -46,10 +46,11 @@@ typedef u64 __nocast cputime64_t
  /*
   * Convert cputime <-> microseconds
   */
- #define cputime_to_usecs(__ct)		((__ct) / NSEC_PER_USEC)
- #define usecs_to_cputime(__usecs)	((__usecs) * NSEC_PER_USEC)
+ #define cputime_to_usecs(__ct)		\
+ 	((__force u64)(__ct) / NSEC_PER_USEC)
+ #define usecs_to_cputime(__usecs)	\
+ 	(__force cputime_t)((__usecs) * NSEC_PER_USEC)
 +#define usecs_to_cputime64(__usecs)	usecs_to_cputime(__usecs)
 =20
  /*
   * Convert cputime <-> seconds
diff --cc include/asm-generic/cputime.h
index 12a1764,77202e2..0000000
--- a/include/asm-generic/cputime.h
+++ b/include/asm-generic/cputime.h
@@@ -38,9 -23,10 +23,11 @@@ typedef u64 __nocast cputime64_t
  /*
   * Convert cputime to microseconds and back.
   */
- #define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct)
- #define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs)
+ #define cputime_to_usecs(__ct)		\
+ 	jiffies_to_usecs(cputime_to_jiffies(__ct));
+ #define usecs_to_cputime(__msecs)	\
+ 	jiffies_to_cputime(usecs_to_jiffies(__msecs));
 +#define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
 =20
  /*
   * Convert cputime to seconds and back.

--Signature=_Tue__3_Jan_2012_16_16_35_+1100_btvs77wHoPR=ABej
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPAo8zAAoJEECxmPOUX5FE4xAP/1TyHQcEnSlyIi1ZBmO+DW+v
9O4qkkMXHaooK057Z2vYm84XHu63F+slKDx8aokR4oYYpydPlIrhJ//AQN6kfoZK
S12RptX0baxW+oQIlHg894QjMHLbrOtbr9XBJvde8ORbA0LSI1Gc88Xkefmb+D2G
58FZj6thjj5BH/6H0Jdubqxf/ALPVoEWuYw2RA0WgUVAlihjigq48OqnyM3fI0Al
3X7fn1pTY68yHpENAxL1g5o24SMKsyVsQw/tIBA/4qbJz5/bTrFnfYQbZwyfORhS
1tSrhlbO3unaQ+CtexbNi6gv6kD3c4qUC7/xr2zwxD8yB5IeOLYSnncwY+O7dTfN
3QYn/XPIkAF/D/mjt+gttcaIBNSMKY9tb9alyLmHmw9HpRVz0aZ0UlJQNrN2aBTJ
I/eCJHl9w4LbLRk8s9iSlLtThuGATAEILat5XCFGe6Cbt1C0d5NljU6rU1DO/rWc
RQzs7V+dgM4c5Pc3pqyt61l0qKEZm0URIac++3PM+okTVyzkDKXEsNL3Nn8Rk9Lm
kDb0JdeWl1JO9N3YYumnZTiy3McBiHa2Ql38YO2PsarpIWSoLKi+ouM761H9mcCb
LeoaYLZaUBDALcRjslldVr3D9xYrDEiSXb6GkEG2VshIBDLgebUYNsbgpv5AvGc4
pEcW+lO+4KDvneILQa0V
=DDTR
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Jan_2012_16_16_35_+1100_btvs77wHoPR=ABej--
