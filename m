Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab2AEH3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 02:29:47 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40761 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2AEH3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 02:29:46 -0500
Date: Thu, 5 Jan 2012 18:29:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120105182937.58ec59c2fa2bc34e9e48542a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_18_29_37_+1100_SFA+s.rM9TO7u4Fr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_18_29_37_+1100_SFA+s.rM9TO7u4Fr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/base/memory.c: In function 'memory_block_change_state':
drivers/base/memory.c:306:22: error: 'struct memory_block' has no member na=
med 'sysdev'
drivers/base/memory.c:309:22: error: 'struct memory_block' has no member na=
med 'sysdev'

Caused by commit 2691cc121386 ("kdump: add udev events for memory
online/offline") interacting with commit 10fbcf4c6cb1 ("convert 'memory'
sysdev_class to a regular subsystem") from the driver-core tree.

I have added the following merge fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 5 Jan 2012 18:25:57 +1100
Subject: [PATCH] memory: fix ups for class to subsystem conversion

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/memory.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 3463e87..ed5de58 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -303,10 +303,10 @@ static int memory_block_change_state(struct memory_bl=
ock *mem,
 	mem->state =3D to_state;
 	switch (mem->state) {
 	case MEM_OFFLINE:
-		kobject_uevent(&mem->sysdev.kobj, KOBJ_OFFLINE);
+		kobject_uevent(&mem->dev.kobj, KOBJ_OFFLINE);
 		break;
 	case MEM_ONLINE:
-		kobject_uevent(&mem->sysdev.kobj, KOBJ_ONLINE);
+		kobject_uevent(&mem->dev.kobj, KOBJ_ONLINE);
 		break;
 	default:
 		break;
--=20
1.7.8.197.g73c6b

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Jan_2012_18_29_37_+1100_SFA+s.rM9TO7u4Fr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBVFhAAoJEECxmPOUX5FE8XIP/0pKptKR1P0dVH0lFgHcSBtf
OClICUifwCFjs7QbBs+4nhO9hDBEAdGg1DtRe1fSW6iF/N00x5bjedas+uomJWCM
B4sqPwzk8KceDtDOnWiMrrvpqkXTsHsHQHgOAyBKv4NW9v67wGFyBSrzjb2jMQKE
DCG1kzOkyG1N+mDE0+3oqeEw+bTJ/gZeLv+ghydTW7N8W3rorhsbXC9Ngv3kYT8Q
MQ0IHwKsExXT1Q6QVwu4ZjxvcoaflufUur5TRVregVH6s06pVBSlke/pL7TYdb+0
zLmdOVX9oHOJteN5V4wv4r9WI7UocruKxwigMd/ae3m1nmUF2py5dJlEWtzRw1PC
SdaGaffLL50bnNsp0ezNhk5tmZnaSdwygQWpSoYtCWdMuSuSIB6zv56nASvQAmdD
WboFfwDTCrJ/2PeFeqaK3VZnoSsBPrNApPmVcEA5e9KZbemulwtMJnsdCXVhDtfE
PsHTVWnw+/hzoYj4J+7vTKtdxNT8q/iN1vqpxZig1femoAPweHKWL0DqLs6Yow4r
EiYVEvIPr34glrAEhwutO2PsyBiJC5hCE3u+pevyNokXIW2J7iQcMLjfVMal5Gwj
AJBwAUN8CO+Pov5V2njv9FcrBgRtrdaJ3WA51dOxthne8olB2MlEKBuW55Hsyl5W
aGQdKzA3YsKsmzA7va5M
=azfS
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_18_29_37_+1100_SFA+s.rM9TO7u4Fr--
