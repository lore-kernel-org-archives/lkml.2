Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab0GERIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:08:16 -0400
Received: from cobra.newdream.net ([66.33.216.30]:52028 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0GERIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:08:15 -0400
Date: Mon, 5 Jul 2010 10:09:50 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for v2.6.35-rc5
Message-ID: <Pine.LNX.4.64.1007051002030.9203@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

These are mostly all one-liners, or nearly so.  Some endian fixes, a 
couple fixed memory leaks, some error path fixes, and typos.  An 
accounting bug could BUG with multiple mds's.  There are also a few fixes 
to the crush data distribution function when non-trivial policies are 
used.

Thanks!
sage


Sage Weil (10):
      ceph: fix map handler error path
      ceph: fix message memory leak, uninitialized variable
      ceph: fix crush map update decoding
      ceph: handle splice_dentry/d_materialize_unique error in readdir_prepopulate
      ceph: delay umount until all mds requests drop inode+dentry refs
      ceph: fix crush recursion
      ceph: fix crush CHOOSE_LEAF when type is already a leaf
      ceph: only release clean, unused caps with mds requests
      ceph: fix caps usage accounting for import (non-reserved) case
      ceph: fix crush device 'out' threshold to 1.0, not 0.1

Yehuda Sadeh (2):
      ceph: some endianity fixes
      ceph: fix caps debugfs entry

 fs/ceph/auth_x.c       |    2 +-
 fs/ceph/caps.c         |   21 ++++++++++++++-------
 fs/ceph/crush/mapper.c |   41 +++++++++++++++++++++++++++--------------
 fs/ceph/debugfs.c      |    2 +-
 fs/ceph/inode.c        |   19 ++++++++++++-------
 fs/ceph/mds_client.c   |    6 ++++++
 fs/ceph/messenger.c    |    4 +++-
 fs/ceph/mon_client.c   |    3 ++-
 fs/ceph/osd_client.c   |    3 ++-
 fs/ceph/osdmap.c       |    1 +
 10 files changed, 69 insertions(+), 33 deletions(-)
