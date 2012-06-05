Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760755Ab2FENKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:10:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48161 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991Ab2FENKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:10:04 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, dhowells@redhat.com,
        mszeredi@suse.cz
Subject: [PATCH 00/21] vfs: atomic open v6 (part 2)
Date: Tue,  5 Jun 2012 15:10:11 +0200
Message-Id: <1338901832-14049-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part 2 of the atomic open series.  It introduces i_op->atomic_open() and
converts filesystems that abuse ->lookup() and ->create() to use this new
interface instead.

This version has one bugfix and several cleanups, reported by David Howells.
Also updated documentation in Documentation/filesytems/{vfs.txt,Locking}.

Al, please apply.

git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git atomic-open.v6

Thanks,
Miklos
---

Miklos Szeredi (21):
      vfs: do_last(): inline lookup_slow()
      vfs: do_last(): separate O_CREAT specific code
      vfs: do_last(): common slow lookup
      vfs: add lookup_open()
      vfs: lookup_open(): expand lookup_hash()
      vfs: add i_op->atomic_open()
      nfs: implement i_op->atomic_open()
      nfs: clean up ->create in nfs_rpc_ops
      nfs: don't use nd->intent.open.flags
      nfs: don't use intents for checking atomic open
      fuse: implement i_op->atomic_open()
      cifs: implement i_op->atomic_open()
      ceph: remove unused arg from ceph_lookup_open()
      ceph: implement i_op->atomic_open()
      9p: implement i_op->atomic_open()
      vfs: remove open intents from nameidata
      vfs: do_last(): clean up error handling
      vfs: do_last(): clean up labels
      vfs: do_last(): clean up bool
      vfs: do_last(): clean up retry
      vfs: move O_DIRECT check to common code

---
 Documentation/filesystems/Locking |    4 +
 Documentation/filesystems/vfs.txt |   11 +
 fs/9p/vfs_inode.c                 |  169 ++++++++-----
 fs/9p/vfs_inode_dotl.c            |   52 +++--
 fs/ceph/dir.c                     |   68 ++++--
 fs/ceph/file.c                    |   22 +-
 fs/ceph/super.h                   |    6 +-
 fs/cifs/cifsfs.c                  |    1 +
 fs/cifs/cifsfs.h                  |    3 +
 fs/cifs/dir.c                     |  437 ++++++++++++++++++---------------
 fs/fuse/dir.c                     |   94 +++++--
 fs/internal.h                     |    8 +-
 fs/namei.c                        |  492 ++++++++++++++++++++++++++-----------
 fs/nfs/dir.c                      |  242 ++++++++-----------
 fs/nfs/nfs3proc.c                 |    2 +-
 fs/nfs/nfs4proc.c                 |   37 +--
 fs/nfs/proc.c                     |    2 +-
 fs/open.c                         |   91 ++-----
 include/linux/fs.h                |    7 +
 include/linux/namei.h             |   11 -
 include/linux/nfs_xdr.h           |    2 +-
 21 files changed, 1023 insertions(+), 738 deletions(-)

