Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1IPKHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 06:07:55 -0400
Received: from www17.your-server.de ([213.133.104.17]:33340 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1IPKHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 06:07:54 -0400
Subject: [PATCH] Force same size of struct autofs_v5_packet on x86 and x86_64
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        viro@zeniv.linux.org.uk, dhowells@redhat.com, raven@themaw.net
Date: Fri, 16 Sep 2011 12:06:38 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-EWq8Gmq8oOUaYlJ42Pnl"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1316167604.6545.84.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EWq8Gmq8oOUaYlJ42Pnl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

autofs_v5_packet is 300 bytes on x86 and 304 bytes on x86_64.
This difference is wrong and leads to a hang in systemd when running
a x86 userspace on an x86_64 kernel.

Signed-off-by: Thomas Meyer <thomas@m3y3r>
---
 include/linux/auto_fs4.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/auto_fs4.h b/include/linux/auto_fs4.h
index e02982f..4be222a 100644
--- a/include/linux/auto_fs4.h
+++ b/include/linux/auto_fs4.h
@@ -138,7 +138,7 @@ struct autofs_v5_packet {
 	__u32 tgid;
 	__u32 len;
 	char name[NAME_MAX+1];
-};
+} __attribute__ ((packed));
=20
 typedef struct autofs_v5_packet autofs_packet_missing_indirect_t;
 typedef struct autofs_v5_packet autofs_packet_expire_indirect_t;
--=20
1.7.6.2


--=-EWq8Gmq8oOUaYlJ42Pnl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOcx+uAAoJEK2Y/UtDbsHsYO0IAKNXJcc/7jjzoUYD0ercJ6Tq
Vu7CjaWDziaVteR6XtMermxEmyZghKPl4851euQiK3BYYxf7lCZG+GIRcoXco35Q
0+X+0oqB/Vk2pKZXusDuMZdcPZgwLuel7hsTjM5mqt3Dwln+kgOGnLs72/nfOYNc
Qp1kR2zAjg91GyntuLzW7VvInPwM0glzjnPSi/jn7MKnVAHlvyje+L+OkfwTQhCu
7E6qdpJrn2IFF+VdHyFx3IkNAiiUeibZXDrhh25WpKlhx3E2dzCoXNsFs60ijFYD
Rw7Z8BWgPheyBYxoE3Mwtl2AcXp044ZOSrjXMRXuUtdxHdsKASccQcHoxT/qw1U=
=oX6Q
-----END PGP SIGNATURE-----

--=-EWq8Gmq8oOUaYlJ42Pnl--

