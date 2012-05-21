Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab2EUPaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:30:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60065 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2EUP36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:29:58 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 00/16] vfs: atomic open v5 (part 1)
Date: Mon, 21 May 2012 17:30:04 +0200
Message-Id: <1337614220-6174-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is part 1 of the atomic open series.  The second part is also ready for
review and I'll post it once this first part is accepted.

Change since v4: added a BUG_ON and a comment about where we can be in RCU mode
and where we can't (Nick's comment).

Al, can you please review and apply?

git tree is here (full series, not just part 1):

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git atomic-open.v5

Thanks,
Miklos
---

Miklos Szeredi (16):
      vfs: split do_lookup()
      vfs: do_last(): make exit RCU safe
      vfs: do_last(): inline walk_component()
      vfs: do_last(): use inode variable
      vfs: make follow_link check RCU safe
      vfs: do_last(): make ENOENT exit RCU safe
      vfs: do_last(): check LOOKUP_DIRECTORY
      vfs: do_last(): only return EISDIR for O_CREAT
      vfs: do_last(): add audit_inode before open
      vfs: do_last() common post lookup
      vfs: split __dentry_open()
      vfs: do_dentry_open(): don't put filp
      vfs: nameidata_to_filp(): inline __dentry_open()
      vfs: nameidata_to_filp(): don't throw away file on error
      vfs: retry last component if opening stale dentry
      nfs: don't open in ->d_revalidate

---
 fs/internal.h         |    1 +
 fs/namei.c            |  153 +++++++++++++++++++++++++++++++++++++------------
 fs/nfs/dir.c          |   56 ++----------------
 fs/nfs/file.c         |   77 +++++++++++++++++++++++-
 fs/open.c             |   76 ++++++++++++++++++------
 include/linux/errno.h |    1 +
 6 files changed, 252 insertions(+), 112 deletions(-)


