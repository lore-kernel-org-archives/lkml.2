Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2DXUSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:18:23 -0400
Received: from mx2.netapp.com ([216.240.18.37]:2552 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab2DXUSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:18:22 -0400
X-IronPort-AV: E=Sophos;i="4.75,474,1330934400"; 
   d="scan'208";a="643197292"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] please pull NFS client bugfixes
Thread-Topic: [GIT PULL] please pull NFS client bugfixes
Thread-Index: AQHNIldbl+q+9KK8xUuLDD0HQ4ubPg==
Date: Tue, 24 Apr 2012 20:18:03 +0000
Message-ID: <1335298684.2561.8.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C65AAE2B9102184DA2536235A443AE60@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3OKIgMW000747

Hi Linus,

Please pull from the signed tag "nfs-for-3.4-3" in the repository at

   git pull git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.4-3

This will update the following files through the appended changesets.

  Cheers,
    Trond

----
 fs/nfs/dir.c             |    4 ++--
 fs/nfs/nfs4_fs.h         |    1 +
 fs/nfs/nfs4proc.c        |   44 ++++++++++++++++++++++++++++++++++++--------
 fs/nfs/nfs4state.c       |   31 +++++++++++++++++++------------
 fs/nfs/nfs4xdr.c         |    9 +++++----
 fs/nfs/read.c            |    2 +-
 fs/nfs/super.c           |    8 ++++++--
 fs/nfs/write.c           |    5 +++--
 include/linux/nfs_xdr.h  |    7 ++++++-
 net/sunrpc/sunrpc_syms.c |   17 +++++++++--------
 10 files changed, 88 insertions(+), 40 deletions(-)

commit 7bf97bc27308cfdc7a8dadd40ae50f7c4cb09b01
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Sat Apr 21 12:36:19 2012 -0400

    NFSv4: Keep dropped state owners on the LRU list for a while
    
    To ensure that we don't reuse their identifiers.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit c77365c963cf8703ecf1004cd3b298068a3e1b76
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Sat Apr 21 12:31:05 2012 -0400

    NFSv4: Ensure that we don't drop a state owner more than once
    
    Retest the RB_EMPTY_NODE() condition under the spin lock
    to ensure that we don't call rb_erase() more than once on the
    same state owner.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 95b72eb0bdef6476b7e73061f0382adf46c5495a
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Fri Apr 20 19:24:51 2012 -0400

    NFSv4: Ensure we do not reuse open owner names
    
    The NFSv4 spec is ambiguous about whether or not it is permissible
    to reuse open owner names, so play it safe. This patch adds a timestamp
    to the state_owner structure, and combines that with the IDA based
    uniquifier.
    Fixes a regression whereby the Linux server returns NFS4ERR_BAD_SEQID.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 98a2139f4f4d7b5fcc3a54c7fddbe88612abed20
Author: Jan Kara <jack@suse.cz>
Date:   Sat Sep 3 01:09:43 2011 +0200

    nfs: Enclose hostname in brackets when needed in nfs_do_root_mount
    
    When hostname contains colon (e.g. when it is an IPv6 address) it needs
    to be enclosed in brackets to make parsing of NFS device string possible.
    Fix nfs_do_root_mount() to enclose hostname properly when needed. NFS code
    actually does not need this as it does not parse the string passed by
    nfs_do_root_mount() but the device string is exposed to userspace in
    /proc/mounts.
    
    CC: Josh Boyer <jwboyer@redhat.com>
    CC: Trond Myklebust <Trond.Myklebust@netapp.com>
    Signed-off-by: Jan Kara <jack@suse.cz>
    Cc: stable@vger.kernel.org
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 8ccd271f7a3a846ce6f85ead0760d9d12994a611
Author: Fred Isaman <iisaman@netapp.com>
Date:   Fri Apr 20 14:47:35 2012 -0400

    NFS: put open context on error in nfs_flush_multi
    
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Fred Isaman <iisaman@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 73fb7bc7c57d971b11f2e00536ac2d3e316e0609
Author: Fred Isaman <iisaman@netapp.com>
Date:   Fri Apr 20 14:47:34 2012 -0400

    NFS: put open context on error in nfs_pagein_multi
    
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Fred Isaman <iisaman@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 451146be933e26e21277852b5e40c6a52266ef96
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Wed Apr 18 16:29:11 2012 -0400

    NFSv4: Fix open(O_TRUNC) and ftruncate() error handling
    
    If the file wasn't opened for writing, then truncate and ftruncate
    need to report the appropriate errors.
    
    Reported-by: Miklos Szeredi <miklos@szeredi.hu>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
    Cc: stable@vger.kernel.org

commit 55725513b5ef9d462aa3e18527658a0362aaae83
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Wed Apr 18 12:48:35 2012 -0400

    NFSv4: Ensure that we check lock exclusive/shared type against open modes
    
    Since we may be simulating flock() locks using NFS byte range locks,
    we can't rely on the VFS having checked the file open mode for us.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
    Cc: stable@vger.kernel.org

commit 05ffe24f5290dc095f98fbaf84afe51ef404ccc5
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Wed Apr 18 12:20:10 2012 -0400

    NFSv4: Ensure that the LOCK code sets exception->inode
    
    All callers of nfs4_handle_exception() that need to handle
    NFS4ERR_OPENMODE correctly should set exception->inode
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
    Cc: stable@vger.kernel.org

commit ca138f368a36dba40d3ef4a53d64af2011cda3c7
Author: Fred Isaman <iisaman@netapp.com>
Date:   Thu Apr 5 15:26:36 2012 -0400

    NFS: check for req==NULL in nfs_try_to_update_request cleanup
    
    Signed-off-by: Fred Isaman <iisaman@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit adae0fe0ea87e8fb1a72dde304937c60759b495f
Author: Stanislav Kinsbursky <skinsbursky@parallels.com>
Date:   Thu Apr 5 21:04:37 2012 +0400

    SUNRPC: register PipeFS file system after pernet sybsystem
    
    PipeFS superblock creation routine relays on SUNRPC pernet data presense, which
    is created on register_pernet_subsys() call in SUNRPC module init function.
    Registering of PipeFS filesystem prior to registering of per-net subsystem
    leads to races (mount of PipeFS can dereference uninitialized data).
    
    Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
