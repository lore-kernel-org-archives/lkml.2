Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab1HCKsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:48:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51970 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1HCKr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:47:56 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, jack@suse.cz,
        hch@infradead.org, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH v5 0/4] read-only remount race fix
Date: Wed,  3 Aug 2011 12:48:37 +0200
Message-Id: <1312368521-7911-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

Here's an update of the read-only remount race fixes.

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git read-only-remount-fixes.v5

Please apply.

Thanks,
Miklos
---


Miklos Szeredi (4):
      vfs: ignore error on forced remount
      vfs: keep list of mounts for each superblock
      vfs: protect remounting superblock read-only
      vfs: fs_may_remount_ro: turn unnecessary check into a WARN_ON

---
 fs/file_table.c       |    7 ++++-
 fs/internal.h         |    1 +
 fs/namespace.c        |   50 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/super.c            |   27 +++++++++++++++++++++----
 include/linux/fs.h    |    4 +++
 include/linux/mount.h |    1 +
 6 files changed, 82 insertions(+), 8 deletions(-)
