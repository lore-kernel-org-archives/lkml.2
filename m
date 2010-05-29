Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab0E2Wqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 18:46:33 -0400
Received: from cobra.newdream.net ([66.33.216.30]:52633 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab0E2Wqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 18:46:31 -0400
Date: Sat, 29 May 2010 15:46:37 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] more Ceph bits for 2.6.35-rc1
Message-ID: <Pine.LNX.4.64.1005291535070.27550@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these last few fixes and cleanups for 2.6.35-rc1 from 

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

The main item here is a fix when waiting for mds request completion, which 
includes adding wait_for_completion_killable_timeout() to the completion 
api.  There is also a fix for a use after free on umount, a couple memory 
leaks, some non-critial protocol items, and a couple cleanups.

Thanks-
sage


Andrea Gelmini (1):
      ceph: removed duplicated #includes

Julia Lawall (1):
      fs/ceph: Use ERR_CAST

Sage Weil (9):
      sched: add wait_for_completion_killable_timeout
      ceph: make mds requests killable, not interruptible
      ceph: avoid possible null dereference
      ceph: do not resend mon requests on auth ticket renewal
      ceph: renew auth tickets before they expire
      ceph: make lease code DN specific
      ceph: close out mds, osd connections before stopping auth
      ceph: fix leak of osd authorizer
      ceph: clean up on forwarded aborted mds request

 fs/ceph/auth.c             |    7 +++----
 fs/ceph/auth.h             |    6 ++++++
 fs/ceph/auth_none.c        |    8 ++++++++
 fs/ceph/auth_x.c           |   12 ++++++++++++
 fs/ceph/ceph_fs.h          |   21 +++++++++++----------
 fs/ceph/dir.c              |    2 +-
 fs/ceph/export.c           |    2 +-
 fs/ceph/file.c             |    2 +-
 fs/ceph/inode.c            |    2 +-
 fs/ceph/mds_client.c       |   21 +++++++++++++--------
 fs/ceph/messenger.c        |    6 ++++++
 fs/ceph/messenger.h        |    1 +
 fs/ceph/mon_client.c       |    5 ++++-
 fs/ceph/osd_client.c       |    7 ++++++-
 fs/ceph/osdmap.c           |    2 +-
 fs/ceph/super.c            |   12 ++++++++++--
 fs/ceph/super.h            |    1 -
 include/linux/completion.h |    2 ++
 kernel/sched.c             |   17 +++++++++++++++++
 19 files changed, 104 insertions(+), 32 deletions(-)
