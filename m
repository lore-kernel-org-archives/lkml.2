Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1LDTAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:00:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42201 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab1LDTAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:00:20 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=zK1o0aTXHwcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=YOHAqSSgXUB0i1AXnCkA:9 a=3AQ5DN9QyJt3oUb-8IIA:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=J2NMI5S_6GZ5J2FRUBUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111204190017.703302345@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sun, 04 Dec 2011 13:54:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH 07/11] pci: Use __wake_up_all_locked pci_unblock_user_cfg_access()
References: <20111204185444.411298317@goodmis.org>
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

iQIcBAABAgAGBQJO28NBAAoJEIy3vGnGbaoANhYP/ifWK0+SrswxckZxLRVyCS/8
7YDkt1kFVgKQltsJnjIPCSYkmcffT2DBMEB4sNSETNqasR/RMWeYJQnadxPhDle/
gaRSTS64M/NGbD4Z33W71qWMFgz8rPDI3/eRVASHe1yF2lmGhnrxXxhk+3OzwykM
0hQpR1/13rfQfzPr9jSkxz4ZQK8TCg7g+DE9g0y8AwGbmdapy1ErZ1LDiBSGToll
2CDWzJb/lFq+yPMbLYj0vLGW8E1ik1WMyFZD8kmfq/Xc1NVQCuKWy2GFbmhAA+E8
/UbbherZsGONeesNzc0qF/tvJVa0408uHxh4FL4JdtH/+FLWPSFP1oZ6jTUiJ4q7
LAkcK0YtsGNHWBKcOisglhILCmLYGrqovzmbjd/Z7W2sA64f+aO7ea3TK3u/b2Cp
vhsZvAPClJkuy/gTqjYEb5DcL7qAWTwBxVoSUqeuD5eMAafnxPBHe4qV4v7lfDoe
gQP+ImLCUFqFIgwKC6qA5zn1ybr0ul6xDxolbJWp7fnpDjOHZrZTS8Qb0EaaU0KQ
a/hbCxzbZMwY86Vxkj0lA5r0tz1lKyn8jO/nxnlIDnGUxoulH0nk5zNawd7lOwDN
FqK3JpEulRN3uWwaYQAw+QWEeyWJKw+13sio51AbgWo/SB67o6B5Uc3TEU+4APjd
dri+X32b9IkfmgduB9eM
=JQVW
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
