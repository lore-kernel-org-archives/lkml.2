Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0HZWOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 18:14:16 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33448 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab0HZWOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 18:14:14 -0400
Date: Thu, 26 Aug 2010 15:14:59 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 2.6.36-rc3
Message-ID: <Pine.LNX.4.64.1008261506480.26593@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes for 2.6.36-rc3 from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are some fixed up compile warnings (32 bit archs), some error return 
code fixes, an argument inversion for list_move_tail, an mm cleanup (I 
duplicated a non-exported helper in 2.6.27 or so and things changed a bit 
since then), and some uninitialized fields.  The rest are fixes with async 
metadata writeback and making it coherent with respect to snapshots.

Thanks!
sage


Alan Cox (1):
      ceph: Fix warnings

Dan Carpenter (3):
      ceph: ceph_get_inode() returns an ERR_PTR
      ceph: ceph_mdsc_build_path() returns an ERR_PTR
      ceph: fix get_ticket_handler() error handling

Henry C Chang (1):
      ceph: fix osd request lru adjustment when sending request

Michael Rubin (1):
      mm: exporting account_page_dirty

Sage Weil (9):
      ceph: fix multiple mds session shutdown
      ceph: fix xattr cap writeback
      ceph: include dirty xattrs state in snapped caps
      ceph: queue cap snap writeback for realm children on snap update
      ceph: direct requests in snapped namespace based on nonsnap parent
      ceph: don't improperly set dir complete when holding EXCL cap
      ceph: maintain i_head_snapc when any caps are dirty, not just for data
      ceph: initialize fields on new dentry_infos
      ceph: don't BUG on ENOMEM during mds reconnect

 fs/ceph/addr.c       |   12 +----
 fs/ceph/auth_x.c     |   15 ++++---
 fs/ceph/caps.c       |   32 +++++++++++----
 fs/ceph/debugfs.c    |    4 ++
 fs/ceph/dir.c        |    2 +-
 fs/ceph/inode.c      |    5 +-
 fs/ceph/locks.c      |   14 ++++--
 fs/ceph/mds_client.c |  101 +++++++++++++++++++++++++++++++-------------------
 fs/ceph/mds_client.h |    3 +-
 fs/ceph/osd_client.c |    2 +-
 fs/ceph/snap.c       |   89 ++++++++++++++++++++++++++++---------------
 fs/ceph/super.h      |   11 +++--
 fs/ceph/xattr.c      |    1 +
 mm/page-writeback.c  |    1 +
 14 files changed, 185 insertions(+), 107 deletions(-)
