Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab1KCDdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:33:10 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:53775 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1KCDdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:33:04 -0400
Date: Thu, 3 Nov 2011 14:32:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-Id: <20111103143256.216308862667829a1fccfdf2@canb.auug.org.au>
In-Reply-To: <20111103125325.c1e20275e3a68498465b5ddf@canb.auug.org.au>
References: <20111103125325.c1e20275e3a68498465b5ddf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Nov_2011_14_32_56_+1100__d=ZxQKzkFzmqTDc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Nov_2011_14_32_56_+1100__d=ZxQKzkFzmqTDc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

On Thu, 3 Nov 2011 12:53:25 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the pci-current tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/pci/ats.c:13:26: fatal error: linux/export.h: No such file or dir=
ectory
>=20
> Caused by commit 571eba1b8aa9 ("PCI: Fix compile errors with PCI_ATS and !
> PCI_IOV").

I have added that patch as a merge fix where I merge the module.h split
up tree.  (Included below for Paul's benefit.)

From: Randy Dunlap <rdunlap@xenotime.net>
Date: Mon, 31 Oct 2011 10:31:01 -0700
Subject: [PATCH] PCI: Fix compile errors with PCI_ATS and !PCI_IOV

For linux-next (where the module-split tree is being worked),
drivers/pci/ats.c also needs to include <linux/export.h> to fix build
warnings:

drivers/pci/ats.c:96:1: warning: type defaults to 'int' in declaration of '=
EXPORT_SYMBOL_GPL'
drivers/pci/ats.c:127:1: warning: type defaults to 'int' in declaration of =
'EXPORT_SYMBOL_GPL'
etc.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/ats.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index f727a09..7ec56fb 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -10,6 +10,7 @@
  *   PASID support added by Joerg Roedel <joerg.roedel@amd.com>
  */
=20
+#include <linux/export.h>
 #include <linux/pci-ats.h>
 #include <linux/pci.h>
=20
--=20
1.7.7.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Nov_2011_14_32_56_+1100__d=ZxQKzkFzmqTDc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsgtoAAoJEECxmPOUX5FE3SoP/RF1SRYr4wsRgPljVI8aIVa1
t8H8wDpebCRZT5dctRSQUUTEBCqTUE+JgxDI7E9FBNr8p9Hn8LJgIW8H7SPyy7lA
3XXYO1U/lwlZ80IKflXJW5xVPbPpN23E816LqYEVj888SevEtFHM0wJ0yVWZckWJ
BhG7TW1VaEUbjpKOVpkDs7ERwl13w34zoeNu3T+YqVmMujcPFtjq+ypzFTWzuNVS
DksIGlUD7LVC5xk99RQXiO6+aPA3DpBEVTPtGDRnEQQKt3Ql2PQtA2VnNKRFk3qC
4XUFiyzIcwA98OIVX5BhWySag1xAEB0vvZkwYbT7Dlxp3LjXKKWGC5ISPNxOh41s
5a3FnB/zj8UTv8Qah/eJZjS82Vb/ZIsAP2edUseLkQRwR84KNfNKchewwE2kxFLf
2MNCU7FjJS3PgUgR1SYHrg2mLzOCnRPl8jczZzSuoNYVCRApfXIUrqEgk9ockDtB
pa5a3aMT/Qd416vX9nXQtmjNkbx85U40voEMd30L7zabIYruETap8N1GDdfdSxa3
15NdFN1xirbv5jntNw5dCy2QHRs2YbKRYrlS0krThCM9+uCEFn/+dVVQv9FIr6Ir
UzN305xEj7ZswHUDMRVsiSJ1bgWxnJhKltH2GL1hYfWOU+RskDdok5fbyMwd+b1o
HvmG0YcmXqkQ5y+vhkwQ
=JxjM
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Nov_2011_14_32_56_+1100__d=ZxQKzkFzmqTDc--
