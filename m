Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab1LSFE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 00:04:27 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:47218 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1LSFEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 00:04:24 -0500
Date: Mon, 19 Dec 2011 16:04:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the uprobes tree
Message-Id: <20111219160415.d3187e1599a2109537582c65@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_16_04_15_+1100_+FP+sZl1EQizbn/s"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_16_04_15_+1100_+FP+sZl1EQizbn/s
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Srikar,

After merging the uprobes tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/notifier.h:15:0,
                 from include/linux/memory_hotplug.h:6,
                 from include/linux/mmzone.h:676,
                 from include/linux/topology.h:32,
                 from include/linux/sched.h:78,
                 from arch/powerpc/kernel/asm-offsets.c:17:
include/linux/srcu.h:247:19: error: redefinition of 'srcu_read_lock_raw'
include/linux/srcu.h:204:19: note: previous definition of 'srcu_read_lock_r=
aw' was here
include/linux/srcu.h:266:20: error: redefinition of 'srcu_read_unlock_raw'
include/linux/srcu.h:223:20: note: previous definition of 'srcu_read_unlock=
_raw' was here

Caused by a bad automatic merge (commit e73ddde54141 from the uprobes
tree is the same patch as commit 0c53dd8b3140 from the tip and rcu
trees).  I fixed it up (removed the second copy of the functions).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Dec_2011_16_04_15_+1100_+FP+sZl1EQizbn/s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7sXPAAoJEECxmPOUX5FEXA4P/2ZVyVDNI60qlGZJLX/bHUeB
alVGduOG8efpuLCr3Rtd9T8PVIdBnZlcF+P19F2cWqtzUvngxMiVw6JPphRsTduD
Pfwz5qVK4P8ZV2MRzkeNINGGSS550MohZR+U3E7lNUaGGUxBmvbY4IPwE6rQBmhk
e4Ov/i3M4zjfcwGRGWUEW95ORGGmPNFBrbFXRNRh3JIOXahZLe9JBW2kWi5YyLp0
H/YgagMcaySLYhORIOUoNGtOJnvbGA2sGM1MRTIdZXgloUNW5UPxb0ojSJqkwnRs
QGlSLBpHNs5KQ4dzPyD+GT/oAeXApFUAEl7pyiuXB0/hK9HZh8r2T9gDjgvzjDhb
h73LWhCXzYJTtY+iKpAvIyzVfLCipnYma44mJaPtUDtvYGU/eS6lAiNg3cqKqxdQ
eCUMkJfSEWk36ud3sD/LDbpHe0b9uO3Qbh70fhbIlD23X8keHrPqw6iuomKna409
15RvhiGbjOvXHv367XlrrcRz51tPyXBYTIDY2i9P6k4r82Zqia3WnN7JmjLiZsWI
Sb3NCG0l9aHoq7yVrfsdAiEpxnhGXkdbReHlCvj6G0TpPXVk1Zg6FQWkT1WBGqNQ
zOE1oipYkl1w9hv2M4X/AnI1UnYm61Ipys+azYSD+p4HYVnoqLB0eBm1b/+Hde6z
Z2IMuClSXL8t3I1NNg4h
=CYSB
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_16_04_15_+1100_+FP+sZl1EQizbn/s--
