Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934557Ab0EDW60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:58:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56447 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934536Ab0EDW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:58:24 -0400
Date: Tue, 4 May 2010 15:57:13 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: [GIT PULL] ocfs2 fixes for 2.6.34-rc
Message-ID: <20100504225713.GA21486@mail.oracle.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Fasheh <mfasheh@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4BE0A684.013D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus et al,
	Here are all the fixes I currently have for 2.6.34-rc.  A couple
very notable.  We could race truncate when O_DIRECT falls back to
buffered I/O, and we could crash when creating a directory or symlink
runs up against a user's quota.
	Please pull.

Joel


The following changes since commit 623e5a23724d09283c238960946ec6f65733afe:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../jlbec/ocfs2

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git fixes

Coly Li (1):
      ocfs2: one more warning fix in ocfs2_file_aio_write(), v2

Dan Carpenter (1):
      ocfs2: potential ERR_PTR dereference on error paths

Joel Becker (4):
      ocfs2: Compute metaecc for superblocks during online resize.
      ocfs2_dlmfs: Fix math error when reading LVB.
      Merge branch 'skip_delete_inode' of git://git.kernel.org/.../mfasheh/ocfs2-mark into ocfs2-fixes
      ocfs2: Avoid a gcc warning in ocfs2_wipe_inode().

Li Dongyang (4):
      ocfs2: add OCFS2_INODE_SKIP_ORPHAN_DIR flag and honor it in the inode wipe code
      ocfs2: use OCFS2_INODE_SKIP_ORPHAN_DIR in ocfs2_symlink error path
      ocfs2: use OCFS2_INODE_SKIP_ORPHAN_DIR in ocfs2_mknod error path
      ocfs2: Avoid direct write if we fall back to buffered I/O

Mark Fasheh (1):
      ocfs2: Add directory entry later in ocfs2_symlink() and ocfs2_mknod()

Tao Ma (3):
      ocfs2_dlmfs: User DLM_* when decoding file open flags.
      ocfs2: Reset status if we want to restart file extension.
      ocfs2: Update VFS inode's id info after reflink.

Wengang Wang (1):
      ocfs2: Check the owner of a lockres inside the spinlock

 fs/ocfs2/buffer_head_io.c |    2 +
 fs/ocfs2/dlm/dlmast.c     |    5 +--
 fs/ocfs2/dlmfs/dlmfs.c    |   14 ++++----
 fs/ocfs2/file.c           |   32 ++++++++++++---------
 fs/ocfs2/inode.c          |   68 +++++++++++++++++++++++++--------------------
 fs/ocfs2/inode.h          |    2 +
 fs/ocfs2/namei.c          |   58 +++++++++++++++++++++++++-------------
 fs/ocfs2/refcounttree.c   |    3 ++
 8 files changed, 110 insertions(+), 74 deletions(-)
_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
http://oss.oracle.com/mailman/listinfo/ocfs2-devel
