Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab0HBUAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:00:23 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34699 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab0HBUAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=V+DagO2i5gDf0pgznFKnTX5b83jDNBu4zyJonrZC7JHsLYloGqzwNpv1bBRYbp18ui
         ttRpP/qqzAzy6tF9yFK0CHSTiTwa/h8XFinGNQIN6mfZQr4hJFu+BAnJayrtM/YADmPX
         XeH0WG9RbwsBzseCP+muj0emTUD56/txQDmQc=
MIME-Version: 1.0
Date: Mon, 2 Aug 2010 15:00:19 -0500
Message-ID: <AANLkTinSL+50rE7XtYv6uoYpF0sM6tHSwrjJA24+51wr@mail.gmail.com>
Subject: [GIT PULL] 9p file system changes for the 2.6.36 merge window
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
   Please pull the following changes which represent the 9p changes
for the 2.6.36
merge window.  The bulk of the changes are related to support for a
new Linux-specific
variant of the 9P2000 protocol (9P2000.L) which include new extensions
supporting
extended attributes, and tighter mapped bindings for things like
supporting links,
symbolic links, special files, and Linux specific modes and
permissions.  Also included
are changes meant to address concerns you and Al Viro made with
respect to our path
resolution routines.

     Thanks,
         -eric

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:
  Linus Torvalds (1):
        Linux 2.6.35

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (7):
      net/9p: Handle the server returned error properly
      fs/9p: Pass the correct user credentials during attach
      net/9p: Implement attrwalk 9p call
      net/9p: Implement TXATTRCREATE 9p call
      fs/9p: Add support user. xattr
      fs/9p: Prevent parallel rename when doing fid_lookup
      fs/9p: destroy fid on failed remove

Dan Carpenter (1):
      9p: strlen() doesn't count the terminator

Eric Van Hensbergen (3):
      9p: Define and implement TLINK for 9P2000.L
      fs/9p: remove sparse warning in vfs_inode
      9p: fix sparse warnings in new xattr code

Fang Wenqi (1):
      virtio_9p.h needs <linux/types.h>

M. Mohan Kumar (4):
      9p: Make use of iounit for read/write
      9p: Implement TMKNOD
      9p: Implement TMKDIR
      9p: Implement LOPEN

Sripathi Kodi (3):
      9p: readdir implementation for 9p2000.L
      9p: getattr client implementation for 9P2000.L protocol.
      9p: Implement client side of setattr for 9P2000.L protocol.

Venkateswararao Jujjuri (JV) (3):
      9p: Define and implement TLINK for 9P2000.L
      9p: Define and implement TSYMLINK for 9P2000.L
      fs/9p: This patch implements TLCREATE for 9p2000.L protocol.

 fs/9p/Makefile            |    4 +-
 fs/9p/fid.c               |  111 +++++--
 fs/9p/v9fs.c              |    3 +-
 fs/9p/v9fs.h              |    1 +
 fs/9p/v9fs_vfs.h          |    1 +
 fs/9p/vfs_dir.c           |  134 +++++++-
 fs/9p/vfs_file.c          |   26 +-
 fs/9p/vfs_inode.c         |  757 +++++++++++++++++++++++++++++++++++++++++++--
 fs/9p/vfs_super.c         |   50 ++--
 fs/9p/xattr.c             |  160 ++++++++++
 fs/9p/xattr.h             |   27 ++
 fs/9p/xattr_user.c        |   80 +++++
 include/linux/virtio_9p.h |    1 +
 include/net/9p/9p.h       |  113 +++++++
 include/net/9p/client.h   |   33 ++
 net/9p/client.c           |  393 +++++++++++++++++++++++-
 net/9p/protocol.c         |   72 +++++
 net/9p/trans_fd.c         |    2 +-
 18 files changed, 1845 insertions(+), 123 deletions(-)
 create mode 100644 fs/9p/xattr.c
 create mode 100644 fs/9p/xattr.h
 create mode 100644 fs/9p/xattr_user.c
