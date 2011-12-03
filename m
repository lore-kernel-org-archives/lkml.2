Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab1LCBtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:49:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab1LCBry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:47:54 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=i9mJVuLNXSAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=YOHAqSSgXUB0i1AXnCkA:9 a=3AQ5DN9QyJt3oUb-8IIA:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=1h-3lTIDcidjld8kdYoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111203014750.893516213@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Dec 2011 20:46:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH 06/10] pci: Use __wake_up_all_locked pci_unblock_user_cfg_access()
References: <20111203014641.165123482@goodmis.org>
Content-Disposition: inline; filename=0006-pci-Use-__wake_up_all_locked-pci_unblock_user_cfg_ac.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Thomas Gleixner <tglx@linutronix.de>

The waitqueue is protected by the pci_lock, so we can just avoid to
lock the waitqueue lock itself. That prevents the
might_sleep()/scheduling while atomic problem on RT

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/pci/access.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index fdaa42a..1a6cc67 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -441,7 +441,7 @@ void pci_unblock_user_cfg_access(struct pci_dev *dev)
 	WARN_ON(!dev->block_ucfg_access);
=20
 	dev->block_ucfg_access =3D 0;
-	wake_up_all(&pci_ucfg_wait);
+	wake_up_all_locked(&pci_ucfg_wait);
 	raw_spin_unlock_irqrestore(&pci_lock, flags);
 }
 EXPORT_SYMBOL_GPL(pci_unblock_user_cfg_access);
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO2X/HAAoJEIy3vGnGbaoAYXcP/iyibNXKUKbQCG7v/3VS/pmY
AB+O/bGv4FX7t5vyj06SHK3bLD2kyzonYQXhw11Ni7A7NsSowkonkIvxnrlb/eq2
nhAp+Oj1RSsD7R4H+rCIHdJdy4kRqRgtFfUhuMqANhJJg0chDAsrjqQGMbloPnc/
lisGco7uhQxSY1h82HHB1z9RdypUi18nw4ebDc0q9o2/j0WfLbOYIpvql6Q/p4Tf
waXpvxD/BaceEQvMEzSEBElfyoWCeULITRd1sfEP7InnWm21x3x7hl1ztNxyN+hS
1KgkIFMYmIa0u59l6IPy3e0GAIeilx2/G9peKXu+hCMBzy0t+rF38yAMyoFAor2i
DfkIpZmzIbst+CLw84XNWZKKFKMDk3TH3WTMlpbf93BPHlHJ1ktl5BCJJz8LJcYX
jip0ggcK3KRZ9i8UJMNYjmiIOQIiC698r+nhOmJh+U8DmvG1lhzim/ZgixLq/M+x
4/YNG8kKAyb2aBO9aW3Exkz3aGsqOjMQQeUzH6PnLTCtcVzBJnoBZizXejGbWdZ6
Y9RQNCdnLd88dhQa9P9bDJer8jyDqXYlvK66X7Bq2vd22Yx8AF+Ds1dBpz8l+JqE
CFY1sAizN00L+WN8bzLATJGMp5Wm2NVfwQveGz19+Kn1BOm7t2EHWBNh8C4+ozC8
Nkn9O6b/x+ybJ8V1wnjh
=1rjQ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
