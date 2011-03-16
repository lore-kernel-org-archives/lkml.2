Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab1CPX4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 19:56:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38233 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1CPX4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 19:56:11 -0400
Date: Wed, 16 Mar 2011 23:56:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] mnt_devname queue
Message-ID: <20110316235608.GY22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Kills ->mnt_devname mangling in NFS, completes switch from ->get_sb()
to ->mount() (and kills the remnants of ->get_sb() helpers), makes /proc/mounts
and /proc/*/mountinfo show the right thing after mount --bind on NFS.  Trond
has ACKed the nfs side of things and suggested to push through the vfs tree,
so please pull from
git:git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ mnt_devname

Shortlog:
Al Viro (8):
      nfs: propagate devname to nfs{,4}_get_root()
      nfs: store devname at disconnected NFS roots
      nfs: make nfs_path() work without vfsmount
      nfs: nfs_do_{ref,sub}mount() superblock argument is redundant
      vfs: new superblock methods to override /proc/*/mount{s,info}
      nfs: stop mangling ->mnt_devname on NFS
      nfs: switch NFS from ->get_sb() to ->mount()
      vfs: bury ->get_sb()

Diffstat:
 Documentation/filesystems/Locking |    6 +-
 Documentation/filesystems/porting |    7 ++
 Documentation/filesystems/vfs.txt |   56 ++++++-----
 fs/namespace.c                    |   39 ++++++--
 fs/nfs/dir.c                      |   13 +++
 fs/nfs/getroot.c                  |   42 +++++++-
 fs/nfs/internal.h                 |   21 ++--
 fs/nfs/namespace.c                |   66 ++++++++-----
 fs/nfs/nfs4namespace.c            |   41 +++-----
 fs/nfs/super.c                    |  194 +++++++++++++++++++------------------
 fs/nfs/unlink.c                   |   20 ++++
 fs/super.c                        |   67 +------------
 include/linux/fs.h                |   16 +---
 13 files changed, 316 insertions(+), 272 deletions(-)

