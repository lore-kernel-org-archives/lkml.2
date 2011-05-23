Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab1EWVtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 17:49:11 -0400
Received: from relay1.sgi.com ([192.48.179.29]:49432 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757694Ab1EWVtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 17:49:08 -0400
From: Alex Elder <aelder@sgi.com>
Message-Id: <201105232149.p4NLn2PV022851@stout.americas.sgi.com>
Date: Mon, 23 May 2011 16:49:02 -0500
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update 1 for 2.6.40-rc1
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ea2b50ef4c9e030749ae473e95258f477c3a68ca:

  Merge branch 'x86-apic-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-05-23 12:54:15 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (6):
      xfs: optimize AGFL refills
      xfs: do not immediately reuse busy extent ranges
      xfs: exact busy extent tracking
      xfs: reduce the number of pagb_lock roundtrips in xfs_alloc_clear_busy
      xfs: fix compiler warning in xfs_trace.h
      xfs: add an x86 compat handler for XFS_IOC_ZERO_RANGE

Dave Chinner (10):
      xfs: ensure reclaim cursor is reset correctly at end of AG
      xfs: exit AIL push work correctly when AIL is empty
      xfs: always push the AIL to the target
      xfs: make AIL target updates and compares 32bit safe.
      xfs: fix race condition in AIL push trigger
      xfs: fix duplicate workqueue initialisation
      xfs: fix xfs_itruncate_start tracing
      xfs: avoid getting stuck during async inode flushes
      xfs: reset buffer pointers before freeing them
      xfs: obey minleft values during extent allocation correctly

David Sterba (1):
      xfs: cleanup duplicate initializations

Joe Perches (1):
      xfs: kill off xfs_printk()

 fs/xfs/linux-2.6/xfs_buf.c     |   22 +-
 fs/xfs/linux-2.6/xfs_buf.h     |    1 +
 fs/xfs/linux-2.6/xfs_ioctl32.c |    3 +-
 fs/xfs/linux-2.6/xfs_ioctl32.h |    1 +
 fs/xfs/linux-2.6/xfs_linux.h   |    1 +
 fs/xfs/linux-2.6/xfs_message.c |   20 +-
 fs/xfs/linux-2.6/xfs_message.h |    7 +-
 fs/xfs/linux-2.6/xfs_super.c   |    4 -
 fs/xfs/linux-2.6/xfs_sync.c    |   11 +
 fs/xfs/linux-2.6/xfs_trace.h   |   76 ++---
 fs/xfs/xfs_ag.h                |    1 -
 fs/xfs/xfs_alloc.c             |  844 +++++++++++++++++++++++++++------------
 fs/xfs/xfs_alloc.h             |   15 +-
 fs/xfs/xfs_alloc_btree.c       |   13 +-
 fs/xfs/xfs_dfrag.c             |    6 +-
 fs/xfs/xfs_inode.c             |    2 +-
 fs/xfs/xfs_inode_item.c        |    1 -
 fs/xfs/xfs_log.c               |   15 +-
 fs/xfs/xfs_log.h               |    2 -
 fs/xfs/xfs_log_cil.c           |    5 +-
 fs/xfs/xfs_log_priv.h          |    2 +
 fs/xfs/xfs_log_recover.c       |   75 ++--
 fs/xfs/xfs_mount.c             |    4 +-
 fs/xfs/xfs_trans.c             |    6 +-
 fs/xfs/xfs_trans_ail.c         |   47 ++-
 fs/xfs/xfs_types.h             |    2 -
 26 files changed, 748 insertions(+), 438 deletions(-)
