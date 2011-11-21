Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab1KUVtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:49:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40631 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab1KUVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:47:59 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=oExj5NFNAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ZJ4H0Wm7EEmHzjUgDusA:9 a=MkRGjL1ZTNgiexsqep4A:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=r0HesoeFUbUA:10 a=jeBq3FmKZ4MA:10 a=33_AH1Q-f3xCRiH1Q6YA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111121214757.011122160@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 16:44:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH 4/6] dm: Make rt aware
References: <20111121214420.124907956@goodmis.org>
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

iQIcBAABAgAGBQJOyscNAAoJEIy3vGnGbaoArT0QAMCOfUGTII7e/zGSTAlJU39H
IJEBnrMoa3+vwQLf6q9nImKKXG0JKNd9sRq5a95BQGFze/gvADy90XxULyIMVSWs
7BG9djvT7eI57IWrmfwF1SioSzhblmdBZWt+embm7lkuvU7EkQbWUR+mQrtgpxhS
ZeHgJOrZv6giymRjCi7jq4JqMy3Rbozqa7iiSyK+YbIJx/C7DNfN4exjvsOYMLmQ
GLy6SyfJxawZHSeIWSA5Yl8czHV9Xzfr/UDk3o2PuMwjdFpjN5TKbl3WB7ioxzil
Tpjg/amOjx3IPROh3qwexiXEZ2O0JXNhxq+xRmMYCaDNGwXxmBSSlqIducm46xUN
eKMr02UlrdwxivxbBXuEIPCyXDFXrdbdNBCsgw8phb0MHpiRNipeSSpXs9O0bmWV
Z2xPj2wIEnaIu41yf/D8g8gCJqeUkhn2wOE4G7r5djPU1FIU5tGg3UkWSjWdqtLX
clwmghPmzVY3ouOr99n1zwfzqjD/P5E0eVYKnrXufOmJ6ENEn8w+KrlnoJen+A/l
K7E58B3R53q/0tY/OfMSwwBKkrjqcKjDMQmmy4zARBUTP33hRWDkJ6wgV6yJH5Zm
9p3NxA5GcgZt6ZIfkORGEGXpwwllhznJ/fhZwQSZfYC8urekdIFSdaoxb4GbH2C8
lasMS9ljWpLhWibFGbYt
=eyKO
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
