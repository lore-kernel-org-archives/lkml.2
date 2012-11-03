Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab2KCTsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 15:48:45 -0400
Received: from mx12.netapp.com ([216.240.18.77]:35108 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab2KCTsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 15:48:43 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344236400"; 
   d="scan'208";a="278587411"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client bugfixes
Thread-Topic: [GIT PULL] Please pull NFS client bugfixes
Thread-Index: AQHNufw56h8oo3NFYE68y2YJWXLy9w==
Date: Sat, 3 Nov 2012 19:48:41 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA9092A6A40@SACEXCMBX04-PRD.hq.netapp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <54A6F33FAEA36F4DAA6D54E0925CE0EC@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA3Jmx72002696

Hi Linus,

The following changes since commit 08f05c49749ee655bef921d12160960a273aad47:

  Return the right error value when dup[23]() newfd argument is too large (2012-10-30 21:27:28 -0700)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.7-4

for you to fetch changes up to 998f40b550f257e436485291802fa938e4cf580f:

  NFS4: nfs4_opendata_access should return errno (2012-11-02 18:51:54 -0400)

----------------------------------------------------------------
NFS bugfixes for Linux 3.7

- Fix a bunch of deadlock situations:
  * State recovery can deadlock if we fail to release sequence ids before
    scheduling the recovery thread.
  * Calling deactivate_super() from an RPC workqueue thread can deadlock
    because of the call to rpc_shutdown_client.
- Display the device name correctly in /proc/*/mounts
- Fix a number of incorrect error return values:
  * When NFSv3 mounts fail due to a timeout.
  * On NFSv4.1 backchannel setup failure
  * On NFSv4 open access checks
- pnfs_find_alloc_layout() must check the layout pointer for NULL
- Fix a regression in the legacy DNS resolved

----------------------------------------------------------------
Ben Hutchings (1):
      nfs: Show original device name verbatim in /proc/*/mount{s,info}

Bryan Schumaker (1):
      NFS: Wait for session recovery to finish before returning

NeilBrown (1):
      NFS: fix bug in legacy DNS resolver.

Scott Mayhew (1):
      nfsv3: Make v3 mounts fail with ETIMEDOUTs instead EIO on mountd timeouts

Trond Myklebust (3):
      NFSv4.1: We must release the sequence id when we fail to get a session slot
      NFSv4: nfs4_locku_done must release the sequence id
      NFSv4: Initialise the NFSv4.1 slot table highest_used_slotid correctly

Weston Andros Adamson (3):
      NFS: add nfs_sb_deactive_async to avoid deadlock
      SUNRPC: return proper errno from backchannel_rqst
      NFS4: nfs4_opendata_access should return errno

Yanchuan Nian (1):
      nfs: Check whether a layout pointer is NULL before free it

 fs/nfs/dns_resolve.c          |  5 +++--
 fs/nfs/inode.c                |  5 ++++-
 fs/nfs/internal.h             |  6 +++--
 fs/nfs/mount_clnt.c           |  2 +-
 fs/nfs/namespace.c            | 19 +++++++++++-----
 fs/nfs/nfs4namespace.c        |  3 ++-
 fs/nfs/nfs4proc.c             | 46 +++++++++++++++++++++++---------------
 fs/nfs/pnfs.c                 |  4 ++--
 fs/nfs/super.c                | 51 ++++++++++++++++++++++++++++++++++++++++++-
 fs/nfs/unlink.c               |  2 +-
 net/sunrpc/backchannel_rqst.c |  2 +-
 11 files changed, 110 insertions(+), 35 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
