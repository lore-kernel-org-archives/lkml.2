Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1JKIjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:39:51 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:35112 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1JKIjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:39:49 -0400
Date: Tue, 11 Oct 2011 19:39:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20111011193938.70fd2fa761dfb1f3865190e7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_19_39_38_+1100_m/IRUSwSoXa+L_5Y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_19_39_38_+1100_m/IRUSwSoXa+L_5Y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64 allmodconf=
ig)
failed like this:

arch/x86/kernel/nmi.c:195:1: warning: data definition has no type or storag=
e class [enabled by default]
arch/x86/kernel/nmi.c:195:1: warning: type defaults to 'int' in declaration=
 of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
arch/x86/kernel/nmi.c:195:1: warning: parameter names (without types) in fu=
nction declaration [enabled by default]
arch/x86/kernel/nmi.c:208:1: warning: data definition has no type or storag=
e class [enabled by default]
arch/x86/kernel/nmi.c:208:1: warning: type defaults to 'int' in declaration=
 of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
arch/x86/kernel/nmi.c:208:1: warning: parameter names (without types) in fu=
nction declaration [enabled by default]

ERROR: "register_nmi_handler" [drivers/watchdog/hpwdt.ko] undefined!
ERROR: "unregister_nmi_handler" [drivers/watchdog/hpwdt.ko] undefined!
ERROR: "unregister_nmi_handler" [drivers/char/ipmi/ipmi_watchdog.ko] undefi=
ned!
ERROR: "register_nmi_handler" [drivers/char/ipmi/ipmi_watchdog.ko] undefine=
d!
ERROR: "register_nmi_handler" [arch/x86/oprofile/oprofile.ko] undefined!
ERROR: "unregister_nmi_handler" [arch/x86/oprofile/oprofile.ko] undefined!
ERROR: "register_nmi_handler" [arch/x86/kernel/cpu/mcheck/mce-inject.ko] un=
defined!

Caused by commit 9c48f1c629ec ("x86, nmi: Wire up NMI handlers to new
routines") from the tip tree interacting with the modul.h split up.

I have added the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 11 Oct 2011 19:36:20 +1100
Subject: [PATCH] x86, nmi: include export.h for EXPORT_SYBBOL

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kernel/nmi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 7ec5bd1..b9c8628 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/hardirq.h>
 #include <linux/slab.h>
+#include <linux/export.h>
=20
 #include <linux/mca.h>
=20
--=20
1.7.6.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Oct_2011_19_39_38_+1100_m/IRUSwSoXa+L_5Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlADKAAoJEECxmPOUX5FEvXgP/jew1HLnwwiuqB4F/1yws4aJ
IzvIdHk9/LOHUyOm2IW6TqiWDlfYDoIZBOmAIIYeM2I65H84pkgGgMqv54lyA8wl
5TytX8G+PC8mGmhyvtFJFenM7IDXLvo912B0pSoTVuS0+QeK4jiA5+5rp/ExQq48
eNj3+8PEtfpHAoIzyUwIGdcFSVdLs2X/9J2zGf30eMoUxzgmO4eKsHZxaqIWRW0Y
t+R6ORltLArev5Ro6u5Nm3zYwoHSZF5BbX2HN9A+qgSaR/BREYWv/hO4Pvq5ney0
1H3XRZ6esvlF//XskUJQBSurC/NyL1X8AQPybrSUzbMLaPeeqHnLoIEm59XAEgcZ
K8EvybVaE7RuuSKL8Vf6tAXY/aC9kQUsMd7YLonq2KAUSi2E/tJ/Z99SSUtfqOS1
1FYBYX0jhIGJ3PHVgBMLEf21EImmTwOABeGWZV108+28/fPEy2bNQoYNhjms3tzQ
B+SZZWk/tporMVXkLZYaFXx35NQOMRaZf/Hd7kYYYEEDtoG9oE0ZeXyRq7l0eAJg
h9xwVCWzYmXWblOpxCFxbxlVr/Av5hvfGGE7oj/cIO4qYZYVt9C8bpC8kPLUUIBF
dlOn6KvrYDAHQ8R6pdonsmkVQTtZntZSHlw0vL4tgK2i2H85yTJgjsThL0jhGHVE
S/ofvBqVFTuZ9luocnLh
=4m13
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_19_39_38_+1100_m/IRUSwSoXa+L_5Y--
