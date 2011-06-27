Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1F0Xbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 19:31:43 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:57484 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab1F0Xay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 19:30:54 -0400
X-Authority-Analysis: v=1.1 cv=pLPlkKcK38cN4Cv4YkVeTGGRYpmKez/IrX640LVKWnc= c=1 sm=0 a=w_12D8JdfmAA:10 a=72KqbvQDF6kA:10 a=JmtI77n5PKyEllQSDapvNg==:17 a=ayC55rCoAAAA:8 a=7YsZVmsyWg4EbG-G3RoA:9 a=ETbpw_zcMUF4JrQgjDcA:7 a=xe8BsctaAAAA:8 a=PAetnM8GYNrfGpzxVPUA:9 a=JmtI77n5PKyEllQSDapvNg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 184.91.189.177
Message-ID: <4E0912A9.7030403@cfl.rr.com>
Date: Mon, 27 Jun 2011 19:30:49 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix loopback devices to emit uevent on auto release
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig27008ADA44127C5DA326ACCD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig27008ADA44127C5DA326ACCD
Content-Type: multipart/mixed;
 boundary="------------040205010303030308080400"

This is a multi-part message in MIME format.
--------------040205010303030308080400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


--------------040205010303030308080400
Content-Type: text/x-patch;
 name="fixloop.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="fixloop.patch"

commit 4d5498b2b400ee4781b25fa9fa219eadf11c1ef5
Author: Phillip Susi <psusi@cfl.rr.com>
Date:   Mon Jun 27 18:55:00 2011 -0400

    Fixed loopback device to emit uevent on auto release
   =20
    The loopback driver failed to emit the change uevent
    when auto releasing the device.  Fixed lo_release()
    to pass the bdev to loop_clr_fd() so it can emit
    the event.

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index dbf31ec..ba915ce 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1522,7 +1522,7 @@ static int lo_release(struct gendisk *disk, fmode_t=
 mode)
 		 * In autoclear mode, stop the loop thread
 		 * and remove configuration after last close.
 		 */
-		err =3D loop_clr_fd(lo, NULL);
+		err =3D loop_clr_fd(lo, lo->lo_device);
 		if (!err)
 			goto out_unlocked;
 	} else {

--------------040205010303030308080400--

--------------enig27008ADA44127C5DA326ACCD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4JEqwACgkQJ4UciIs+XuLC8QCgmGk7DwQnrCnkozmi0uN5TTaT
ekoAnjBW8dOPYWDvcuPUOCZvGwmueMI8
=nMWL
-----END PGP SIGNATURE-----

--------------enig27008ADA44127C5DA326ACCD--
