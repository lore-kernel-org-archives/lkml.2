Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2GJJWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:22:16 -0400
Received: from www.piware.de ([213.9.93.70]:44198 "EHLO mail.piware.de"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab2GJJWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:22:14 -0400
Date: Tue, 10 Jul 2012 11:22:08 +0200
From: Martin Pitt <martin.pitt@ubuntu.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] Option for scsi_debug to fake removable devices
Message-ID: <20120710092208.GE3049@piware.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Km1U/tdNT/EmXiR1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello all,

sorry for resending this twice to the lists. Initially I thought
mailing James directly was not appropriate, but I was now told that
get_maintainer.pl is actually speaking the truth and I am supposed to
do just that.


For the purposes of automatically testing udisks and gvfs automounting
I would like to add a parameter to scsi_debug to control the
"removable" attribute of the created block device. With that, we can
test system-internal and removable drives, as well as CD-ROMs (which
scsi_debug can already emulate). udisks requires different privileges
for mounting system-internal drives vs.  removable/hotpluggable
drives. This will also allow us to write system integration tests for
gvfs, which will exercise the whole stack including the actual polkit
configuration in a VM.

I wrote a simple kernel patch for this (against linux-next), and
tested this quite thoroughly.

I ran the style checker, and it reports two problems:

------------ 8< --------------
WARNING: line over 80 characters
#109: FILE: drivers/scsi/scsi_debug.c:3255:
+       ret |=3D driver_create_file(&sdebug_driverfs_driver, &driver_attr_r=
emovable);

WARNING: Prefer pr_err(... to printk(KERN_ERR, ...
#126: FILE: drivers/scsi/scsi_debug.c:3353:
+               printk(KERN_ERR "scsi_debug_init: removable must be 0 or 1\=
n");
------------ 8< --------------

But as the existing code uses this style in the adjacent lines, I
favored consistency over fixing those. If the latter is desired, I'd
rather send a separate patch with just the style cleanup for the whole
file.

I got an ack from David Zeuthen (the primary udisks maintainer)
already, noted so in the patch.

Thank you in advance for considering,

Martin

--=20
Martin Pitt                        | http://www.piware.de
Ubuntu Developer (www.ubuntu.com)  | Debian Developer  (www.debian.org)

--Km1U/tdNT/EmXiR1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJP+/RAAAoJEPmIJawmtHufg84P/jDA4tRVIPvwoRL+tv3m6+UZ
L50qbFpmGlCciL/ubqJk5k/L5mrQABxU1M4U6MaUPvYZHRaET3FB7/cRJHD7RikR
WX8HrPt8EjJyxkqa5VtlSpS97gTTTUx9N/MioMRSbaa5r5pAd4jsyNn5b1klb5bm
oM8IQqS5s09gUuC4kKmW1Cx5P+qSUtg4dNNDph+GcgHcB8cF7Ai0lHLumQiPoYlP
mzMvi02KZ7NdjOIiFxSIq09XNf1mlF83z76nDccq/M9REBsO42rFjBpBfX/15/X8
V9ZBjcgDZouSlnpwnBYxjWDT7Fjmxadx36YiuHjB2Cs7k49NrHEUqtG/xnZ2yy4m
bsYLwKhhCOdQl47VR1JTs2vJnErzfvbrXL3qHTPVZ4o0Rh/xQQznV+dCY5riLAMh
COcFB1ZIZfVi8bVxb5mMZr68NIHE5jkecw+/b16MP95A/8zTlR1/MxjDjZmqQGI8
z1+SLt7lhyxgpk5fesUKEafgXMCNu0bERXSeMxZ9FYOhzHj16dIsVtO6KBelfSqc
ehSJ7XqczyiOmQxBiKl/cUCyNEjzLrPd15Gm5T8soA4mliMQfHhI5f16pXcBF/2i
USqRayKErqCFcmze/EnkiEsp5szT2bkgq0guVAcmior6j6e2iFoDGYqFu85BwG8L
oUMncgYqNPq3+D/fLGhc
=XVHk
-----END PGP SIGNATURE-----

--Km1U/tdNT/EmXiR1--
