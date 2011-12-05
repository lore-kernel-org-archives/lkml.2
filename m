Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab1LEXFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:05:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65404 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932752Ab1LEXDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:03:03 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=QTzyXsBIKAUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=YOHAqSSgXUB0i1AXnCkA:9 a=3AQ5DN9QyJt3oUb-8IIA:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=hnHfUyDwljMgxN-HWvcA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111205230300.044942431@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 05 Dec 2011 18:00:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 07/12 rc3] pci: Use __wake_up_all_locked pci_unblock_user_cfg_access()
References: <20111205230046.736851081@goodmis.org>
Content-Disposition: inline; filename=0007-pci-Use-__wake_up_all_locked-pci_unblock_user_cfg_ac.patch
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

iQIcBAABAgAGBQJO3U2kAAoJEIy3vGnGbaoARiwP/1yaOJEaHYFJX1TFW/vjMHXe
o0NlKOIUW2KqikU8IRUCHzw50ZttFtJ+TkW3ElztGFHYaJWh3GMn0u8fmJoBQpOk
xN5qKdNNaKD5J3QXRlSp0ajT+wkWsrKNQO3X6228JaD6cO4oFC3BwNbpQKcN5ivT
eToN9udRVHgCyFs+1lsASOWDtPV7xgnxLUCMO0vnhNKTZBdSOr/OoGDO+O9hpv86
hvQdzS+VjstgrkvRlLLMsEUKcQq3IAK1PuYlAl/939gMQNQVq/G9Ff/wSKgPgYdf
a9AfpI9mQpUOYSejon7kfWWfpGSZuwn4H/x8BDy9ETs6it6L2nR9mlwBbmkO1eAM
lhYNLi9u4/UDSqLe9rhc3lWWb/LenQsq+wJfD1tbLWYe5jEhBf3lhTneKaA3oL3q
35ZHH3FEmqW67LsrVoyrV8PuoKkK8TkmjPmVpfRYGCVcxUs/zFHFlBHZfD362tl0
EJW7BH0SRkleeiV0dNiIRJ/CHgkaQbhEOE0w74vanx0Pf/y55x00UtRkkw3y5FHq
cYG5SwLuwc82Uk5BqvNxRcuTVlnXl8aRebx/N+w0Iu8y0Np8SCa0uHf+WCJmH479
N3TDkalGUlIajY7CLLksGe8pP/QzmAROIACcKDGm+LnI3/S9v5cmAA6u4VhGsBmL
u+y9tP5A6zJGGSRTYkvc
=x53j
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
