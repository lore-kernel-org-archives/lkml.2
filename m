Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1KDCzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:55:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:52895 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab1KDCzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:55:35 -0400
Date: Fri, 4 Nov 2011 13:55:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mat Martineau <mathewm@codeaurora.org>
Subject: linux-next: manual merge of the bluetooth tree with Linus' tree
Message-Id: <20111104135523.e82306ceccecef3e4687f58f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__4_Nov_2011_13_55_23_+1100_dbpxy8RMvquvSzvY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Nov_2011_13_55_23_+1100_dbpxy8RMvquvSzvY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

Today's linux-next merge of the bluetooth tree got a conflict in
include/net/bluetooth/bluetooth.h between commit b9075fa968a0 ("treewide:
use __printf not __attribute__((format(printf,...)))") from Linus' tree
and commit 5254c96d4e25 ("Bluetooth: Add BT_CHANNEL_POLICY socket
option") from the bluetooth tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/net/bluetooth/bluetooth.h
index e86af08,38cd3da..0000000
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@@ -77,7 -77,34 +77,34 @@@ struct bt_power=20
  #define BT_POWER_FORCE_ACTIVE_OFF 0
  #define BT_POWER_FORCE_ACTIVE_ON  1
 =20
+ #define BT_CHANNEL_POLICY	10
+=20
+ /* BR/EDR only (default policy)
+  *   AMP controllers cannot be used.
+  *   Channel move requests from the remote device are denied.
+  *   If the L2CAP channel is currently using AMP, move the channel to BR/=
EDR.
+  */
+ #define BT_CHANNEL_POLICY_BREDR_ONLY		0
+=20
+ /* BR/EDR Preferred
+  *   Allow use of AMP controllers.
+  *   If the L2CAP channel is currently on AMP, move it to BR/EDR.
+  *   Channel move requests from the remote device are allowed.
+  */
+ #define BT_CHANNEL_POLICY_BREDR_PREFERRED	1
+=20
+ /* AMP Preferred
+  *   Allow use of AMP controllers
+  *   If the L2CAP channel is currently on BR/EDR and AMP controller
+  *     resources are available, initiate a channel move to AMP.
+  *   Channel move requests from the remote device are allowed.
+  *   If the L2CAP socket has not been connected yet, try to create
+  *     and configure the channel directly on an AMP controller rather
+  *     than BR/EDR.
+  */
+ #define BT_CHANNEL_POLICY_AMP_PREFERRED		2
+=20
 -__attribute__((format (printf, 2, 3)))
 +__printf(2, 3)
  int bt_printk(const char *level, const char *fmt, ...);
 =20
  #define BT_INFO(fmt, arg...)   bt_printk(KERN_INFO, pr_fmt(fmt), ##arg)

--Signature=_Fri__4_Nov_2011_13_55_23_+1100_dbpxy8RMvquvSzvY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOs1QbAAoJEECxmPOUX5FE7+IP/2Sk2tyDsVRal2yjDs7zGs4f
0bz7jteU4dF7dyJVAQvQP4ARqpnQLoAXj8JP/eBc5CrAEPhWMSFSHeFwRMBG+qaC
2TUSQCtSC3gg5UHwR7G5DuS4l1wf52j4LWqIUK+xPhuyyFiqt1/7KCgcop1nA8vx
zJYzotijvHPyerAFKSKu4R1CvLtUE6r++ZEHaV7nKoQHON6khSMFZufy7WSiyZyx
skm4JbVQ0vtIJW2u2qZWIKskRhoclrUFAYEfGwxIfWBCBozqX0btyX/hv7GSGFcX
GQCSvXa2yTazqAPOCOhokDp/OENBhmYHvExVoDRQ6pqjxdoBsOOrQ8ZoAQULg6+k
AwPqlS9qO+5LjLqxPG4/atMMsmBRcQVJ8WnusNjq3wkUao4dV0EGj4Vj2H8Ng8EP
LufuWX8hVVtKtjzSArfiXlmdjjR84Q8JJIyUBNYQXZ4tZNtjclZUPbYFdLH13k3Q
BdxuPabo9QMwQBVTJTKWL5xlXFmoQncZPgfiVA9rQoUEohDyTmMyT9ewFl27wmqg
GsmqL6cGsjeiw6Mrp8ZTVP2jV/s4mHXLXBmLtk7kWxdaf6+9dMS9eeoJ4kn9PChy
BrWPhxA+a4Tw8bp6JfGneCt/6SbdnWniJjAexX2Nnk629UzPXX/Q7ssg/vhmwA7z
FK/WUTSeE4IbRZXJW7Fq
=iDiM
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Nov_2011_13_55_23_+1100_dbpxy8RMvquvSzvY--
