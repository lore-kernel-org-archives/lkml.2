Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab0J1Olj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:41:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35993 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0J1Olh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=GHehMdhqRNjgSOe3Hh8JY2TTx/0EPgQuU4smWpXO1OIove/7EnZdLXbJR9yqF7SOUM
         cJdKQQ/+40deH/a4L5GAkPsgIGafVDJfMT3ICmHfTpBOMjPgLqGCZ32Luh6pot2qQ06Z
         wYEII9iRm4G5iEFsjimerH/SuAHVdbOm+h+kE=
MIME-Version: 1.0
Date: Thu, 28 Oct 2010 09:41:35 -0500
Message-ID: <AANLkTinyBTXm8iFhNrJj9_e6hSPKFTDEHgC1=J4VfJY6@mail.gmail.com>
Subject: [GIT PULL] 9p file system changes for 2.6.37 merge window
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 81280572ca6f54009edfa4deee563e8678784218:

  Merge branch 'upstream-merge' of
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2010-10-27
21:54:31 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (10):
      fs/9p: Implement POSIX ACL permission checking function
      fs/9p: Add xattr callbacks for POSIX ACL
      fs/9p: Implement setting posix acl
      fs/9p: Update ACL on chmod
      fs/9p: Implement create time inheritance
      fs/9p: Add access = client option to opt in acl evaluation.
      fs/9p: Use mknod 9p operation on create without open request
      fs/9p: Add missing iput in v9fs_vfs_lookup
      fs/9p: Use generic_file_open with lookup_instantiate_filp
      net/9p: Return error if we fail to encode protocol data

Arun R Bharadwaj (1):
      net/9p: This patch implements TLERROR/RLERROR on the 9P client.

Dan Carpenter (1):
      9p: remove unneeded checks

Harsh Prateek Bora (2):
      fs/9p: setrlimit fix for 9p write
      fs/9p: mkdir fix for setting S_ISGID bit as per parent directory

M. Mohan Kumar (4):
      9p: Implement TLOCK
      9p: Implement TGETLOCK
      9p: Use V9FS_MAGIC in statfs
      9p: Implement TREADLINK operation for 9p2000.L

Sanchit Garg (1):
      net/9p: Return error on read with NULL buffer

Sripathi Kodi (1):
      9p: Pass the correct end of buffer to p9dirent_read

Venkateswararao Jujjuri (JV) (5):
      [fs/9p] Add file_operations for cached mode in dotl protocol.
      [9p] Introduce client side TFSYNC/RFSYNC for dotl.
      [net/9p]Serialize virtqueue operations to make VirtIO transport SMP safe.
      net/9p: Add waitq to VirtIO transport.
      9p: Add datasync to client side TFSYNC/RFSYNC for dotl

jvrao (3):
      9p: Add a Direct IO support for non-cached operations.
      fs/9p: Remove the redundant rsize calculation in v9fs_file_write()
      net/9p: Add a Warning to catch NULL fids passed to p9_client_clunk().

 Documentation/filesystems/9p.txt |    4 +-
 fs/9p/Kconfig                    |   13 ++
 fs/9p/Makefile                   |    1 +
 fs/9p/acl.c                      |  392 ++++++++++++++++++++++++++++++++++++++
 fs/9p/acl.h                      |   49 +++++
 fs/9p/fid.c                      |    1 +
 fs/9p/v9fs.c                     |   22 ++-
 fs/9p/v9fs.h                     |   10 +-
 fs/9p/v9fs_vfs.h                 |    4 +
 fs/9p/vfs_addr.c                 |   30 +++
 fs/9p/vfs_dir.c                  |    4 +-
 fs/9p/vfs_file.c                 |  265 ++++++++++++++++++++++++--
 fs/9p/vfs_inode.c                |  253 ++++++++++++++++++-------
 fs/9p/vfs_super.c                |   14 +-
 fs/9p/xattr.c                    |   52 +++--
 fs/9p/xattr.h                    |    6 +
 include/linux/magic.h            |    1 +
 include/net/9p/9p.h              |   54 ++++++
 include/net/9p/client.h          |    4 +
 net/9p/client.c                  |  178 +++++++++++++++--
 net/9p/protocol.c                |    5 +-
 net/9p/trans_virtio.c            |   76 ++++++--
 22 files changed, 1288 insertions(+), 150 deletions(-)
 create mode 100644 fs/9p/acl.c
 create mode 100644 fs/9p/acl.h
