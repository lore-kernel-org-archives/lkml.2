Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab0HBQpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:45:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45288 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab0HBQpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:45:00 -0400
Date: Tue, 3 Aug 2010 02:44:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>,
        Jayamohan Kallickal <jayamohank@serverengines.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: linux-next: build failure after merge of the final tree
 (scsi-post-merge tree related)
Message-Id: <20100803024445.0bf7ec86.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__3_Aug_2010_02_44_45_+1000_1iskTI2umx79Iw.5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Aug_2010_02_44_45_+1000_1iskTI2umx79Iw.5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (powerpc allmodconfi=
g)
failed like this:

ERROR: ".iscsi_boot_destroy_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undef=
ined!
ERROR: ".iscsi_boot_create_host_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] u=
ndefined!
ERROR: ".iscsi_boot_create_target" [drivers/scsi/be2iscsi/be2iscsi.ko] unde=
fined!
ERROR: ".iscsi_boot_create_initiator" [drivers/scsi/be2iscsi/be2iscsi.ko] u=
ndefined!
ERROR: ".iscsi_boot_create_ethernet" [drivers/scsi/be2iscsi/be2iscsi.ko] un=
defined!

Caused by commit a33e2a708b2e83ee6111e45c8d3d49a112c3c887 ("[SCSI]
be2iscsi: Add support for iscsi boot").  For some reason, commit
ed94aa526655d915076dcdbbf4fc962b2a67fcb5 ("[SCSI] be2iscsi: select
ISCSI_BOOT_SYSFS") was not sufficient to make sure that
CONFIG_ISCSI_BOOT_SYSFS is defined for this build.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__3_Aug_2010_02_44_45_+1000_1iskTI2umx79Iw.5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMVvX9AAoJEDMEi1NhKgbsDT4H/1J1U/yPtVK3zLin16pFlK+n
XB5SYGKIHzNUMfB7lvfsDVblbK0GpCxgNl44UixouhzDyS+Xd9Rn/Ib8gcEW4ZzZ
8wsJ9aVFL6iQ4OT8p58xjf3hE88JoBPSHmmZ3L2oPMiAqExEP0DxQGd6WS03ifMI
o3LBQeVBNcOVNCSoUpb+Hmmob3dwIP1f0qLd4s14W69a25LyxT5Unyg9TAmGp2dJ
nSb2LIeyKMSn+pLQ+5Z+EL6O5OxRUpYTSx76Qts9yb/CGzshmf6v5Rj72Oyz9nwU
xdkczvT8UqER0UqFEG2syz4u7670YtCCs9Tcdl4QuV1SrXSGfds3ojuavFAXibc=
=7TtO
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Aug_2010_02_44_45_+1000_1iskTI2umx79Iw.5--
