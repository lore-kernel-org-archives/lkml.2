Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818Ab1KWE3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 23:29:10 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59754 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab1KWE3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 23:29:08 -0500
Date: Wed, 23 Nov 2011 15:28:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (uprobes
 tree related)
Message-Id: <20111123152854.98c60a7c859f28c2efa30717@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Nov_2011_15_28_54_+1100_XiMA9wdGWUMq.Bav"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Nov_2011_15_28_54_+1100_XiMA9wdGWUMq.Bav
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

After merging the uprobes tree, today's linux-next build (sparc64
defconfig) failed like this:

In file included from include/linux/mm_types.h:15:0,
                 from include/linux/kmemcheck.h:4,
                 from include/linux/skbuff.h:18,
                 from net/8021q/vlan_core.c:1:
include/linux/uprobes.h: In function 'register_uprobe':
include/linux/uprobes.h:148:10: error: 'ENOSYS' undeclared (first use in th=
is function)

And several more.

Caused by commit fb16338b69cd ("register_unregister_uprobe" - "Uprobes:
register/unregister probes").

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 23 Nov 2011 15:11:20 +1100
Subject: [PATCH] uprobes: using ENOSYS requires errno.h

Fixes this build problem:

In file included from include/linux/mm_types.h:15:0,
                 from include/linux/kmemcheck.h:4,
                 from include/linux/skbuff.h:18,
                 from net/8021q/vlan_core.c:1:
include/linux/uprobes.h: In function 'register_uprobe':
include/linux/uprobes.h:148:10: error: 'ENOSYS' undeclared (first use in th=
is function)

when CONFIG_UPROBES is not defined.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/uprobes.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 091dfb8..e2e0674 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -23,6 +23,7 @@
  *	Jim Keniston
  */
=20
+#include <linux/errno.h>
 #include <linux/rbtree.h>
=20
 struct vm_area_struct;
--=20
1.7.7.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_Nov_2011_15_28_54_+1100_XiMA9wdGWUMq.Bav
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzHaGAAoJEECxmPOUX5FEqCkP/2kEI8fn/PmH623+YBtJe22I
02qwVtOwr/KHembhXEAChPOYItFH2KfG5TrFooLnHKw/9sjzISoXSRxrMwucFhLS
hPNuiTzkitycbWpOh29mWbp8NqLSHeqni4rhrjCiBvS2S6ymHkvIuW698u2Bxrkj
Qz6vc979THQ0bzCae1QcatvM+hfNZZMETjpSWbtqd9cRpuPKsgcAFbZKR6OyEaVv
gmAPKNQD3rGxCV7rEH8GRf27lAeJHmNaQpUZ9VfhG7273LbzzdGVkWTOtTmCFQ4f
eKamxpC/jVXylWQqOx2wycxzKgfBB/o6BHTZiRx/xIWo/kloMoAN8CyUye1hypNJ
yqxcG3wlEPVAam6UuqITw4fsjsUtg9fAEtJxnYShpdjbr1s+FQGEhLmnQkUYK6x6
bIUaj5jM3/PQdaVDQakgLfTmLtpVd0LYmXbGqxjRfnH+ZXFMRVrhy6ke1s2ZtmlX
H/FEWiJLKTPg2xJm5UsGj+aDOKbi16UGnNs1fTbMjvLnjRQ0ot0VdcZKlLogpuf3
MOI+2AWA+mDS7P0uNepQ+Hn0JHUCuDc4hPiPkzkZxzHhM4ZBiPCbIaWW0VB1qT9v
XhGAeHfS4tNqj1lD1zCJVOxsoon+vJUAK02JOOvQHhV36TcQ1lnG6bxYIazGJAd7
GxF2iYRAsWR+OPsq+o3v
=xTw8
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Nov_2011_15_28_54_+1100_XiMA9wdGWUMq.Bav--
