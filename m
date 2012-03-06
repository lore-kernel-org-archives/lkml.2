Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab2CFG65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:58:57 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48410 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2CFG64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:58:56 -0500
Date: Tue, 6 Mar 2012 17:58:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>
Subject: linux-next: build failure after merge of the final tree
 (moduleh/trivial trees related)
Message-Id: <20120306175844.9c97ac3bcc5579fba377fbd8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Mar_2012_17_58_44_+1100_yIbUTb7VfX_abN4w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Mar_2012_17_58_44_+1100_yIbUTb7VfX_abN4w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/power/max8998_charger.c:198:12: error: 'THIS_MODULE' undeclared her=
e (not in a function)
drivers/power/max8998_charger.c:207:20: error: expected declaration specifi=
ers or '...' before string constant
drivers/power/max8998_charger.c:208:15: error: expected declaration specifi=
ers or '...' before string constant
drivers/power/max8998_charger.c:209:16: error: expected declaration specifi=
ers or '...' before string constant
drivers/power/max8998_charger.c:210:14: error: expected declaration specifi=
ers or '...' before string constant

Caused by commit 13ae246db4a0 ("includecheck: delete any duplicate
instances of module.h") from the moduleh tree interacting with commit
ce64b8d85de9 ("power, max8998: Include linux/module.h just once in
drivers/power/max8998_charger.c") from the trivial tree.

They both removed different includes of module.h leaving none.

I have applied the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 6 Mar 2012 17:56:45 +1100
Subject: [PATCH] power, max8998: we need at least one include of module.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/power/max8998_charger.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charge=
r.c
index d6a8c16..5c5f281 100644
--- a/drivers/power/max8998_charger.c
+++ b/drivers/power/max8998_charger.c
@@ -19,6 +19,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  U=
SA
  */
=20
+#include <linux/module.h>
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__6_Mar_2012_17_58_44_+1100_yIbUTb7VfX_abN4w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPVbWkAAoJEECxmPOUX5FEbMcP/3W4NvCfqcP4vBjEFNf8r1Cf
ebm0RD5d2LCRe42F8el37TILpwHluPgnoIIfOD88jOvy8DqkfxA2XNx9dB/1F1Wx
QWazR0j/ArebnIXBucCchHuXtySJ8FkOEmEexR9zNhyEWZcNHZLRmYpzbgQxchpJ
ocGbW12epO6U8zrExv7qlnNff5+FBarm1RQXaYOf5OvqPVF8iXTAYPpKMIic0o0I
3xIinW/fSaJUox4sBDXZq75GP7i+d+406Jwd6U0/rBozLpu3HtyLgMOPALiQ3cZO
MPYG4zbUWYr/lBg4RK7RuDGjPuqjrUbjxjU004gYRv9fhJBqjLH4bMvCrRL15TZQ
fEOd0oJ2KSCfSGzgbdd2g2qXd3575tjw7wdNK9RjMeMRa11Ks+2RWYfjp3yBgPy+
8t/hVCV9nVxzFbBQW5RixtPwFnx8kI8r6ijcWl9Ln1oF4ZSF5Q3cPZNuFVDZbekw
bJ13UhDvjQZ3JeNrJB3LB+L/SSigpSoLWKb+7Idr5DUZ4zG/Sj8Gm23gwutQOBeg
9zU2yAYRzUy/byOKOenFqtGH7jvYD1CdWhSQXWSPa4qtgNL2Qw4O1stcr0N/GaVO
+gownXsA6r4HjD48XmRj3uSo/+7iShkkONyZNtiZx8nQ1NUaeefzs/Yi92RUdlSh
/nHn3yr2fsx6Dn+mCB1I
=accg
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Mar_2012_17_58_44_+1100_yIbUTb7VfX_abN4w--
