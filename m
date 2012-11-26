Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2KZNt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:49:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54118 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2KZNt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:49:58 -0500
Date: Tue, 27 Nov 2012 00:49:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>
Subject: linux-next: build failure after merge of the final tree (tty tree
 related)
Message-Id: <20121127004948.6e7973525843529de827ed0e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Nov_2012_00_49_48_+1100_CClVwNa57Ge.v0TK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Nov_2012_00_49_48_+1100_CClVwNa57Ge.v0TK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/staging/sb105x/sb_pci_mp.c:1:0:
drivers/staging/sb105x/sb_pci_mp.h:22:25: fatal error: asm/segment.h: No su=
ch file or directory

Caused by commit 68a81291ff66 ("staging: Add SystemBase Multi-2/PCI
driver").

I have disabled this driver with this patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 27 Nov 2012 00:45:07 +1100
Subject: [PATCH] disable the SB105X driver

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/sb105x/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/sb105x/Kconfig b/drivers/staging/sb105x/Kconfig
index ac87c5e..c957e32 100644
--- a/drivers/staging/sb105x/Kconfig
+++ b/drivers/staging/sb105x/Kconfig
@@ -2,6 +2,7 @@ config SB105X
 	tristate "SystemBase PCI Multiport UART"
 	select SERIAL_CORE
 	depends on PCI
+	depends on BROKEN
 	help
 	  A driver for the SystemBase Multi-2/PCI serial card
=20
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Nov_2012_00_49_48_+1100_CClVwNa57Ge.v0TK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs3N8AAoJEECxmPOUX5FEDCoP/2nFFfoyVTxxKjC9H7fOsmoI
MSyq/JKVoIH5+VpSrtcUNJkuA0c2kcGaB0Q4iHMkM1Z3rqQPAiyFKfeqPWiVwjEV
J6ymZrTqpvqVp1vXKtjqUZrDSNlvoFI22sy/H3vl9t4qCKQeY+SQvRD8ZyG1bjkq
NbekruE2xkxXHBovbxWjnw4kNgN6czuzrgzUZkMnO2BLBnD05FSq2ILJyJWSQxjf
vlop7WAHrYxwkc37iutz1Mcsegl4bquWGwqX+L42Ri+P9+DCL9bmRNEQ37blMJ8i
pyJWV79HCxRLbKJidHvWnMxXOZiI1rfGK+RuZMZl0s/NcyeiKNz0lMUHuOm9P3Mg
HfK6Tm3TYNGebEB+3Ng4uEABiV/RmFQi9zAe/SfKUneMixRXawVzJxpqZVB15+qt
2fwFsCW+wtt5XA11lLKjdD11uSh9YLl0G+KH6wg5rYmNe8oNOHphmap0OsSP+wji
xOiKrSt1T2wzgvExEj42+4spUjsWRNVxnp5I7+15MF2g+SSA86e5jEnfMYeFjIBr
gbf+PDlLdVzgne5zVvk/BtzKaVdxOjXzJ5ZBPdIAJZZp25UQ9a428gs7A93bZe+J
7k1DtfvNqVh0O09JifDWSBw7KSh8YLtu/PWUS7b8h7lVJbVVk7WV9fw2xub4+Rii
OyfcKsL9q54QJmMQEYKZ
=S2/X
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Nov_2012_00_49_48_+1100_CClVwNa57Ge.v0TK--
