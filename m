Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2GaFPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:15:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56156 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab2GaFPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 01:15:03 -0400
Date: Tue, 31 Jul 2012 15:14:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20120731151452.472bb6b1775fad7998df59bb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__31_Jul_2012_15_14_52_+1000_k_Umz5TJjwYZnBkc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Jul_2012_15_14_52_+1000_k_Umz5TJjwYZnBkc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/regulator/s5m8767.c: In function 's5m8767_pmic_probe':
drivers/regulator/s5m8767.c:575:2: error: implicit declaration of function =
's5m_reg_write' [-Werror=3Dimplicit-function-declaration]

Caused by a mismerge in Linus' tree between commits c848bc8538cd
("regulator: s5m8767a: Support AP watchdog reset operation") and
63063bfbffe9 ("mfd: Modify samsung mfd driver for common api").

Fixed by commit 938e05bf1313 ("regulator: Fix an s5m8767 build failure")
from Linus' tree which I have cherry picked for today.

This was reported a couple of weeks ago when it caused a merge conflict
in linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__31_Jul_2012_15_14_52_+1000_k_Umz5TJjwYZnBkc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQF2nMAAoJEECxmPOUX5FEdtQQAKosKvzYttGUBody9pE5wNsF
X3YILOFmpIR3/QjCY4us4jA1qBvcFs67nlgr88oprVvAjJWfpH18xnRsZHeIezO2
EYv6pTcTo9S+Kq7dMM0AOGL7tEojgzSJ10Bf/DsDJ6CMnx9XKJyn4Cz4V76vuoG6
MwihvbafOaY5k0ZTyvOnribeqeHN+MqPYQTVzYxX4mTT2qYzjxK9OBc/BiisqoL2
Hm3V3eFBlNGbBmpNtbXT0K88jAscNpuG58Azhfe68L/+4lGlmMgrlrm3uXITeiqi
TOrmkMVeUAr4QHPRmo8Ss2/17a78FIoL8hJdSFhr7ocC9NNhK9PXLvi6hApAosan
K6J2mgEs5iEPzcMFwVtNzSMFd0EadeuMAVKrgvJdLJRVQWvJfBbAjOB7Kh0rYNRO
EeZUiG27IoINY7PUV675/IG97NDgXsv30b6wnh24pEC3Om1RfUYEmG3FNlhqfk0i
f4ANsIsWPc0/FqE2xgk9odZjFr8eLcoNO9IPoGIYMHjaY7gredlUDIYG9jLuYwMt
0tiaaLOpijRbN5OUkJ2T/Iv4+XWXxfPvM7ImnfBuKI0N/WBCBbrmMlxD5seVF9O7
B2U3T3yi2fRweSYpFlQewqg5Wm3RzpgY8BewK45FKP/MCMDGzDVIw9qXUzu0LOsW
XGoK0VNeKNCbcjRej/KG
=RtcP
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Jul_2012_15_14_52_+1000_k_Umz5TJjwYZnBkc--
