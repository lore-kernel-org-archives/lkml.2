Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab2DQFZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:25:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39614 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2DQFZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:25:13 -0400
Date: Tue, 17 Apr 2012 06:25:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs and fs fixes
Message-ID: <20120417052511.GU6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	A bunch of endianness fixes plus a patch from bfields untangling
dependencies between vfs and nfsd trees; in principle, we could keep it
in nfsd tree (along with a bunch of followups that definitely belong there),
but Miklos' stuff in fs/namei.c steps fairly close to it and overlayfs
and unionfs series - even closer, so that would create serious PITA for
both, whichever tree it would sit in.

	Speaking of endianness stuff, I'm rather tempted to slap
ccflags-y += -D__CHECK_ENDIAN__ in fs/Makefile, if not making it
default for the entire tree; nfsd regressions I've caught make one
hell of a pile and we'd obviously benefit from having that kind of
stuff caught earlier...

Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (12):
      nfsd: fix b0rken error value for setattr on read-only mount
      nfsd: fix error values returned by nfsd4_lockt() when nfsd_open() fails
      nfsd: fix endianness breakage in TEST_STATEID handling
      nfsd: fix error value on allocation failure in nfsd4_decode_test_stateid()
      nfsd: fix compose_entry_fh() failure exits
      ext4: fix endianness breakage in ext4_split_extent_at()
      btrfs: btrfs_root_readonly() broken on big-endian
      ocfs2: ->l_next_free_req breakage on big-endian
      ocfs: ->rl_used breakage on big-endian
      ocfs2: ->rl_count endianness breakage
      ocfs2: ->e_leaf_clusters endianness breakage
      lockd: fix the endianness bug

J. Bruce Fields (1):
      vfs: take i_mutex on renamed file

Diffstat:
 Documentation/filesystems/directory-locking |   11 ++++++-----
 fs/btrfs/ctree.h                            |    2 +-
 fs/ext4/extents.c                           |    2 +-
 fs/lockd/clnt4xdr.c                         |    2 +-
 fs/lockd/clntxdr.c                          |    2 +-
 fs/namei.c                                  |    3 +++
 fs/nfsd/nfs3xdr.c                           |   22 ++++++++--------------
 fs/nfsd/nfs4proc.c                          |    7 ++++---
 fs/nfsd/nfs4state.c                         |   23 +++++++++--------------
 fs/nfsd/nfs4xdr.c                           |    4 ++--
 fs/ocfs2/alloc.c                            |    2 +-
 fs/ocfs2/refcounttree.c                     |   12 ++++++------
 fs/ocfs2/suballoc.c                         |    4 ++--
 include/linux/fs.h                          |    9 ++++++---
 14 files changed, 51 insertions(+), 54 deletions(-)
