Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab2G3WYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 18:24:41 -0400
Received: from mx2.netapp.com ([216.240.18.37]:35968 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab2G3WYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:24:40 -0400
X-IronPort-AV: E=Sophos;i="4.77,681,1336374000"; 
   d="scan'208";a="669818941"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client updates for 3.6...
Thread-Topic: [GIT PULL] Please pull NFS client updates for 3.6...
Thread-Index: AQHNbqIaxnKr0qI4+U2h+JY/zw9C7g==
Date: Mon, 30 Jul 2012 22:24:37 +0000
Message-ID: <1343687075.28035.8.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B280E77FC1E68F48B052A8780E2304CE@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6UMOofo007216

Hi Linus,

The following changes since commit 9249e17fe094d853d1ef7475dd559a2cc7e23d42:

  VFS: Pass mount flags to sget() (2012-07-14 16:38:34 +0400)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.6-1

for you to fetch changes up to f44106e2173f08ccb1c9195d85a6c22388b461c1:

  nfs: fix fl_type tests in NFSv4 code (2012-07-30 18:09:13 -0400)

Please note that due to my own family vacation, I've been asking Bryan
to collect some of the patches that came in the past 2 weeks. I'm
therefore planning on sending a second pull request on Wednesday
containing the stuff that he has been accumulating.

This is all stuff that I had queued up before I left, plus a couple of
regression fixes.

Cheers
  Trond

----------------------------------------------------------------
NFS client updates for Linux 3.6

Features include:
- More preparatory patches for modularising NFSv2/v3/v4.
  Split out the various NFSv2/v3/v4-specific code into separate
  files
- More preparation for the NFSv4 migration code
- Ensure that OPEN(O_CREATE) observes the pNFS mds threshold parameters
- pNFS fast failover when the data servers are down
- Various cleanups and debugging patches

----------------------------------------------------------------
Andy Adamson (6):
      NFSv4.1: Use session max response size for GETDEVICEINFO gdia_maxcount
      NFSv4.1 handle OPEN O_CREATE mdsthreshold
      NFSv4.1 return the LAYOUT for each file with failed DS connection I/O
      NFSv4.1 don't send LAYOUTCOMMIT if data resent through MDS
      NFSv4.1 mark layout when already returned
      NFSv4.1 do not send LAYOUTRETURN on emtpy plh_segs list

Bryan Schumaker (23):
      NFS: set_pnfs_layoutdriver() from nfs4_proc_fsinfo()
      NFS: Use nfs4_destroy_server() to clean up NFS v4
      NFS: Create a v4-specific fsync function
      NFS: Create a have_delegation rpc_op
      NFS: Create a return_delegation rpc op
      NFS: Create a free_client rpc_op
      NFS: Create an alloc_client rpc_op
      NFS: Create an read_pageio_init() function
      NFS: Create an write_pageio_init() function
      NFS: Create custom NFS v4 write_inode() function
      NFS: Split out NFS v2 inode operations
      NFS: Split out NFS v3 inode operations
      NFS: Split out NFS v4 inode operations
      NFS: Create an init_nfs_v4() function
      NFS: Initialize v4 sysctls from nfs_init_v4()
      NFS: Split out NFS v4 file operations
      NFS: Move the v4 getroot code to nfs4getroot.c
      NFS: Initialize the NFS v4 client from init_nfs_v4()
      NFS: Split out NFS v4 server creating code
      NFS: Create a single nfs_clone_super() function
      NFS: Split out the NFS v4 filesystem types
      NFS: Split out NFS v4 client functions
      NFS: exit_nfs_v4() shouldn't be an __exit function

Chuck Lever (10):
      NFS: Fix up TEST_STATEID and FREE_STATEID return code handling
      NFS: Don't free a state ID the server does not recognize
      NFS: State reclaim clears OPEN and LOCK state
      NFS: Clean up nfs41_check_expired_stateid()
      NFS: Clean up TEST_STATEID and FREE_STATEID error reporting
      NFS: nfs_getaclargs.acl_len is a size_t
      SUNRPC: Add rpcauth_list_flavors()
      NFS: When state recovery fails, waiting tasks should exit
      NFS: Treat NFS4ERR_CLID_INUSE as a fatal error
      NFS: Clean up nfs4_proc_setclientid() and friends

Fred Isaman (2):
      NFS: fix pnfs regression with directio reads
      NFS: fix pnfs regression with directio writes

Jeff Layton (1):
      nfs: fix fl_type tests in NFSv4 code

Joe Perches (1):
      sunrpc: clnt: Add missing braces

Randy Dunlap (1):
      nfs: fix stub return type warnings

Trond Myklebust (23):
      NFSv2/v3: Remove incorrect dprintks from the readdir reply code
      SUNRPC: xdr_read_pages needs to clear xdr->page_ptr.
      SUNRPC: Clean up xdr_set_iov()
      SUNRPC: Don't decode beyond the end of the RPC reply message
      SUNRPC: xdr_read_pages should return the amount of XDR encoded page data
      NFS: Let xdr_read_pages() check for buffer overflows
      SUNRPC: Add the helper xdr_stream_pos
      NFSv4: Simplify the GETATTR attribute length calculation
      NFSv3: Don't open code stream position calculation in decode_getacl3resok
      SUNRPC: Remove open coded stream position calculation in xdr_read_pages
      SUNRPC: Simplify the end-of-buffer calculation in xdr_read_pages
      SUNRPC: Clean up xdr_read_pages
      SUNRPC: Clean up xdr_enter_page
      NFSv4.1: Handle slot recalls before doing state recovery
      NFSv4.1: Clean up nfs4_recall_slot()
      NFSv4.1: Cleanup - move nfs4_has_session tests out of state manager loop
      NFSv4.1: Clean up nfs4_reclaim_lease
      SUNRPC: Remove unused function xdr_encode_pages
      NFSv4: Decode getdevicelist should use nfs4_verifier
      NFS: Cleanup - only store the write verifier in struct nfs_page
      NFS: Simplify NFSv4.1 Kconfig
      Merge commit '9249e17fe094d853d1ef7475dd559a2cc7e23d42' into nfs-for-3.6
      SUNRPC: Add a missing spin_unlock to gss_mech_list_pseudoflavors

Weston Andros Adamson (1):
      NFS: add more context to state manager error mesgs

 fs/nfs/Kconfig                        |   9 +-
 fs/nfs/Makefile                       |  11 +-
 fs/nfs/client.c                       | 685 +---------------------------------
 fs/nfs/delegation.c                   |   7 +-
 fs/nfs/delegation.h                   |  19 +-
 fs/nfs/dir.c                          | 107 +-----
 fs/nfs/direct.c                       |   6 +-
 fs/nfs/file.c                         | 179 ++-------
 fs/nfs/getroot.c                      |  50 ---
 fs/nfs/inode.c                        |  71 ++--
 fs/nfs/internal.h                     |  87 ++++-
 fs/nfs/nfs2xdr.c                      |  28 +-
 fs/nfs/nfs3proc.c                     |  46 +++
 fs/nfs/nfs3xdr.c                      |  43 +--
 fs/nfs/nfs4_fs.h                      |  33 +-
 fs/nfs/nfs4client.c                   | 663 ++++++++++++++++++++++++++++++++
 fs/nfs/nfs4file.c                     | 126 +++++++
 fs/nfs/nfs4filelayout.c               |  10 +-
 fs/nfs/nfs4filelayoutdev.c            |   2 +-
 fs/nfs/nfs4getroot.c                  |  49 +++
 fs/nfs/nfs4proc.c                     | 303 ++++++++++-----
 fs/nfs/nfs4state.c                    | 114 ++++--
 fs/nfs/nfs4super.c                    | 360 ++++++++++++++++++
 fs/nfs/nfs4sysctl.c                   |  68 ++++
 fs/nfs/nfs4xdr.c                      |  84 ++---
 fs/nfs/pnfs.c                         |  55 ++-
 fs/nfs/pnfs.h                         |  31 +-
 fs/nfs/proc.c                         |  38 ++
 fs/nfs/read.c                         |  16 +-
 fs/nfs/super.c                        | 438 ++--------------------
 fs/nfs/sysctl.c                       |  26 --
 fs/nfs/unlink.c                       |   2 +-
 fs/nfs/write.c                        |  34 +-
 include/linux/nfs_fs.h                |   8 -
 include/linux/nfs_fs_sb.h             |   3 +-
 include/linux/nfs_page.h              |   2 +-
 include/linux/nfs_xdr.h               |  16 +-
 include/linux/sunrpc/auth.h           |   2 +
 include/linux/sunrpc/gss_api.h        |   3 +-
 include/linux/sunrpc/xdr.h            |   6 +-
 net/sunrpc/auth.c                     |  54 +++
 net/sunrpc/auth_gss/auth_gss.c        |   1 +
 net/sunrpc/auth_gss/gss_mech_switch.c |  20 +-
 net/sunrpc/clnt.c                     |   3 +-
 net/sunrpc/xdr.c                      | 127 ++++---
 45 files changed, 2220 insertions(+), 1825 deletions(-)
 create mode 100644 fs/nfs/nfs4client.c
 create mode 100644 fs/nfs/nfs4file.c
 create mode 100644 fs/nfs/nfs4getroot.c
 create mode 100644 fs/nfs/nfs4super.c
 create mode 100644 fs/nfs/nfs4sysctl.c

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
