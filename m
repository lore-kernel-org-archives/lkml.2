Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab2CTIaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:30:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43541 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab2CTIaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:30:07 -0400
Date: Tue, 20 Mar 2012 19:29:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Weston Andros Adamson <dros@netapp.com>
Subject: linux-next: build failure after merge of the final tree (nfs tree
 related)
Message-Id: <20120320192952.ed82031eec8a49cf7da40a8e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Mar_2012_19_29_52_+1100_7/cSXJIYlkE2DBlq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Mar_2012_19_29_52_+1100_7/cSXJIYlkE2DBlq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

[This was previously reported as a warning ... but sparc uses -Werr in
more places]

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

In file included from arch/sparc/kernel/sys_sparc32.c:24:0:
include/linux/nfs_fs.h: In function 'nfs_display_fhandle_hash':
include/linux/nfs_fs.h:416:1: error: no return statement in function return=
ing non-void [-Werror=3Dreturn-type]

Caused by commit d8e0539ebdff ("NFS: add filehandle crc for debug display").

I added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 20 Mar 2012 19:26:42 +1100
Subject: [PATCH] nfs: non void functions must return a value

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/nfs_fs.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 8f27c2e..69ec9cb 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -413,6 +413,7 @@ extern void _nfs_display_fhandle(const struct nfs_fh *f=
h, const char *caption);
 #else
 static inline u32 nfs_display_fhandle_hash(const struct nfs_fh *fh)
 {
+	return 0;
 }
 static inline void nfs_display_fhandle(const struct nfs_fh *fh,
 				       const char *caption)
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__20_Mar_2012_19_29_52_+1100_7/cSXJIYlkE2DBlq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPaEAAAAoJEECxmPOUX5FEox0P/1iSg2SBPoyuj41RNWsRXqDQ
V9QT9kNEb6Q9W3n7L8IF0FvlYJqcNwCU4UIPoFMlEsKi0oi4KLZ2VlF4jJwCJENn
lK1enaDzy/yzHV1h40u3MXGhXr18uzS1c5ZJD1coBMIcqG4+DKknmoo0F6cSPBkz
BScljwRA/rhOXHuVbYmQzN/pU7nMW715FUnObGJAWjQqvLIvhjk/gkMuduXYXfOZ
kSRvWzfOannZg4m80CjPTI2JUy/GHws8cVdAOT9QvY91gwTTB1YLp/YCtEvddwhY
szHPDCBsQg/v5HC7B3WPb6l9ofY2/Bo4JnC1BfE6+jwplneM4c/4Hbf4O1pESpbk
AgV4c6W96xWfvZsQOq38OIsr6tisOvA7b7wo/8ud8CZe6vBZPWv6uqynibmFn/CR
bFSnzLC9BGrSa6dPrDFyMQHhfP/1lv6gDu/JNgc65mbItzMFPtB02PJw9mW4oSa9
AzLtuUcvYQJOOJoU9bDDZi5BFMLO0m/YF+Xi3EoIFCZtMnxSD2xbwxx4XY2WC4Hc
h/qDLcgeujFyLI7XJDjDz3KAAkyCKY+1n45Vgx/UOTMB6qLbdV1A2iiR0cwPOGMt
89d3uy4HIBXlHrGTg6T3Stlb9qP/P6GCB8RPY2ZCU6/ol0NXxxlq6cRZwkG6YW1C
pW37pWqnAw4avsdHcnWh
=kg8h
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Mar_2012_19_29_52_+1100_7/cSXJIYlkE2DBlq--
