Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0ECWjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:39:43 -0400
Received: from cobra.newdream.net ([66.33.216.30]:53018 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab0ECWjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:39:41 -0400
Date: Mon, 3 May 2010 15:42:25 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] ceph fixes for 2.6.34-rc7
Message-ID: <Pine.LNX.4.64.1005031531330.23536@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

The main items are fixes for rename, a direct io oops, and a mismatched 
spin_unlock.  The others fix less common bugs.  The last batch of testing 
has gone smoothly, so hopefully this will be the last before 2.6.34.

Thanks-
sage

---

Sage Weil (11):
      ceph: clear dir complete on d_move
      ceph: fix snap realm splits
      ceph: print more useful version info on module load
      ceph: fix leaked spinlock during mds reconnect
      ceph: add missing #includes
      ceph: fix seq counting for skipped messages
      ceph: discard incoming messages with bad seq #
      ceph: fix direct io truncate offset
      ceph: clear dir complete, invalidate dentry on replayed rename
      ceph: fix lockless caps check
      ceph: remove bad auth_x kmem_cache

 fs/ceph/addr.c      |    2 +-
 fs/ceph/auth.c      |    1 +
 fs/ceph/auth_none.h |    2 ++
 fs/ceph/auth_x.c    |   32 ++++++++++----------------------
 fs/ceph/caps.c      |    2 +-
 fs/ceph/dir.c       |    9 +++++++++
 fs/ceph/file.c      |    3 ++-
 fs/ceph/inode.c     |    4 ++++
 fs/ceph/messenger.c |   22 ++++++++++++++++++++++
 fs/ceph/snap.c      |   24 ++++++++++++++----------
 fs/ceph/super.c     |    7 ++++---
 fs/ceph/super.h     |    1 +
 12 files changed, 71 insertions(+), 38 deletions(-)

