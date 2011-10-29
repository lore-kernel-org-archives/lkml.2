Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab1J2TM2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 15:12:28 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:59850 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1J2TM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 15:12:26 -0400
Date: Sat, 29 Oct 2011 15:12:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david.vrabel@citrix.com, davem@davemloft.net, axboe@kernel.dk
Subject: [GIT PULL] (xen) stable/vmalloc-3.2 for Linux 3.2-rc0
Message-ID: <20111029191212.GA28939@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4EAC5016.0010,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following git branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen stable/vmalloc-3.2

wherein:
#stable/vmalloc-3.2 is based on git commit a102a9ece5489e1718cd7543aa079082450ac3a2
(Linux 3.1-rc8): and it does three major things:
 a). make the backend driver use the API provided by xenbus module instead of its
     own handling (which was duplicated across backends),
 b). removes dead code (ia64),
 c). lays out the groundwork for removing the 'vmalloc_sync_all' patch
     that was added in v3.1 as a bug-fix.

Note: The patches touch other maintainers trees and I've gotten
Acks from them to do this as one patchset instead of cutting it in
small pieces and parceling out.

Note2: The git history is a bit fresh (4 days old) in the branch b/c
I've edited the git commits to add axboe and davem's Ack-by.

David Vrabel (3):
      xen: use generic functions instead of xen_{alloc, free}_vm_area()
      block: xen-blkback: use API provided by xenbus module to map rings
      net: xen-netback: use API provided by xenbus module to map rings

 arch/ia64/include/asm/xen/grant_table.h |   29 -----------
 arch/ia64/xen/grant-table.c             |   62 ------------------------
 arch/x86/include/asm/xen/grant_table.h  |    7 ---
 arch/x86/xen/grant-table.c              |    2 +-
 drivers/block/xen-blkback/common.h      |    5 +--
 drivers/block/xen-blkback/xenbus.c      |   54 +++------------------
 drivers/net/xen-netback/common.h        |   11 ++--
 drivers/net/xen-netback/netback.c       |   80 +++++++------------------------
 drivers/xen/xenbus/xenbus_client.c      |    6 +-
 include/xen/grant_table.h               |    1 -
 10 files changed, 34 insertions(+), 223 deletions(-)

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOrFAMAAoJEFKFlzJcLqlYpI4P/3L6Az7cJXsB46cYYnbvRPt+
sFbE19gI4zAYyaFcbruoIAotIlbrLigHqI5VXOQYz+U/nRIm0ReFrTD4l7S5/uVw
ClnelEjneH10wqzFGCCoLlad8GEHgfF/3UckZ8c1jPh45fcjLN7hxmyeZubkDAUt
1gUT6QM8VLSp9ao6MzBCLxbv90hMXYRiz1ymA7V1U0Tb9AfHwdYyCApsD1vrzwRJ
nTIyTf/CmsOMHOCOZGeqPFVk2KtkqqmdbsPXYlrOD6mBEcbAeRwTSYWZ1Jv/7QJ5
6ibAhDXqIObzpIa4+VPj7T6KaOjSomA6Vw3wmCpzCfrQ40FSBGcCbjTsAN1ulLbw
QxobMhv+gsLKIQW9LIUgdIMdyC2YtgEvFsQabk1cJ1pwONqdIJcOFurBrgCFc/Om
Ssqb0HqW5wNf30KQVEgwW0jHLi/IqSHy9RsCnc/3B2AdKsiN4PumY58gJKjBwTuv
NHIPTQYlpm2fZi7fUJ/0kzcpgCYflNC73rV5jrEOLk6RZUJkNkALYKi+Mdli+H0N
wKe1ATQuX9+fkA1iFV6JnyxEiBfYMm7+ZOJe0byPRxTKd4rcthV/ZdQMDGU0aOTz
zZQKV57RvvpubUcWWPd2xr1SV7YEF3Q9UVg6KCA8A5VSjEPqePQsIngBQrbFEuRH
TKj+otRvj9V3/SrzNSEd
=kB59
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
