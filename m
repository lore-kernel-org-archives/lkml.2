Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab2CHEVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:21:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50111 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2CHEVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:21:38 -0500
Date: Thu, 8 Mar 2012 15:21:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20120308152110.12c805f59c45251d79bcb24b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_15_21_10_+1100_B+njd011uXjCRhbj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_15_21_10_+1100_B+njd011uXjCRhbj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/staging/sep/sep_driver.c:55:32: fatal error: linux/rar_register.h: =
No such file or directory

Caused by commit 33e9970add94 ("x86/mid: Kill off Moorestown").

Following previous instructions, I have disabled the staging tree driver
using this patch (pending a fix in the tip tree):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 8 Mar 2012 15:15:44 +1100
Subject: [PATCH] staging: disable the sep driver due to breakage

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/sep/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/sep/Kconfig b/drivers/staging/sep/Kconfig
index 92bf166..cd95ca2 100644
--- a/drivers/staging/sep/Kconfig
+++ b/drivers/staging/sep/Kconfig
@@ -1,6 +1,6 @@
 config DX_SEP
 	tristate "Discretix SEP driver"
-	depends on PCI
+	depends on PCI && BROKEN
 	help
 	  Discretix SEP driver; used for the security processor subsystem
 	  on bard the Intel Mobile Internet Device.
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Mar_2012_15_21_10_+1100_B+njd011uXjCRhbj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWDO2AAoJEECxmPOUX5FEPzAP/iMpLDf0cwQpAJT4q93e5iKj
nynK5CNa3Vip7sBIJRwRWx4SXx79t4r6gYLLGr2ms2WZEd/V43d98mgdJdWGD4lY
hI+JbnElTs5AhiFzJPT6RWC+BoBowdKzDD7zxh9PUwB7ZY7pv/oAa48bhr5yfsXc
UVzN94OwfQY47E18MPcd2ARPbt2ZMV6IzSmo9htgEjnJKybo2H6zYT4U8l6a1AdP
W9YJ4pQktIbPUrFualleYZfzp9viGeBfzWRagA7xZFG1PrICh3VbseJJq7AX/owD
rxAkOIm3hT24Il5yYxJFGB1mdfVmo8bstVhy1Y2xzSC1nnygeRnwH8WMz9+P3/ea
PAw+81vxzsSy16Mj74Jf2LlzhZ1vQmAGWcB9NYV8EaZqSexMA+jdi3ktCxz4q0yD
hdKg/kiSbdD07layMX9xfw3gG7afIi87xyFn9F7tG4FUHbCCRGomdRyHzYPEZMRd
bd/yHsQqqNND8CZg8RMlWixkWVjO68VafDnX8wDKqUjZ9cmo/dl1xxIs+rEtRqGL
avx+0Ud/+98YhFyJF/CPTyWwnUMH24/HCJt7962eriE29TFxlW9e4Y3eMxP/v3Hr
4u7ZJAWUvNemsAHNpknvE8B+n2oN5YrqBloS0nOp+xTIS+BlCObAcoTQEpAN+ffU
h6LaLefJSDQJ4+p/PAEN
=TQyi
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_15_21_10_+1100_B+njd011uXjCRhbj--
