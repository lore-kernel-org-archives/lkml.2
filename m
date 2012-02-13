Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab2BMGT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 01:19:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48159 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2BMGT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 01:19:58 -0500
Date: Mon, 13 Feb 2012 17:19:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20120213171949.262e0c12e8d8883e90216df1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Feb_2012_17_19_49_+1100_nXti6E32PpsXVg=y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Feb_2012_17_19_49_+1100_nXti6E32PpsXVg=y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_cpu_notifier':
drivers/staging/zsmalloc/zsmalloc-main.c:451:3: error: implicit declaration=
 of function 'alloc_vm_area' [-Werror=3Dimplicit-function-declaration]
drivers/staging/zsmalloc/zsmalloc-main.c:451:12: warning: assignment makes =
pointer from integer without a cast [enabled by default]
drivers/staging/zsmalloc/zsmalloc-main.c:459:4: error: implicit declaration=
 of function 'free_vm_area' [-Werror=3Dimplicit-function-declaration]
drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_map_object':
drivers/staging/zsmalloc/zsmalloc-main.c:705:3: error: implicit declaration=
 of function 'set_pte' [-Werror=3Dimplicit-function-declaration]
drivers/staging/zsmalloc/zsmalloc-main.c:709:27: error: dereferencing point=
er to incomplete type
drivers/staging/zsmalloc/zsmalloc-main.c: In function 'zs_unmap_object':
drivers/staging/zsmalloc/zsmalloc-main.c:739:3: error: implicit declaration=
 of function '__flush_tlb_one' [-Werror=3Dimplicit-function-declaration]

Caused by commit 61989a80fb3a ("staging: zsmalloc: zsmalloc memory
allocation library").  This needs to include linux/vmalloc.h at least.  I
couldn't find set_pte at all or __flush_tlb_one for powerpc.

This was too hard to revert, so I have left powerpc allyesconfig broken
for today.  I may revert it (and some dependent commits) tomorrow.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Feb_2012_17_19_49_+1100_nXti6E32PpsXVg=y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOKuFAAoJEECxmPOUX5FEY1MP/ioIbn1gEbss2fdOtPe4pJMu
hybXU2M5Je+YTW+Qf1uYMpChlTjtDGEcxNZh3zRPvdjZZWkJYkmSZ9Dj2Zkx7+n2
5VVYSb0HNME7h9Lp4qxMc8Hn02RqiIJgPkfiPrLqIGR3cYYL+IPGpaeaYG39gqVq
RTFic3/GeIYNHroA5lsWYG0ugSu9VlcO8cgB1eZfhESrW+yvSXn89veWHr49cAUx
8ZN9EyeLrncVM33YXCENqI9GUJV3AlUg6Lw97NqLbibkBXlKPpOD8Yd7jd/Z6mst
10HRYFnInQiWna61S9Xu27McgHrkRGq0Iiafz3Ee7GxXSJIAxxSyWD1C3mKsUwzn
b8jlBf1PxI0Fza/LhTWVEh7ZzO6baP30qHwlrpLf3s8lMG2X4sHcT8q4iuXb65fK
AJt6/5kqf0OK81FnHN93POgw6sXjKiSXCDnniJJ/LUaNRZtGESJlQ3nef0Ig82Ag
abpywdorAlk57+mV0YqLU8ByBHYWoPv3TPp6BtqyCo+YqBWnSOeZYGmqKkiEBvck
VcqMLBh5cmUjGNUsdZBTd4KsSpaxJtKiqbNAUcD/GRztpFmxmbbbs0pL+FRVIU6i
e6WQVg6V3Rotv/9kSj/cmGOcobJ2CqaaInZGcD5Y+GTPiJHk8AIYEQtvMyY+rT0J
DUbqXNUp+mB6IFHLgEKI
=SuX7
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Feb_2012_17_19_49_+1100_nXti6E32PpsXVg=y--
