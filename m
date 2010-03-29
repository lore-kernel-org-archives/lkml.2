Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0C2VAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 17:00:31 -0400
Received: from cobra.newdream.net ([66.33.216.30]:42309 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766Ab0C2VA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 17:00:28 -0400
Date: Mon, 29 Mar 2010 14:01:49 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 2.6.34-rc3
Message-ID: <Pine.LNX.4.64.1003291007190.26704@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the current set of Ceph fixes for 2.6.34-rc3 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There are a lot of bug fixes here, accumulated since the original pull 
request was sent during the merge window.  A few client hangs, some 
oopses, authentication fixes, and failure handling fixes.  There are also 
a handful of cleanups mixed in here that didn't seem worth untangling from 
the bug fixes, as well as some documentation updates that should make it 
into 2.6.34.

I'm assuming I should send these to you sooner rather than later, although 
if you prefer a consolidated pull later in the cycle I can do that too.

Also, thanks for pulling Ceph into your tree!  It's already making a 
difference in terms of code review and testing.

Thanks-
sage

---

Cheng Renquan (1):
      ceph: some documentations fixes

Dan Carpenter (1):
      ceph: handle kmalloc() failure

Sage Weil (26):
      ceph: implemented caps should always be superset of issued caps
      ceph: add missing locking to protect i_snap_realm_item during split
      ceph: fix inode removal from snap realm when racing with migration
      ceph: fix authenticator timeout
      ceph: fix authenticator buffer size calculation
      ceph: release old ticket_blob buffer
      ceph: clean up service ticket decoding
      ceph: fix null pointer deref of r_osd in debug output
      ceph: drop unnecessary WARN_ON in caps migration
      ceph: fix session locking in handle_caps, ceph_check_caps
      ceph: clean up handle_cap_grant, handle_caps wrt session mutex
      ceph: only release unused caps with mds requests
      ceph: fix mds sync() race with completing requests
      ceph: fix pg pool decoding from incremental osdmap update
      ceph: prevent dup stale messages to console for restarting mds
      ceph: fix connection fault con_work reentrancy problem
      ceph: rename r_sent_stamp r_stamp
      ceph: avoid reopening osd connections when address hasn't changed
      ceph: fix snap rebuild condition
      ceph: make write_begin wait propagate ERESTARTSYS
      ceph: propagate mds session allocation failures to caller
      ceph: fix session check on mds reply
      ceph: fix possible double-free of mds request reference
      ceph: avoid loaded term 'OSD' in documention
      ceph: fix use after free on mds __unregister_request
      ceph: update discussion list address in MAINTAINERS

 Documentation/filesystems/00-INDEX |    2 +
 Documentation/filesystems/ceph.txt |   11 +++--
 MAINTAINERS                        |    2 +-
 fs/ceph/addr.c                     |   10 ++++-
 fs/ceph/auth_x.c                   |   53 ++++++++++++++++++-------
 fs/ceph/caps.c                     |   73 +++++++++++++++++++-----------------
 fs/ceph/dir.c                      |    4 +-
 fs/ceph/inode.c                    |   16 ++++++++
 fs/ceph/mds_client.c               |   43 ++++++++++++++++-----
 fs/ceph/messenger.c                |   19 ++++-----
 fs/ceph/messenger.h                |    1 +
 fs/ceph/osd_client.c               |   29 ++++++++++----
 fs/ceph/osd_client.h               |    2 +-
 fs/ceph/osdmap.c                   |   17 +++++---
 fs/ceph/snap.c                     |    6 ++-
 15 files changed, 191 insertions(+), 97 deletions(-)
