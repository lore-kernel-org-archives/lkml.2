Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484Ab3ABAVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 19:21:02 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57782 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3ABAU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 19:20:59 -0500
Date: Wed, 2 Jan 2013 11:20:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>,
        Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: linux-next: manual merge of the v4l-dvb tree with the
 driver-core.current tree
Message-Id: <20130102112050.f148022a6c7829c3ccb9ffb9@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Jan_2013_11_20_50_+1100_Xhtv9eKx./+q4d_h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Jan_2013_11_20_50_+1100_Xhtv9eKx./+q4d_h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/media/pci/dm1105/dm1105.c between commit 598759dec35a ("Drivers:
media: remove __dev* attributes") from the driver-core.current tree and
commit 73f0af44a913 ("[media] make the other drivers take use of the new
ts2020 driver") from the v4l-dvb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/media/pci/dm1105/dm1105.c
index 904c3ea,79fe74a..0000000
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@@ -849,7 -850,11 +850,11 @@@ static struct ds3000_config dvbworld_ds
  	.demod_address =3D 0x68,
  };
 =20
+ static struct ts2020_config dvbworld_ts2020_config  =3D {
+ 	.tuner_address =3D 0x60,
+ };
+=20
 -static int __devinit frontend_init(struct dm1105_dev *dev)
 +static int frontend_init(struct dm1105_dev *dev)
  {
  	int ret;
 =20

--Signature=_Wed__2_Jan_2013_11_20_50_+1100_Xhtv9eKx./+q4d_h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ431iAAoJEECxmPOUX5FEQ9sQAIhuUqrJgy9AgNBfYdrDKbX0
twV2c+K1VuUz8QMYsee4oVr9438WdbNt1soRjv+S6BuMIiYgDHjGX3zDNByJdco9
W4uKjFAnpM9PQFW0rYlWn5EqJ78+VikYZwidzlLbmmLDuJQ4h6C20AHjLUUfuebp
EqhLZB9ifYq0tSnM7eI/50MumLDFAimQnbJVo3ADZUXgtnO8LLC9N29ad+zXrsuN
p80yoojwTnf83b114qLUthOXqMaYX5a6eSRhG9xf8R7JsRucWKx9VwsMSijwKrao
IpdWsv/4UawzfGBnCwQAMtotagWffY70vRSV4iudfUfsAfuDqsTxBB9rmhBdV6Zg
VRFvBLn5TL+tGlkrHQvJmzFWHW/Uzt+DBVThj4RX+uGd/rj0WEzJME2FUwL7WvPc
0lMQTjKYAaTdc0/CbPrrMR9hQyXaesT6KRvOEMilbdiL5tohvxeVTPuHz/fS9Ka1
qbsyq+h0pb3rmxM34LrQ3DXPzB2npeBturK/wftWAAsymVwBWs2zQm9VYSfJwKFM
YOpOwFerx/icFtQH/eAlB92/qCqCH9bv/qLoyFHvXbKroetdyRj+dNmFK7i0ukk2
WF+wS5akyyuZ6+WUtFSvSMi51FDgqUcB04+UTmrsYWQ9gfob/jw0AclwJsNXZ3/T
NaG+1bvQ9xJxqX1VYMZq
=8Y2c
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Jan_2013_11_20_50_+1100_Xhtv9eKx./+q4d_h--
