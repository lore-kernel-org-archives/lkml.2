Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2ARXJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:09:49 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:53319 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2ARXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:09:47 -0500
Date: Thu, 19 Jan 2012 10:09:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Schmidt <list.btrfs@jan-o-sch.net>, Arne Jansen <sensille@gmx.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-next: build warning in Linus' tree
Message-Id: <20120119100935.82c5ec6db156f3799835163f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Jan_2012_10_09_35_+1100_lE5_jvtJ7rZ67x=a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Jan_2012_10_09_35_+1100_lE5_jvtJ7rZ67x=a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Building Linus' tree, today's linux-next build (powerpc_ppc64_defconfig)
produced these warnings:

fs/btrfs/backref.c: In function 'find_parent_nodes':
fs/btrfs/backref.c:482:3: warning: 'ret' may be used uninitialized in this =
function [-Wuninitialized]
fs/btrfs/backref.c:395:6: note: 'ret' was declared here
fs/btrfs/backref.c:381:3: warning: 'ret' may be used uninitialized in this =
function [-Wuninitialized]
fs/btrfs/backref.c:300:6: note: 'ret' was declared here

and indeed, there is a path through to a BUG_ON(ret) that does not set
"ret".  Introduced by commit 8da6d5815c59 ("Btrfs: added
btrfs_find_all_roots()").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__19_Jan_2012_10_09_35_+1100_lE5_jvtJ7rZ67x=a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPF1EvAAoJEECxmPOUX5FEswcP/2CVtHJTzF/k4kB62tXhV5NR
e7ZC7FbyYJg7FEv4x00Jfzd2TYADG31+M7kemnRg4Bq+O9D1X9GA5cxe1sLIkFQK
I4+FdTsSwuWYA7pA/FCW7vZj50n9ZFhQai+jHxmuW5RU5bzBr3gWMkT5xTXMr7f6
oh3fIaNTW1rzIyoluZHns+K23SqHkZg1OTlB8oSCrFKBxmbHroIckMEIejqFB4CO
JEClAUdvV2kJyEpbCK+WIHDelM3IktDnMRbKLeFNYtGgSH59FitzXtIlEfcsFLSC
+qThlSt7v7tqz9VraqkoHchbURmnhJuZ62CD3SzH+qwokxnCIFMR3iVfNgbQ/vd9
Sr+kOkaQHWSx1z0//h5LJxpQpijisGhZMTtlonEQ6hevkfEmVBCY/70hZKpIlYNg
C4UomG7zZ8Ihzi1Tqbs4RV8SWVZlPYD3SvGY1aFLhR1tbZLys64OHAt8KtUOY9Ci
Ynm3B234PxfWbxEDKY3K1ZY5XduuVtAHU2GEnwMiJ95x0/JwBv3buu0Ya+GPIMt5
R6tBL0aRdG9EInHUEkZeG+w89e5bfFAnyNFfLLWRyJOCtKCtuA5dnO3S52exDVOb
wf9ovMPhVZPE6kLqcKYnU2Fmq4EssS7N79yzpCgT/mVGTGEjesuDTu13BGW8aZlQ
KP6UM+a76MVNIXDuenPo
=8/ME
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Jan_2012_10_09_35_+1100_lE5_jvtJ7rZ67x=a--
