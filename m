Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab1KULLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:11:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43422 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab1KULLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:11:38 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH 0/4] read-only remount race fix v10
Date: Mon, 21 Nov 2011 12:11:29 +0100
Message-Id: <1321873893-4544-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

Please apply the following patches that fix read-only remount races.

Git tree is here:

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git read-only-remount-fixes.v10

Thanks,
Miklos
---
Miklos Szeredi (4):
      vfs: keep list of mounts for each superblock
      vfs: protect remounting superblock read-only
      vfs: count unlinked inodes
      vfs: prevent remount read-only if pending removes

---
 fs/file_table.c       |   23 -------------
 fs/inode.c            |   85 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/internal.h         |    1 +
 fs/namespace.c        |   57 ++++++++++++++++++++++++++++++++-
 fs/super.c            |   20 +++++++++--
 include/linux/fs.h    |   67 ++++++--------------------------------
 include/linux/mount.h |    1 +
 7 files changed, 170 insertions(+), 84 deletions(-)

