Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2EGFLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:11:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52866 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2EGFLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:11:11 -0400
Date: Mon, 7 May 2012 15:10:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>
Subject: linux-next: manual merge of the tip tree with the kbuild tree
Message-Id: <20120507151054.3fa8df4599e81cc6ae87ca7a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_15_10_54_+1000_P2B03Er+WGLtv0IA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_May_2012_15_10_54_+1000_P2B03Er+WGLtv0IA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in Makefile
between commit 1f2bfbd00e46 ("kbuild: link of vmlinux moved to a script")
from the kbuild tree and commit 1dbdc6f177c6 ("kbuild/extable: Hook up
sortextable into the build system") from the tip tree.

I used the Makefile bits from the kbuild tree and added the following
patch as a merge fixup.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 7 May 2012 15:00:04 +1000
Subject: [PATCH] kbuild: merge fix for sorting exceptions tables at build t=
ime

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 scripts/link-vmlinux.sh |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 26c5b65..7d31f61 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -93,6 +93,11 @@ mksysmap()
 	${CONFIG_SHELL} "${srctree}/scripts/mksysmap" ${1} ${2}
 }
=20
+sortextable()
+{
+	${objtree}/scripts/sortextable ${1}
+}
+
 # Delete output files in case of error
 trap cleanup SIGHUP SIGINT SIGQUIT SIGTERM ERR
 cleanup()
@@ -192,6 +197,11 @@ fi
 info LD vmlinux
 vmlinux_link "${kallsymso}" vmlinux
=20
+if [ -n "${CONFIG_BUILDTIME_EXTABLE_SORT}" ]; then
+	info SORTEX vmlinux
+	sortextable vmlinux
+fi
+
 info SYSMAP System.map
 mksysmap vmlinux System.map
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_May_2012_15_10_54_+1000_P2B03Er+WGLtv0IA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPp1leAAoJEECxmPOUX5FEFBYQAJLS5R2yCnrM9iNOnRePdL/J
e8u16rKzNxSSIAQJsofgupa9ptV5rZ8hyXhmk/KzZCaSyr1NQK/9bNm4XwIGxTK2
svkdVVPXkmJ2L0LmNC0zEIA9puAKMZEVbOJAvp28q7lAIh5aTtBRflozcLfIbcoJ
hkkmm1/GGTRB5eJ8EnIS2BOIqi8/jUSj9Ja9VhYLSTY4EBThwlK41WIzPfqBNCV9
BCrW+3hwe21R4sSNOQpdSnV6UXjJUvZ6f3ujTHe2aDpdKWHzujCnTxF+FGHCc15y
iuM83TcrydWiEYe6J/MROkGvHNWq1VMLy8iBMWeyYK/BXksh8cBtpkl8T8y8V3YW
rGDB2m1K7u5QZrD6TvMUEipsG2u4PpHeOlgnePOwTFwxHIigoVTrsS+zZj2CeUq9
eqlhgMxXvf34S0EX1UkUtIEJsNqDh16B7ROi6oe77RSUFLt3qRRZj7J0M2ZhiaWU
/+JofH2qxYsUpdSoI3Bq13PMUjSw9Y2bi1vdc0EQlBZjGu7t9TdVlnPCSjXhvPjV
i5cqcw7Zn7abtjizLNu3iP9Ii7dVO9ctTP9+VPuM4v9Ut/VhWEYu1jdEcC7Iq9Lq
/k+6z2tm3MUSwYbuToQaAY/B7dQWFisNfZvNVvOC9Seok0TneDlQxi8EpWraCtnQ
g4ajx3kY+3b0V8vUfARI
=S4Zx
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_15_10_54_+1000_P2B03Er+WGLtv0IA--
