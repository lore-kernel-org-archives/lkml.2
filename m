Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab1KSEtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:49:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57840 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758105Ab1KSEsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:48:39 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=oExj5NFNAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ZJ4H0Wm7EEmHzjUgDusA:9 a=MkRGjL1ZTNgiexsqep4A:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=r0HesoeFUbUA:10 a=jeBq3FmKZ4MA:10 a=kGtmERc5gN6jHbV-DzYA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111119044835.609032911@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 23:45:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH 4/5] dm: Make rt aware
References: <20111119044510.811163517@goodmis.org>
Content-Disposition: inline; filename=0004-dm-Make-rt-aware.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Thomas Gleixner <tglx@linutronix.de>

Use the BUG_ON_NONRT variant for the irq_disabled() checks. RT has
interrupts legitimately enabled here as we cant deadlock against the
irq thread due to the "sleeping spinlocks" conversion.

Reported-by: Luis Claudio R. Goncalves <lclaudio@uudg.org>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/dm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 41abc6d..67207d6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1644,14 +1644,14 @@ static void dm_request_fn(struct request_queue *q)
 		if (map_request(ti, clone, md))
 			goto requeued;
=20
-		BUG_ON(!irqs_disabled());
+		BUG_ON_NONRT(!irqs_disabled());
 		spin_lock(q->queue_lock);
 	}
=20
 	goto out;
=20
 requeued:
-	BUG_ON(!irqs_disabled());
+	BUG_ON_NONRT(!irqs_disabled());
 	spin_lock(q->queue_lock);
=20
 delay_and_out:
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOxzUjAAoJEIy3vGnGbaoAmV4P/2Z616vgSJXD0NLmviFphzp2
rq0iPHZkSgq9xLDXbPOLdTjpar4QdJ+nl5nr/g4sqeNneorKzoTBFF5PV2U6fOrG
dKZPu1YjYaf+1AnJhja1kEJBU4ZsuPRGsA78TCVXXrr+Nudc/SyRJfBaH50r0iiP
CbMMLGRYBiyWZHK1nacB6c6n1uvdj5X5KnuDxPDFi8Q2CcmBoAyJT87t4QSdeLnd
jKppshVsLW/VJ7rR2vxr2T0TLAXo14ml5yDI4ijSsrO44uQQxRNh8QjU08YafFsO
MZGFVW8+GdcUegUqSgN7dtGmLOrtyi0lCMLMLhjA1H1QSjIFSc6VaYFdf1B3bcjs
yxoCNBDXqHsql29viVMbUZ20n8ejeMuxp9R1GYPVHzuJS8afZoUMqqhLIWkcl/d3
QZfIQPnXSIBEw2ThTMMUDxEgnpQN+GUBrUDuKD1nG0oKRHu1PhBiqAeFAq7NqyZh
7wFn8E4yZ1f6tQ0sa7iEN1HbwfCNOfZ21qTCvoqePCt8Yjprth/Wx+RmONuz2qiT
uZRRorWA+worGcUWfRO/k8IkVGU5gYY1W9kVQ6yunJt+SzfI/5o1FPJVF8qxRSP1
CfVzSrin93RXe4zyLSmRLJhDaxhKpOjzzbzz6/rkVWrJsDuUlM8xV2nnivxyqYeE
O8W1SYXfXFQlJmBkyJAE
=w7Qw
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
