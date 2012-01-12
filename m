Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2ALTXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 14:23:23 -0500
Received: from cobra.newdream.net ([66.33.216.30]:51693 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab2ALTXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 14:23:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:message-id:mime-version:content-type; q=dns; s=
	newdream.net; b=qHNaUVVZSKq/1a9zeXlCQNp18YpfQXprR2q8QRSWAAgbjHPF
	OenOZkhoGp3uFUBBbTIkoVY8NjjrUUJGaerrq/sCzf7jouuXIjyTRmC1ylvy5VmW
	1x3PRDg1nL0G2GiPUTJGUeQASG1x7V3SXuzUJfrnW/oWjvEzYpcgrG3Clys=
Date: Thu, 12 Jan 2012 11:23:19 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.3-rc1
Message-ID: <Pine.LNX.4.64.1201121112180.13761@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is a conflict in here between d46cfba and a patch from Al, 3c5184e.  
Stephen has a fixup in -next, or you can resolve yourself (just make sure 
ceph_init_dentry() is called for both paths, and that the r_target_inode 
initialization isn't duplicated :).

The dir complete/dcache stuff is wired up again (this time conditionally 
via a mount option).  d_find_any_alias() is now exported to allow that.  
Then there are a few bug fixes (removexattr memory reservation, rwsem 
initialization, dentry initialization, iput under spinlock), some 
cleanups, and a small fix for the CRUSH mapping.

Thanks!
sage


Alex Elder (3):
      ceph: always initialize the dentry in open_root_dentry()
      rbd: initialize snap_rwsem in rbd_add()
      ceph: ensure prealloc_blob is in place when removing xattr

Sage Weil (7):
      ceph: remove unnecessary d_fsdata conditional checks
      crush: fix force for non-root TAKE
      ceph: avoid useless dget/dput in encode_fh
      ceph: avoid iput() while holding spinlock in ceph_dir_fsync
      libceph: remove useless return value for osd_client __send_request()
      vfs: export symbol d_find_any_alias()
      ceph: enable/disable dentry complete flags via mount option

Thomas Meyer (1):
      ceph: Use kmemdup rather than duplicating its implementation

Yehuda Sadeh (1):
      ceph: dereference pointer after checking for NULL

 Documentation/filesystems/ceph.txt |   18 ++++++--
 drivers/block/rbd.c                |    2 +
 fs/ceph/dir.c                      |   76 +++++++++++++++++++++---------------
 fs/ceph/export.c                   |    6 +--
 fs/ceph/inode.c                    |    3 +-
 fs/ceph/mds_client.c               |    4 +-
 fs/ceph/super.c                    |   21 ++++++++--
 fs/ceph/super.h                    |    1 +
 fs/ceph/xattr.c                    |   22 ++++++++++
 fs/dcache.c                        |   11 ++++-
 include/linux/dcache.h             |    1 +
 net/ceph/crush/mapper.c            |   11 ++++-
 net/ceph/crypto.c                  |    3 +-
 net/ceph/osd_client.c              |   21 +++-------
 14 files changed, 130 insertions(+), 70 deletions(-)
