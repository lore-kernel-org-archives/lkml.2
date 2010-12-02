Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0LBAWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:22:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39567 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0LBAWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:22:50 -0500
Date: Thu, 2 Dec 2010 11:22:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the acpi tree
Message-Id: <20101202112239.c7d05518.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Dec_2010_11_22_39_+1100_5VO.exJxzIlcZ0QK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Dec_2010_11_22_39_+1100_5VO.exJxzIlcZ0QK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

After merging the acpi tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from drivers/video/output.c:25:
include/linux/video_output.h: In function 'video_output_register':
include/linux/video_output.h:49: error: implicit declaration of function 'E=
RR_PTR'
include/linux/video_output.h:49: warning: return makes pointer from integer=
 without a cast
In file included from drivers/video/output.c:27:
include/linux/err.h: At top level:
include/linux/err.h:22: error: conflicting types for 'ERR_PTR'
include/linux/video_output.h:49: note: previous implicit declaration of 'ER=
R_PTR' was here
drivers/video/output.c:84: error: redefinition of 'video_output_register'
include/linux/video_output.h:44: note: previous definition of 'video_output=
_register' was here
drivers/video/output.c:114: error: redefinition of 'video_output_unregister'
include/linux/video_output.h:51: note: previous definition of 'video_output=
_unregister' was here

Caused by commit 16d21716c8849c3283d1b9e590e6fe8d1966f4b7 ("ACPI: video:
fix build for VIDEO_OUTPUT_CONTROL=3Dn").  See Rule 1 in
Documentation/SubmitChecklist.

I have used the version of the acpi tree from next-20101201 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__2_Dec_2010_11_22_39_+1100_5VO.exJxzIlcZ0QK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM9ubPAAoJEDMEi1NhKgbsUjsH/j1wWa6bzSoEgkEj+acbmXyE
IXEnOfDMbhZRpl4v1gROrRq/jaFEX2c46PNHKEpBB8tP4YUTjIwE3pgnRFcTaDsm
tOVCRenw8OCHd/sYUDQRVQx+W7UwrtoubaAGVzIgE9txooFP6O/QEWRr/haSi2dH
IuAPmMDvaxYqL2sVTdLtbjapVBxcC/iIQVphYNhEaNR2rcoENZ0o5+XeJ+GzqOP2
XdlxAJycWo5SjFyOv0BvcyYW89nebKnf+jiMyFwfy5FbESUVMKVkzeTCGki5Ixv9
9AZ1guhzT07C2flWQckEF4sVCUK94LUYED4Rk4hEYvxZvAG/r0G1Tsy3EdmxhQ8=
=r1LO
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Dec_2010_11_22_39_+1100_5VO.exJxzIlcZ0QK--
