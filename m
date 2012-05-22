Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab2EVBpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:45:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58089 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2EVBpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:45:22 -0400
Date: Tue, 22 May 2012 11:45:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20120522114516.2c419f43a0826e9e78f8b3c0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_11_45_16_+1000_W9pad/X7tluFqj+L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_11_45_16_+1000_W9pad/X7tluFqj+L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
net/ceph/messenger.c between commit 95c961747284 ("net: cleanup unsigned
to unsigned int") from Linus' tree and commit 57dac9d16209 ("ceph:
messenger: use read_partial() in read_partial_message()") from the ceph
tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/ceph/messenger.c
index 36fa6bf,1a80907..0000000
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@@ -695,12 -698,12 +698,12 @@@ static void prepare_write_banner(struc
  	set_bit(WRITE_PENDING, &con->state);
  }
 =20
- static int prepare_write_connect(struct ceph_messenger *msgr,
- 				 struct ceph_connection *con,
- 				 int include_banner)
+ static int prepare_write_connect(struct ceph_connection *con)
  {
 -	unsigned global_seq =3D get_global_seq(con->msgr, 0);
 +	unsigned int global_seq =3D get_global_seq(con->msgr, 0);
  	int proto;
+ 	int auth_proto;
+ 	struct ceph_auth_handshake *auth;
 =20
  	switch (con->peer_name.type) {
  	case CEPH_ENTITY_TYPE_MON:
@@@ -1627,9 -1663,10 +1663,10 @@@ static int read_partial_message_bio(str
  static int read_partial_message(struct ceph_connection *con)
  {
  	struct ceph_msg *m =3D con->in_msg;
+ 	int size;
+ 	int end;
  	int ret;
- 	int to, left;
 -	unsigned front_len, middle_len, data_len;
 +	unsigned int front_len, middle_len, data_len;
  	bool do_datacrc =3D !con->msgr->nocrc;
  	int skip;
  	u64 seq;

--Signature=_Tue__22_May_2012_11_45_16_+1000_W9pad/X7tluFqj+L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuu+sAAoJEECxmPOUX5FEV1gP/19PGWFuX5zCSrKzYbTLXUEP
hava5SRyfO88j+shERk64SeQNH92z779T4vAD8PBa+GG2/2Cjl9BbyfUJiGgN8o8
77JVrmRWL3BAChiq1N2geuuJz1dnnC0knbKu5hi5Gg13URUOJ3jEAYKRUnJcWjcJ
mjwmq3S6gudfu3KgdiAPI54z0EsYc/GQluEdy711fXXA7hwb9TUljXsq5X/kBD/R
DdTWdfCBgeDad6OeG0YUSAU5jL5Wm0TCWqb52E8Crz6BCLd1wgso+3+q5GCc0mky
0r8ZdAFcfHWzXCPY/B1sIEMh1wMUGbxERC3wArZR3aICyjIroWCWhyidoDAiTmYP
pcVq46qddckT1GtUZHOpbTZz94i9UnAUaf9fMMlRc14zbksX4GfCz82nOscXuml2
51BJQbA1np0uX9+Hr9w4QT2HNyuoYFCMW+TSaFyZW+207EMxlGdfOZmGIxV9jYEw
oHamy9/edtEzqe4Wmi+sqNv/ml7ZTRsedjcgVt4SfkOZquEJz90G8iPCNCo5YVEk
/CiT8DmtNwMgRbhhWgq2Vn235Z2nQeL7TsZOkfKIqMZzPgzZIoG5toBU4HcPVUtE
0BQYsQS8YRJpwglmBOCbjHkefzfx4oLMUFJJ3WbSf/Vocndzg52Kda6qgCvWJRuY
X0ASu5Rf/MslzyRNs2LV
=VG97
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_11_45_16_+1000_W9pad/X7tluFqj+L--
