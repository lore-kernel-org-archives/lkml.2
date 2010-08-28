Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab0H1CKW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 22:10:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab0H1CKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 22:10:21 -0400
Subject: [GIT PULL] notification fixes
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 22:09:36 -0400
Message-ID: <1282961376.3284.126.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly bug fixes found when testing the fanotify vfsmounts.

The most serious bug (and only one affecting inotify and dnotify rather
than requiring fanotify to break something) was actually fixed
accidentally in "fsnotify: fix ignored mask handling between inode and
vfsmount marks".  It was possible for inotify to get events it didn't
request or even events with a 0 mask.

The only other interesting note is that "fanotify: resize pid and
reorder structure" will require users to rebuild any fanotify listeners.
It's an ABI change, not an API change, which should help us improve
performance in the future on strict alignment platforms (without
breaking ABI)

-Eric

The following changes since commit d4348c678977c7093438bbbf2067c49396ae941b:

  Merge branch 'perf-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-08-25 10:50:07 -0700)

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Andreas Gruenbacher (1):
      fanotify: Return EPERM when a process is not privileged

Eric Paris (7):
      fanotify: do not dereference inode_mark when it is unset
      fsnotify: reset used_inode and used_vfsmount on each pass
      fanotify: add MAINTAINERS entry
      fsnotify: fix ignored mask handling between inode and vfsmount marks
      fanotify: flush outstanding perm requests on group destroy
      fsnotify: fix list walk order
      fsnotify: drop two useless bools in the fnsotify main loop

Tvrtko Ursulin (2):
      fanotify: drop duplicate pr_debug statement
      fanotify: resize pid and reorder structure

 MAINTAINERS                        |    6 +++
 fs/notify/fanotify/fanotify.c      |    3 --
 fs/notify/fanotify/fanotify_user.c |   29 +++++++++++++++-
 fs/notify/fsnotify.c               |   68 +++++++++++++++++++-----------------
 include/linux/fanotify.h           |   13 ++-----
 include/linux/fsnotify_backend.h   |    1 +
 6 files changed, 74 insertions(+), 46 deletions(-)

