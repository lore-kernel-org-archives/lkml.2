Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab0HBQrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:47:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33965 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab0HBQrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:47:06 -0400
Date: Tue, 3 Aug 2010 02:47:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>,
        Jayamohan Kallickal <jayamohank@serverengines.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (scsi-post-merge tree related)
Message-Id: <20100803024701.b3dff69a.sfr@canb.auug.org.au>
In-Reply-To: <20100803024445.0bf7ec86.sfr@canb.auug.org.au>
References: <20100803024445.0bf7ec86.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__3_Aug_2010_02_47_01_+1000_mkCCC.OXXw7uWLPu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Aug_2010_02_47_01_+1000_mkCCC.OXXw7uWLPu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 3 Aug 2010 02:44:45 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the final tree, today's linux-next build (powerpc allmodcon=
fig)
> failed like this:
>=20
> ERROR: ".iscsi_boot_destroy_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] und=
efined!
> ERROR: ".iscsi_boot_create_host_kset" [drivers/scsi/be2iscsi/be2iscsi.ko]=
 undefined!
> ERROR: ".iscsi_boot_create_target" [drivers/scsi/be2iscsi/be2iscsi.ko] un=
defined!
> ERROR: ".iscsi_boot_create_initiator" [drivers/scsi/be2iscsi/be2iscsi.ko]=
 undefined!
> ERROR: ".iscsi_boot_create_ethernet" [drivers/scsi/be2iscsi/be2iscsi.ko] =
undefined!
>=20
> Caused by commit a33e2a708b2e83ee6111e45c8d3d49a112c3c887 ("[SCSI]
> be2iscsi: Add support for iscsi boot").  For some reason, commit
> ed94aa526655d915076dcdbbf4fc962b2a67fcb5 ("[SCSI] be2iscsi: select
> ISCSI_BOOT_SYSFS") was not sufficient to make sure that
> CONFIG_ISCSI_BOOT_SYSFS is defined for this build.

It turns out that drivers/firmware/Kconfig is only included on x86, ia64
and blackfin.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__3_Aug_2010_02_47_01_+1000_mkCCC.OXXw7uWLPu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMVvaFAAoJEDMEi1NhKgbsojsH/2g7zFwrVivrsdZZRUdMumTT
UXuk6HexC6DwdyXh2A7PDAO3jAF9u5f/iRz611RBaSPf8+CiY6uyDZj7RBp5qzj5
+POg2/J9muPHP6Cby9npGq+eOPPPt70cC+l9BaPTDHVPv+JBmJNpL8YPLLm5boLU
r4A43FDC/r/6WjWjO7+kk4Sxa0jDerQQNJXDWY+DBgVisyvfwRUNnIW3Hv8B6nEi
fELbC+s0HltkWWCMxElmZ58A/VO+2+ty3AqnRVeV7iaU+BNfWyR7uYpkzZXqNfMB
E91keNtEd9Nlu9xOke33YBndlv5kl6TZrWTA0TQIrvXXmNfcAIRbrwbV2LtGtn0=
=2yzk
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Aug_2010_02_47_01_+1000_mkCCC.OXXw7uWLPu--
