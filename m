Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2GaWvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 18:51:09 -0400
Received: from mx2.netapp.com ([216.240.18.37]:47697 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2GaWvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 18:51:06 -0400
X-IronPort-AV: E=Sophos;i="4.77,689,1336374000"; 
   d="scan'208";a="670644164"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull second wave of NFS client changes for 3.6
Thread-Topic: [GIT PULL] Please pull second wave of NFS client changes for
 3.6
Thread-Index: AQHNb27tUwSpmkGPVEKX7EogFJCdTQ==
Date: Tue, 31 Jul 2012 22:50:49 +0000
Message-ID: <1343775047.5528.59.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <954A873DF1471F4AA0DEE5F9ACB9C534@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6VMpIen013876

Hi Linus,

The following changes since commit f44106e2173f08ccb1c9195d85a6c22388b461c1:

  nfs: fix fl_type tests in NFSv4 code (2012-07-30 18:09:13 -0400)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.6-2

for you to fetch changes up to ad0fcd4eb68059de02e1766948263c71b8a5b1dc:

  nfs: explicitly reject LOCK_MAND flock() requests (2012-07-31 14:42:20 -0400)

Cheers,
  Trond

----------------------------------------------------------------
NFS client updates for Linux 3.6

Features include:
- Patches from Bryan to allow splitting of the NFSv2/v3/v4 code into
  separate modules.
- Fix Oopses in the NFSv4 idmapper
- Fix a deadlock whereby rpciod tries to allocate a new socket and
  ends up recursing into the NFS code due to memory reclaim.
- Increase the number of permitted callback connections.

----------------------------------------------------------------
Bryan Schumaker (10):
      NFS: Add version registering framework
      NFS: Remove the NFS v4 xdev mount function
      NFS: Create a try_mount rpc op
      NFS: Only initialize the ACL client in the v3 case
      NFS: Pass super operations and xattr handlers in the nfs_subversion
      NFS: Split out remaining NFS v4 inode functions
      NFS: Keep module parameters in the generic NFS client
      NFS: Convert v2 into a module
      NFS: Convert v3 into a module
      NFS: Convert v4 into a module

David Howells (1):
      NFS: Fix a number of bugs in the idmapper

Jeff Layton (3):
      sunrpc: clarify comments on rpc_make_runnable
      nfs: skip commit in releasepage if we're freeing memory for fs-related reasons
      nfs: explicitly reject LOCK_MAND flock() requests

NeilBrown (1):
      nfs: increase number of permitted callback connections.

Peng Tao (1):
      pnfsblock: bail out partial page IO

Stanislav Kinsbursky (1):
      SUNRPC: return negative value in case rpcbind client creation error

 fs/nfs/Kconfig                   |   6 +-
 fs/nfs/Makefile                  |  27 +++---
 fs/nfs/blocklayout/blocklayout.c |  39 +++++++-
 fs/nfs/callback.c                |  28 +-----
 fs/nfs/callback.h                |   2 +-
 fs/nfs/client.c                  | 191 +++++++++++++++++++++------------------
 fs/nfs/delegation.h              |   2 +-
 fs/nfs/dir.c                     |  20 +++-
 fs/nfs/direct.c                  |   2 +-
 fs/nfs/dns_resolve.c             |   4 +
 fs/nfs/file.c                    |  31 ++++++-
 fs/nfs/idmap.c                   |  29 ++++--
 fs/nfs/inode.c                   | 105 ++++++++++-----------
 fs/nfs/internal.h                |  38 +++++---
 fs/nfs/namespace.c               |  17 +---
 fs/nfs/netns.h                   |   2 +-
 fs/nfs/nfs.h                     |  29 ++++++
 fs/nfs/nfs2super.c               |  31 +++++++
 fs/nfs/nfs3client.c              |  65 +++++++++++++
 fs/nfs/nfs3proc.c                |   3 +
 fs/nfs/nfs3super.c               |  31 +++++++
 fs/nfs/nfs4_fs.h                 |  13 ++-
 fs/nfs/nfs4client.c              |  23 ++---
 fs/nfs/nfs4proc.c                |   9 +-
 fs/nfs/nfs4super.c               | 106 ++++++++++++----------
 fs/nfs/nfs4xdr.c                 |   6 --
 fs/nfs/pagelist.c                |   4 +
 fs/nfs/pnfs.c                    |   2 +
 fs/nfs/proc.c                    |   3 +
 fs/nfs/read.c                    |   5 +
 fs/nfs/super.c                   | 172 ++++++++++++++++++++++++-----------
 fs/nfs/write.c                   |  35 +++----
 include/linux/nfs_fs.h           |   6 +-
 include/linux/nfs_fs_sb.h        |   7 +-
 include/linux/nfs_idmap.h        |   2 +-
 include/linux/nfs_xdr.h          |   9 +-
 net/sunrpc/rpcb_clnt.c           |   4 +-
 net/sunrpc/sched.c               |   7 +-
 net/sunrpc/xprtrdma/transport.c  |   3 +-
 net/sunrpc/xprtsock.c            |  10 ++
 40 files changed, 725 insertions(+), 403 deletions(-)
 create mode 100644 fs/nfs/nfs.h
 create mode 100644 fs/nfs/nfs2super.c
 create mode 100644 fs/nfs/nfs3client.c
 create mode 100644 fs/nfs/nfs3super.c

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
