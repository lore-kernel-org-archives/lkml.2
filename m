Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab1LVF26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 00:28:58 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:41462 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1LVF2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 00:28:55 -0500
Date: Thu, 22 Dec 2011 16:28:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (pm tree
 related)
Message-Id: <20111222162846.51beb2e1b6b5c6ff2378ad33@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__22_Dec_2011_16_28_46_+1100_bs4_zalAtMb7Ey93"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Dec_2011_16_28_46_+1100_bs4_zalAtMb7Ey93
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

drivers/base/bus.o: In function `dev_pm_qos_add_ancestor_request':
bus.c:(.text+0x4c0): multiple definition of `dev_pm_qos_add_ancestor_reques=
t'
drivers/base/core.o:core.c:(.text+0x8ec): first defined here
drivers/base/dd.o: In function `dev_pm_qos_add_ancestor_request':
dd.c:(.text+0x418): multiple definition of `dev_pm_qos_add_ancestor_request'
drivers/base/core.o:core.c:(.text+0x8ec): first defined here
kernel/sysctl_binary.o: In function `dev_pm_qos_add_ancestor_request':
sysctl_binary.c:(.text+0x124): multiple definition of `dev_pm_qos_add_ances=
tor_request'

Caused by commit 513dcbda6199 ("PM / QoS: Introduce
dev_pm_qos_add_ancestor_request()") from the pm tree.

Please build with and without config options that protect new code ... :-(

I applied this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 22 Dec 2011 16:22:27 +1100
Subject: [PATCH] PM / QoS: fix build problem with new
 dev_pm_qos_add_ancestor_request api

Fixes these errors:

drivers/base/bus.o: In function `dev_pm_qos_add_ancestor_request':
bus.c:(.text+0x4c0): multiple definition of `dev_pm_qos_add_ancestor_reques=
t'
drivers/base/core.o:core.c:(.text+0x8ec): first defined here
drivers/base/dd.o: In function `dev_pm_qos_add_ancestor_request':
dd.c:(.text+0x418): multiple definition of `dev_pm_qos_add_ancestor_request'
drivers/base/core.o:core.c:(.text+0x8ec): first defined here
kernel/sysctl_binary.o: In function `dev_pm_qos_add_ancestor_request':
sysctl_binary.c:(.text+0x124): multiple definition of `dev_pm_qos_add_ances=
tor_request'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/pm_qos.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index b4d67e5..e5bbcba 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -155,7 +155,7 @@ static inline void dev_pm_qos_constraints_destroy(struc=
t device *dev)
 {
 	dev->power.power_state =3D PMSG_INVALID;
 }
-int dev_pm_qos_add_ancestor_request(struct device *dev,
+static inline int dev_pm_qos_add_ancestor_request(struct device *dev,
 				    struct dev_pm_qos_request *req, s32 value)
 			{ return 0; }
 #endif
--=20
1.7.8.197.g73c6b

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Dec_2011_16_28_46_+1100_bs4_zalAtMb7Ey93
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8sAOAAoJEECxmPOUX5FE0Z8P/0v12br53C1tc7TDmFCS0xpd
G35NelJe/m1XDRnIBi+Wmo6ashyskTbusABmKiH2CVjo/m63kOdfoak56EIXbUlb
jphF8jCVH8DEDvEZZTZjdYmNc+3WnVkv1LTg5RRIB+2B0gRylzNVUXfwCXUN2y+B
Tj1CZplc74lxelRNL/YRncA3ytUBCLh37VRfDrCtkgZ1j9ciM6jLVRq+LQVPiaE9
u2K+/P2lACDyHq5X9JhLkzKjRRBedNBI7jXN58ZfIEt7UJrUGy3k2ewDskjXcfAG
DBg0hAzxX+ZDe7qOXItb3Gi7MQZYYckCEAPVjQqnYPJ1J/IWUwlGh5PtOTpi+3K7
vaHfL8y5jZxw+pUCcQed31IO1w8eDCJXgF5xXXg8koPD7fjpk1hlha5F2h4a3S1S
HuCVk9dXLB7qp7/SpRN+a6gILLMjOLVBGq2b30zHLCd9Pai0Fl/5Zl+OFB0ggF7o
C5qOV08jZQTAtnL+jQsS/fj5tOFEfLkWNpN/D4l4DsVYxNdlXA8oQqINm4JE7cCN
ycYqzl77oe5cWu39W1x/++byJ+0xGl71YWKv5h+4lDokj917E7Bm5rdgYMQ5NDdH
x755b4/To8yCIkRFpaaBGmxL1hgY7AfAmtEx+lNU84zsKg6XgiD5NwbXnyyWrb4R
zGK1DbpdLs4VqvFZYAsU
=Gq7x
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Dec_2011_16_28_46_+1100_bs4_zalAtMb7Ey93--
