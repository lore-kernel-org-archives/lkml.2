Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab1LQEXN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 23:23:13 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50548 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1LQEXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 23:23:06 -0500
Date: Sat, 17 Dec 2011 15:22:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>, Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20111217152253.1aedda0936cd5d1d98be5e76@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__17_Dec_2011_15_22_53_+1100_Ii+L_MQm9f.+iSMq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__17_Dec_2011_15_22_53_+1100_Ii+L_MQm9f.+iSMq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (sh
edosk7705_defconfig and lots of other sh configs) failed like this:

mm/pgtable-generic.c: In function 'pmdp_clear_flush_young':
mm/pgtable-generic.c:76: error: call to '__build_bug_failed' declared with =
attribute error: BUILD_BUG failed

This is the

	VM_BUG_ON(address & ~HPAGE_PMD_MASK);

in pmdp_clear_flush_young().

Exposed by commit 835cea45a4a0 ("hugetlb: replace BUG() with BUILD_BUG()
for dummy definitions") from the akpm tree but I don't know the root
cause.

This may have a fix somewhere (if it is sh specific) but the current sh
tree in linux-next
(git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git) does
not exist.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__17_Dec_2011_15_22_53_+1100_Ii+L_MQm9f.+iSMq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7BkdAAoJEECxmPOUX5FEgIcQAKb7Sv+ypXSsBmoy4/3cGQ+G
G4RJxkfIGmgfGeRweEP2vjY4odx70CPvfDc3QSyK+bfu5TckIMKyUHEUNa399646
MI5+yzjgCyauE4ksFAsN0Bpa2uY1JfNrueLf6ck3+RKM6iWsq7tg5PVsdSrRS2kJ
GWa6bu0upmTJ/LHfX16qPNKdwIz7bvrvAOk+6DxXOk555cJfx+jlwFypkNlGc6Q1
W9Uuz6d6KBcCucTzIDXLZ0vifalcvzdS48vfczA92vjojgySWb+2MudAfx8WrQmq
nmyKAJAtDbgkJSP9CT6q8WbSDBDjhuyRabZ2SzHC6S4OaJFpCQ3w+FfIBf+F+NOf
kiPCcQ1opA8bhXvwvfmQY5kyHEE83DRYEHx6pYY+LLj+3JzbhjVpKwPL1Fe4v3D1
TS3CpFPfh3oBW+10RmAtPHA25B+SE4CebvjOQ+fXbI/qD0vVpIrIdg8PGUO07GCt
2XR5GTaLn1QiGjhW7NKIb6/8vmwChIFLOZlZT9AVAaeuf/3xNcLt+luAZrYBrSwB
6BhisiTNyInLLoKPbHFj0Me9Q8VXJ4fbaBlRaffDQCdXAH2UadEWXj7VVxpO1Ryq
A+JkQ8ksD+9b+FpC1qdezqYliNkWT5yfhi77ksIPISCHu/QQoRtmvMaoEiAcW9tS
kZDCMy0UbGID694nc/lB
=V+1r
-----END PGP SIGNATURE-----

--Signature=_Sat__17_Dec_2011_15_22_53_+1100_Ii+L_MQm9f.+iSMq--
