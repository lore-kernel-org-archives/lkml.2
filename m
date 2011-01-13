Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1ALX7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 18:59:31 -0500
Received: from cobra.newdream.net ([66.33.216.30]:56615 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501Ab1ALX73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 18:59:29 -0500
Date: Wed, 12 Jan 2011 16:05:48 -0800 (PST)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph changes for 2.6.38-rc1
Message-ID: <Pine.LNX.4.64.1101121530360.6611@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates for 2.6.38 from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are a few error path fixes (libceph and rbd), some ceph code 
cleanup, improved support for (server-side) directory hashing, and some 
patches from Tejun switching to the new workqueue API and removing 
unnecessary hijinks that the workqueues can handle themselves.

Thanks!
sage


Jesper Juhl (1):
      ceph: Always free allocated memory in osdmap_decode()

Sage Weil (4):
      ceph: add dir_layout to inode
      ceph: implement DIRLAYOUTHASH feature to get dir layout from MDS
      ceph: drop redundant r_mds field
      ceph: associate requests with opening sessions

Tejun Heo (2):
      ceph: fsc->*_wq's aren't used in memory reclaim path
      net/ceph: make ceph_msgr_wq non-reentrant

Tracey Dent (1):
      ceph: Makefile: Remove unnessary code

Yehuda Sadeh (1):
      rbd: fix cleanup when trying to mount inexistent image

 drivers/block/rbd.c            |   19 ++++++++++---
 fs/ceph/Makefile               |   23 +---------------
 fs/ceph/debugfs.c              |    9 ++++--
 fs/ceph/dir.c                  |   20 ++++++++++++++
 fs/ceph/export.c               |    2 +-
 fs/ceph/inode.c                |    4 +++
 fs/ceph/mds_client.c           |   56 +++++++++++++++++++++++++--------------
 fs/ceph/mds_client.h           |    2 +-
 fs/ceph/super.c                |   13 ++++++---
 fs/ceph/super.h                |    2 +
 include/linux/ceph/ceph_fs.h   |   16 +++++++++--
 include/linux/ceph/messenger.h |    5 ---
 net/ceph/ceph_hash.c           |    3 ++
 net/ceph/messenger.c           |   46 +-------------------------------
 net/ceph/osdmap.c              |    4 ++-
 15 files changed, 116 insertions(+), 108 deletions(-)
