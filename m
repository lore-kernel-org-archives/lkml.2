Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab2HVOm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:42:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48340 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab2HVOmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:42:44 -0400
Date: Wed, 22 Aug 2012 15:42:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git for -rc3
Message-ID: <20120822144243.GN23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes, with an unexpected detour into vfio refcounting logics
(fell out when digging in an analog of eventpoll race in there).  Please,
pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (7):
      mqueue: lift mnt_want_write() outside ->i_mutex, clean up a bit
      vfio: don't dereference after kfree...
      introduce kref_put_mutex()
      vfio: get rid of open-coding kref_put_mutex
      vfio: get rid of vfio_device_put()/vfio_group_get_device* races
      vfio: grab vfio_device reference *before* exposing the sucker via fd_install()
      eventpoll: use-after-possible-free in epoll_create1()

Eric Dumazet (1):
      task_work: add a scheduling point in task_work_run()

Randy Dunlap (1):
      fs: fix fs/namei.c kernel-doc warnings

Diffstat:
 drivers/vfio/vfio.c  |   19 +++++---------
 fs/eventpoll.c       |    2 +-
 fs/namei.c           |    2 +
 include/linux/kref.h |   18 ++++++++++++++
 ipc/mqueue.c         |   61 +++++++++++++++++++++++---------------------------
 kernel/task_work.c   |    1 +
 6 files changed, 57 insertions(+), 46 deletions(-)
