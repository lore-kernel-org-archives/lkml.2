Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab2ILTTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:19:40 -0400
Received: from mx2.netapp.com ([216.240.18.37]:17856 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026Ab2ILTTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:19:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,411,1344236400"; 
   d="scan'208";a="688877432"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        "Linux NFS mailing list" <linux-nfs@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client bugfixes
Thread-Topic: [GIT PULL] Please pull NFS client bugfixes
Thread-Index: AQHNkRuMUodL8rhL7kKXqOczsvcH5w==
Date: Wed, 12 Sep 2012 19:19:37 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908F9F0CD@SACEXCMBX04-PRD.hq.netapp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <09C662CF58114E4A9BF7D8451BABA6D6@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8CJK3RF031359

Hi Linus,

The following changes since commit 086600430493e04b802bee6e5b3ce0458e4eb77f:

  NFSv3: Ensure that do_proc_get_root() reports errors correctly (2012-08-20 12:52:42 -0400)

are available in the git repository at:

  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.6-4

for you to fetch changes up to 7b281ee026552f10862b617a2a51acf49c829554:

  NFS: fsync() must exit with an error if page writeback failed (2012-09-11 15:38:32 -0400)

----------------------------------------------------------------
NFS client bugfixes for Linux 3.6

- Final (hopefully) fix for the range checking code in NFSv4 getacl. This
  should fix the Oopses being seen when the acl size is close to PAGE_SIZE.
- Fix a regression with the legacy binary mount code
- Fix a regression in the readdir cookieverf initialisation
- Fix an RPC over UDP regression
- Ensure that we report all errors in the NFSv4 open code
- Ensure that fsync() reports all relevant synchronisation errors.

----------------------------------------------------------------
Trond Myklebust (6):
      NFS: Fix the initialisation of the readdir 'cookieverf' array
      NFS: Fix a problem with the legacy binary mount code
      NFSv4: Fix range checking in __nfs4_get_acl_uncached and __nfs4_proc_set_acl
      NFSv4: Fix buffer overflow checking in __nfs4_get_acl_uncached
      SUNRPC: Fix a UDP transport regression
      NFS: fsync() must exit with an error if page writeback failed

Weston Andros Adamson (1):
      NFS: return error from decode_getfh in decode open

 fs/nfs/file.c                   |  4 ++-
 fs/nfs/inode.c                  |  2 +-
 fs/nfs/nfs3proc.c               |  2 +-
 fs/nfs/nfs4file.c               |  4 ++-
 fs/nfs/nfs4proc.c               | 55 +++++++++++++++++++----------------------
 fs/nfs/nfs4xdr.c                | 17 ++++++-------
 fs/nfs/super.c                  |  2 ++
 include/linux/nfs_fs.h          |  5 ----
 include/linux/nfs_xdr.h         |  2 +-
 include/linux/sunrpc/xprt.h     |  3 +++
 net/sunrpc/xprt.c               | 34 ++++++++++++++-----------
 net/sunrpc/xprtrdma/transport.c |  1 +
 net/sunrpc/xprtsock.c           |  3 +++
 13 files changed, 70 insertions(+), 64 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
