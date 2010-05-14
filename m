Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab0ENQg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861Ab0ENQgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:36:53 -0400
Subject: [GIT PULL] notification updates for 2.6.34-rcX
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:36:20 -0400
Message-ID: <1273854980.2826.28.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This branch holds a couple of bug fixes (two of which are actually
stable material).  A pathological race which would put us in a use after
free / double free situation when one thread attempts to delete an
inotify watch while another thread is still adding that watch.  A memory
leak and a Kconfig issue.

Thanks
-Eric

The following changes since commit 6a251b0ab67989f468f4cb65179e0cf40cf8c295:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../sameo/mfd-2.6

are available in the git repository at:

  git://git.infradead.org/users/eparis/notify.git for-linus

Eric Paris (2):
      inotify: clean up the inotify_add_watch out path
      inotify: race use after free/double free in inotify inode marks

Pavel Emelyanov (1):
      inotify: don't leak user struct on inotify release

Russell King (1):
      Inotify: undefined reference to `anon_inode_getfd'

 fs/notify/inotify/Kconfig            |    1 +
 fs/notify/inotify/inotify_fsnotify.c |    2 ++
 fs/notify/inotify/inotify_user.c     |   16 ++++++++--------
 3 files changed, 11 insertions(+), 8 deletions(-)

