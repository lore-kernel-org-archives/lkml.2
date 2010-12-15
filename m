Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0LPRMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:12:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab0LPRMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:12:38 -0500
Subject: [GIT PULL] notification bug fixes
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, LinoSanfilippo@gmx.de,
        alexey.zaytsev@gmail.com, agruen@linbit.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 14:17:27 -0500
Message-ID: <1292440647.3042.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The notable fixes in this pull request include a potential deadlock when
fanotify listeners exit, an unpriv user kernel memory DoS in inotify,
and an API (although not ABI) change in fanotify's userspace message to
support expansion in the next release.

-Eric

--------
The following changes since commit e8a7e48bb248a1196484d3f8afa53bded2b24e71:

  Linux 2.6.37-rc4 (2010-11-29 20:42:04 -0800)

are available in the git repository at:
  git://git.infradead.org/users/eparis/notify.git for-linus

Alexey Zaytsev (1):
      fanotify: split version into version and metadata_len

Eric Paris (5):
      fanotify: deny permissions when no event was sent
      fanotify: remove packed from access response message
      inotify: stop kernel memory leak on file creation failure
      fanotify: do not leak user reference on allocation failure
      fanotify: fill in the metadata_len field on struct fanotify_event_metadata

Lino Sanfilippo (6):
      fanotify: if set by user unset FMODE_NONOTIFY before fsnotify_perm() is called
      fanotify: correct broken ref counting in case adding a mark failed
      fanotify: Dont allow a mask of 0 if setting or removing a mark
      fanotify: on group destroy allow all waiters to bypass permission check
      fanotify: Introduce FAN_NOFD
      fanotify: Dont try to open a file descriptor for the overflow event

 fs/namei.c                         |    3 +
 fs/notify/fanotify/fanotify.c      |    6 ++-
 fs/notify/fanotify/fanotify_user.c |   81 ++++++++++++++++++++++-------------
 fs/notify/inotify/inotify_user.c   |    1 +
 include/linux/fanotify.h           |   10 +++-
 include/linux/fsnotify.h           |    3 -
 include/linux/fsnotify_backend.h   |    2 +-
 7 files changed, 68 insertions(+), 38 deletions(-)

