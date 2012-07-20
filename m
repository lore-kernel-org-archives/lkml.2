Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2GTAlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 20:41:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37685 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab2GTAlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:41:22 -0400
Date: Fri, 20 Jul 2012 10:41:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: build failure after merge of the scsi tree
Message-Id: <20120720104118.217d9adf6d7fd5253746c73a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Jul_2012_10_41_18_+1000_jvUm9dFJXSPR+g+/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Jul_2012_10_41_18_+1000_jvUm9dFJXSPR+g+/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/base/dd.c:27:28: fatal error: scsi/scsi_scan.h: No such file or dir=
ectory

Caused by commit eea03c20ae38 ("Make wait_for_device_probe() also do
scsi_complete_async_scans()") from Linus' tree interacting with commit
758da9dc2be8 ("[SCSI] cleanup usages of scsi_complete_async_scans") from
the scsi tree.

I have reverted commit 758da9dc2be8 for today (which may not be the best
thing to do).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Jul_2012_10_41_18_+1000_jvUm9dFJXSPR+g+/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQCKkuAAoJEECxmPOUX5FEnOkP/AkafMUZnOd90JjvacWEHPox
78kzeIeTVsG6CCHkc6x/5+7SFbullM5uqcNi+X2DpO0LVd905oCoqer6mzOjbdhN
dhDNsV+bR/AfwklqutIgkXlNYwaI4iOTfgr1umuWoFEnRzUaNxD0lFpHsr6H2H/k
LLJHKGYNySCnL8dAVnZdpsTGbvW+N1Gh7mPSXz19zU57xlb7cVBUhzV9ILxiCrIi
mGnzNgkZoxTRwGdXysbsayPbQclrEl5Hlw1AW0ogF6qiARfw9phIzLaOylUPxDnE
Bu/BAhLpZaKf3/8bnsmDl6ZR6SvvQoI2L36qTrlVtZ9DuYCC5ha9IBqoDnV6hEaP
UE2U/wKHCzQanFqrfPlvAGk9+RUZI7p9P4ZFRTJlXJL88mQL4ivA+d+pk6AAOjG8
nNhkUC0Gh+McMz2gKkflfgK7NjrKCrU3iZuQ6WVGz08lFk7GLspJPk3f3nWsTFyP
FHTeyfFUqrq3uhIeC6WmDcaeRH+L71nfhiXv9p0IM9LGGT1WbCgDBqecuuirXvyB
I5ijL4hq14PPEcigwMQ3ZpKAywMActVR8POB9CKcYEtGlgikp00AhGDOZ3DtY5cf
N9WhTerjldiR5v2UKbfWi2sJr6UVhlPjph+ULOw6oj/oHYa54Rc2CRdt/Pu5Jrt1
S3Qp9Y2M2NbCzyDCqBHI
=0tha
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Jul_2012_10_41_18_+1000_jvUm9dFJXSPR+g+/--
