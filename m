Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab1LOB6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 20:58:30 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:34747 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab1LOB62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 20:58:28 -0500
Date: Thu, 15 Dec 2011 12:58:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the scsi tree
Message-Id: <20111215125818.f9ffb338c0085f2ba9908a42@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Dec_2011_12_58_18_+1100_GO.CHrohSPg1I3TY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Dec_2011_12_58_18_+1100_GO.CHrohSPg1I3TY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/scsi/qla4xxx/ql4_os.c:2135:6: error: redefinition of 'qla4xxx_check=
_relogin_flash_ddb'
drivers/scsi/qla4xxx/ql4_os.c:2081:6: note: previous definition of 'qla4xxx=
_check_relogin_flash_ddb' was here

Caused by a bad automatic merge when I merged the scsi tree today.  The
patch "[SCSI] qla4xxx: fix flash/ddb support" appears in both the scsi
and scsi-rc-fixes tree (as separate commits) and git has messed up the
merge.  I fixed it up by using the version of this file from the scsi
tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Dec_2011_12_58_18_+1100_GO.CHrohSPg1I3TY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO6VQ6AAoJEECxmPOUX5FEXo4P/i+zBdKryYCg20/JO6QMkSHK
pInC08yAd1fUyHX3sE8dbz0Xaft4UA2Iba9z8Rut7a1uqEAVWXRU3eM8PUpt2kYR
xUfhXfYuGv0k62p8q1ZFge2U4b6vfKFW2gfEW2tmMXK+K0Vu8jIKWHNX3tNE/AEr
B4AOLax3qisS1V0I+e594YzrGWWRVrbmsYpnOv9R0vQEjYQdvqtoj7soX3P4Zanq
/HNj5mLMs3vvgkUm/6pB5ly7eDlwVjBwCQvOiBgoKuZ8qgeGQAt8Bvwo6rdxQMAE
KlmoIoFZDwhXOLgTBKqc+aTTtJ228DUdBI/7kzCuahMQMEtJz/P55jLrrYgZc1E9
hvUI76iMl4O/vEU3SDmQcf+ynw2Vu1922/X8N9MW7monRCJme20ecw99gPzd6SC/
RDoQ6B5QhYMD5IiRKpgeHVca9KhYOfz8cpikn5/xmF2Mqh+5JKKpSvdgo6VKYhRw
9231SMuMyttiE3nHc6RU+7EVUGEOupLoYRdCrzWL7l0wbfMMUxOIvzfh0MvpbOpk
8/lqsIolTWpii71cKZvn2mlC2XY1fZzcrGTHkfke1qpgu50huewlPDOvabO5SKNf
6DYO/D1gv19UPDmK4kxAutJcmL7cVIC2lKK1HZFFBchLwMJQde6UDzvXat92DKHH
S+X0IdWk6BZ41g6hIOBj
=s+m1
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Dec_2011_12_58_18_+1100_GO.CHrohSPg1I3TY--
