Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab2BOCZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 21:25:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45830 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab2BOCZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 21:25:56 -0500
Date: Wed, 15 Feb 2012 13:25:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ftp.linux.org.uk>, James Morris <jmorris@namei.org>
Subject: linux-next: manual merge of the sysctl tree with the security tree
Message-Id: <20120215132543.27189492ab5e910a0899be85@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_Feb_2012_13_25_43_+1100_Wlz2D6P_g.F+B6k5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Feb_2012_13_25_43_+1100_Wlz2D6P_g.F+B6k5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the sysctl tree got a conflict in
fs/proc/proc_sysctl.c between commit 404015308747 ("security: trim
security.h") from the security tree and commit 1f87f0b52b1d ("sysctl:
Move the implementation into fs/proc/proc_sysctl.c") from the sysctl tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

BTW, I think this file only needs to include <linux/export.h> not
module.h ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/proc/proc_sysctl.c
index 67bbf6e,a7708b7..0000000
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@@ -6,9 -6,8 +6,10 @@@
  #include <linux/poll.h>
  #include <linux/proc_fs.h>
  #include <linux/security.h>
 +#include <linux/sched.h>
  #include <linux/namei.h>
 +#include <linux/mm.h>
+ #include <linux/module.h>
  #include "internal.h"
 =20
  static const struct dentry_operations proc_sys_dentry_operations;
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Feb_2012_13_25_43_+1100_Wlz2D6P_g.F+B6k5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOxenAAoJEECxmPOUX5FEw6AP+wSMJUhrgwEM2YZhDGxPww2q
D8jrXjs11WTkfXAD/dpJHnkadeBekipxHLKVxNEOanES+BJBPMrdn/MgMgDrPtxo
mjShxaWNnXE5YxrjCEjAO9S6lV1DSgyKH/qghkGYaEmwVpEGY7aD0YfU1Q/4upOb
nkWkURgOHyCwFOCzw2GrM8cxDUQA6MLx+1zQs+oCurwTqpXRRfXtfO7qZbPdpKZ/
YiWfrjVHVoyo4FfExPhqHmMYzZK3sGbaCw6ZdBVXTZsbIN47OJ+y859SfVe2KTW7
/agHwH8DV32jSSgbJu5RyaRSofSHK3OY4xhyCIyUJtOdA4Zu80KbBaclWePq/6mz
aI9JP2Qo/mbfbgQFyXNHPYQslbIThjHi5tUl0j8q3+OtrGqToPTYyXwTIVT2e0Pl
MghLb48fVzE80+GzuwbP6/HDCHpRIPtagawsqEo/7xAS/qKLT8S17Es/a0BpTYl3
wWM+TDpqJ7/SCC8r134L+Irg1lm09ArGpet8BjlhmvPe64nFfY7077ggAMTiOj7U
T/c3LDvcYiJpcOH63Tem5Lc6qd1em0rWrui5yqSJCr0vp4mHszJ60RRe3BidGEG3
nJIXDuz9garhSguWV/Osrzn0bsfEVgh3KjecmVBHHXY4/x8v2ik8twG3VF+V9Ch8
5/Qc7XeK1kuB/oeQWiN4
=zki3
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Feb_2012_13_25_43_+1100_Wlz2D6P_g.F+B6k5--
