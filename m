Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab0J3SoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 14:44:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab0J3SoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 14:44:13 -0400
Subject: [GIT PULL] notification tree
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Oct 2010 14:43:35 -0400
Message-ID: <1288464215.3017.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The notification tree has patches to address a number of fanotify
complaints from last cycle.  The most important being the (ABI
compatible) addition of 'classes' which will allow things like
hierarchical storage managers to receive events before scanners or
indexers.  It also includes default limits on the amount of memory an
fanotify listener can consume and other minor changes.  An updated
example program which makes use of most all of the fanotify feature set
can be found at

http://git.infradead.org/users/eparis/fanotify-example.git

---

The following changes since commit 2d10d8737ccdba752d60106abbc6ed4f37404923:

  Merge branches 'x86-fixes-for-linus' and 'x86-uv-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-10-29 18:58:00 -0700)

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Andrew Morton (1):
      fs/notify/fanotify/fanotify_user.c: fix warnings

Eric Paris (17):
      fanotify: allow fanotify to be built
      fsnotify: implement ordering between notifiers
      fanotify: implement fanotify listener ordering
      fanotify: use __aligned_u64 in fanotify userspace metadata
      fsnotify: correctly handle return codes from listeners
      fsnotify: call fsnotify_parent in perm events
      fanotify: allow userspace to flush all marks
      fanotify: ignore fanotify ignore marks if open writers
      fsnotify: implement a default maximum queue depth
      fanotify: allow userspace to override max queue depth
      fanotify: limit the number of marks in a single fanotify group
      fanotify: allow userspace to override max marks
      fanotify: limit number of listeners per user
      fanotify: do not send events for irregular files
      fsnotify: rename FS_IN_ISDIR to FS_ISDIR
      fanotify: ignore events on directories unless specifically requested
      fanotify: do not recalculate the mask if the ignored mask changed

Lino Sanfilippo (2):
      make fanotify_read() restartable across signals
      Ensure FMODE_NONOTIFY is not set by userspace

Richard Kennedy (1):
      fsnotify: remove alignment padding from fsnotify_mark on 64 bit builds

Stefan Hajnoczi (1):
      fanotify: Fix FAN_CLOSE comments

 fs/notify/Kconfig                  |    2 +-
 fs/notify/fanotify/fanotify.c      |   27 ++++++++--
 fs/notify/fanotify/fanotify_user.c |   98 +++++++++++++++++++++++++++++++++---
 fs/notify/fsnotify.c               |   35 ++++++++-----
 fs/notify/inode_mark.c             |    9 +++-
 fs/notify/inotify/inotify_user.c   |    2 +-
 fs/notify/vfsmount_mark.c          |    6 ++-
 include/linux/Kbuild               |    1 +
 include/linux/fanotify.h           |   36 ++++++++++---
 include/linux/fsnotify.h           |   38 ++++++++------
 include/linux/fsnotify_backend.h   |   26 +++++++--
 include/linux/sched.h              |    3 +
 12 files changed, 219 insertions(+), 64 deletions(-)

