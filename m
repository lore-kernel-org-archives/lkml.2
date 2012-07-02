Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2GBDMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 23:12:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58618 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab2GBDMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 23:12:36 -0400
Date: Mon, 2 Jul 2012 13:12:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Jeff Garzik <jeff@garzik.org>
Subject: linux-next: manual merge of the isci tree with the libata tree
Message-Id: <20120702131227.01e8a64559a53d773fa574fb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Jul_2012_13_12_27_+1000_xXP3kaqHqglYWm97"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Jul_2012_13_12_27_+1000_xXP3kaqHqglYWm97
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Today's linux-next merge of the isci tree got a conflict in
drivers/ata/libata-core.c between commit 6b66d95895c1 ("libata: bind the
Linux device tree to the ACPI device tree") from the libata tree and
commit 95f0f9a02129 ("libata: export ata_port suspend/resume
infrastructure for sas") from the isci tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/ata/libata-core.c
index c14f88c,6f1e459..0000000
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@@ -5291,9 -5294,10 +5297,8 @@@ static int ata_port_request_pm(struct a
  	return rc;
  }
 =20
- static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
 -#define to_ata_port(d) container_of(d, struct ata_port, tdev)
 -
+ static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t me=
sg, int *async)
  {
- 	struct ata_port *ap =3D to_ata_port(dev);
  	unsigned int ehi_flags =3D ATA_EHI_QUIET;
  	int rc;
 =20

--Signature=_Mon__2_Jul_2012_13_12_27_+1000_xXP3kaqHqglYWm97
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8RGbAAoJEECxmPOUX5FExjoQAJ4ystPeU1hFbw+NIQoqnW5g
QZ7fT69hX8ECgL4oozHyEv1AacrnNEswTHVfn2AyS/L/fNyS94srr4lF3Fs2XLNf
Bbmz8fPSgYLLXD3YfE5//UEVuOiu9tILKgYypKtPh/mC6IQ3zJYHQJzmvCYuJRdG
M/wmkpi/CwPtodJVsl/F8fyemxnuQPcioHdrZKQNkRvDKu6NvRhQCg0V51SjgC44
Wjw4Cncs6pt8rXriRnJuvnfwyQqBzfQIRhyc7eMveA35wz23UJpLFiLz6iS2Gs/h
Bkmlb3qnwRWPv/i0z1kZfsHxwasZb1g9fvGZQHD1zTGhCCy0+iZKp26gAGOPe3FG
9u7DRQ3ROhKOVV6++XvUnxNS0YXzLfJkIp/vNcgw3EEcmHX9SYEmRwXqj0Hq0lxP
bN2knLrPYuxRbcSWfz9SjKuCtavmvn0BGLLdSa3AdSk89fyLvD6svfnkuvRPlMXG
Wp4salvc94y1Fi8D5Vo5+HTne55hfLULZ8nGaaAXvSyq8b5VlghuxqtxaM4ac6r5
+zPW4kPnkEumRlyGodtsn4WFQjsAL+JgIC9CazGQoYUwbuAGBWqFsW/Tx+zF9QZD
eT3wHZnwGtF5w6UNGILhxU/gUhI6fKVUjzLk4agU99o90vucWhdsDJ27PHOTMWo9
SvGjB4QBH+fWpIpwjaeY
=c/8v
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Jul_2012_13_12_27_+1000_xXP3kaqHqglYWm97--
