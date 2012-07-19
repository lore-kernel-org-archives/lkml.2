Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab2GSHIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 03:08:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50072 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2GSHIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 03:08:38 -0400
Date: Thu, 19 Jul 2012 17:08:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20120719170827.32067d18457dc0e6c3b644f5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Jul_2012_17_08_27_+1000_dbBnw_bv.6jeF+5u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Jul_2012_17_08_27_+1000_dbBnw_bv.6jeF+5u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/staging/sm7xxfb/sm7xxfb.c: In function 'smtcfb_pci_probe':
drivers/staging/sm7xxfb/sm7xxfb.c:829:33: error: 'smtc_screen_info' undecla=
red (first use in this function)

Caused by commit 013db67415d1 ("staging: sm7xxfb: rename smtc_screen_info
to smtc_scr_info").  Grep is your friend.

I have added the following patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 19 Jul 2012 17:04:39 +1000
Subject: [PATCH] staging: sm7xxfb: fix for "rename smtc_screen_info to smtc=
_scr_info"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/sm7xxfb/sm7xxfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/sm7xxfb/sm7xxfb.c b/drivers/staging/sm7xxfb/sm=
7xxfb.c
index 90c90db..1c1780c 100644
--- a/drivers/staging/sm7xxfb/sm7xxfb.c
+++ b/drivers/staging/sm7xxfb/sm7xxfb.c
@@ -826,7 +826,7 @@ static int __devinit smtcfb_pci_probe(struct pci_dev *p=
dev,
=20
 #ifdef __BIG_ENDIAN
 	if (sfb->fb.var.bits_per_pixel =3D=3D 24)
-		sfb->fb.var.bits_per_pixel =3D (smtc_screen_info.lfb_depth =3D 32);
+		sfb->fb.var.bits_per_pixel =3D (smtc_scr_info.lfb_depth =3D 32);
 #endif
 	/* Map address and memory detection */
 	pFramebufferPhysical =3D pci_resource_start(pdev, 0);
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__19_Jul_2012_17_08_27_+1000_dbBnw_bv.6jeF+5u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQB7JrAAoJEECxmPOUX5FE7tcP/3W6zNTFzzrV6EsuWnJlNih2
ozZCBH7L7K0IuTJ78seAUanAiUWzOQwN6FgGjxKW654huPkUZ5WWpsPXKcNdUyB1
mQ5FkQyXkZb6zpG0ogMRGuu82IqXU6TOftF/5ytN5r/FfDZcZ8vVXs0+1iHth4eH
yRUktutDpOyrxmaARVkGjZlOh9jdlXM7pxRcb0BAMV11goWg5RSuC9Dm/88QBayv
fPGeEkh6zkXciCQIgpCVrg03M/MZc0aLJ2PRpIhIoZb69v0GgAwyB0Hdy7myeKZX
ZP1lX3zt42Fptymih3JSuJeyY1P9oqCcfQa61H/GMaviV4bLmgXir0d+W9xgmph0
bb8bgAaTE420f0z1soIkggfzy3mooOdrfyA3pl8O3NiPKKOTWHAHwmHjNvpt2biw
vrRUaXo+D1/O86bKobgbSc0oW5yWofN7YHDD/JBPJ4NABA0Bn8v75zdrg5LgMt6p
3dvvt7L0DVNIyTFrRWorruItkZ9Q31IPEQwZyJAEhC8WwtMDTpcHwSlSrjrDk9zd
rNiN1dRefQoPfgLdfwp/Vqdbh815+H+JwmleD0B+SExH084mmcAPIcJ0IasQ8nTU
SV4yzC4JF7uGb/tb07FUgc0bgvgu/LQZGCoG/fUBMnsiLXaotW51ystbRRQJZtFa
b2REG7CB6ImSiGC6sEDA
=aghW
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Jul_2012_17_08_27_+1000_dbBnw_bv.6jeF+5u--
