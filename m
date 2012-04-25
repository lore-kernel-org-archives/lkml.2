Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2DYMoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:44:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43809 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab2DYMoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:44:01 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org, mszeredi@suse.cz
Subject: [PATCH 00/16] vfs: atomic open v4 (part 1)
Date: Wed, 25 Apr 2012 14:44:01 +0200
Message-Id: <1335357857-16416-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Part 1 of the atomic open series (split the patch bomb into 2 parts).  This goes
as far as moving NFS open code out from ->revalidate and into ->open.

Al, can you please review and apply?

git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git atomic-open.v4

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
 fs/namei.c            |  151 ++++++++++++++++++++++++++++++++++++------------
 fs/nfs/dir.c          |   56 ++-----------------
 fs/nfs/file.c         |   77 ++++++++++++++++++++++++-
 fs/open.c             |   76 ++++++++++++++++++------
 include/linux/errno.h |    1 +
 6 files changed, 250 insertions(+), 112 deletions(-)

