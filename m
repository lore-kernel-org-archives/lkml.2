Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab0KVAaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 19:30:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63347 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab0KVAaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 19:30:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=cwH4s03DT0BxsQEpAFm4oU1NJkxtIbxhOm/3k+qXpFeEESGjll2tZu0dfiCiON5aDg
         CPmOSKxyTadPAkXeWlS8zVfbmRfuu0cCbxalq9m8CkDAisNw2Gm1MW9QKQItGgiGGSUY
         /RaXKWFOsbpoPszesCTQE4OAZuQlnWVqF7fBs=
Subject: [PATCH 0/4] Series short description
To: Eric Paris <eparis@redhat.com>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Scott Hassan <hassan@dotfunk.com>, Jan Kara <jack@suse.cz>,
        agruen@linbit.com, linux-kernel@vger.kernel.org, stefan@buettcher.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Date: Mon, 22 Nov 2010 00:31:41 +0000
Message-ID: <20101122002747.13674.69384.stgit@zaytsev.su>
User-Agent: StGit/0.15-97-g9680
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

So, it's time for the second version of the the fanotify
range patches.

The patch adds modification ranges to fsnotify events. Fanotify
is made to pass the range to the users.

This is useful for backup programs that work on huge files,
so that only a part of a modified file needs to be scanned
for changes.

changed. This is particularly useful for backup utilities that
work on huge files, so that only a part of the modified file
needs to be scanned for changes.

The series is split into 4 patches. The first one breaks the
ABI (but not API), and should get in before the .37 release,
or not at all. The last patch extends the ABI to handle event-
specific data ('options') in a backwards-compatible way.

You can also get the patchies from

git://git.zaytsev.su/git/linux-2.6.git branch fsnotify

A modified fanotify-example is available from

git://git.zaytsev.su/git/fanotify-example.git branch range

Changes since the first RFC:

1) Reworked the user interface, see the last patch.

2) Handle event merges properly.

3) Pass the range to fsnotify_parent().

3) Various small cleanups and fixes.

---

Alexey Zaytsev (4):
      fanotify: Shrink struct fanotify_event_metadata by 32 bits
      VFS: Tell fsnotify what part of the file might have changed
      fsnotify: Handle the file change ranges
      fanotify: Expose the file changes to the user


 fs/compat.c                        |    2 -
 fs/nfsd/vfs.c                      |    2 -
 fs/notify/fanotify/fanotify.c      |   19 +++++
 fs/notify/fanotify/fanotify_user.c |  132 +++++++++++++++++++++++++++++++-----
 fs/notify/fsnotify.c               |   24 ++++---
 fs/notify/inode_mark.c             |    2 -
 fs/notify/inotify/inotify_user.c   |    2 -
 fs/notify/notification.c           |   18 ++++-
 fs/open.c                          |    4 +
 fs/read_write.c                    |    4 +
 include/linux/fanotify.h           |   88 +++++++++++++++++++++---
 include/linux/fs.h                 |   14 ++++
 include/linux/fsnotify.h           |   68 +++++++++++--------
 include/linux/fsnotify_backend.h   |   31 +++++++-
 14 files changed, 330 insertions(+), 80 deletions(-)

--
