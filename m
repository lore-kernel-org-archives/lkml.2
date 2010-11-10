Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab0KJXqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:46:24 -0500
Received: from mail.perches.com ([173.55.12.10]:4944 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421Ab0KJXqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:46:23 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: ecryptfs-devel@lists.launchpad.net, jfs-discussion@lists.sourceforge.net
Subject: [PATCH 0/6] fs: Add printf format/argument verification
Date: Wed, 10 Nov 2010 15:46:12 -0800
Message-Id: <cover.1289432524.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various logging messages functions use printf style varargs
without declaring them __attribute__((format(printf...))).
Add the attribute so the compiler can warn about mismatches
and then fix any mismatch warnings.

Joe Perches (6):
  fs/adfs: Add printf format/argument verification and fix fallout
  fs/affs: Add printf format/argument verification and fix fallout
  fs/befs: Add printf format/argument verification and fix fallout
  fs/ecryptfs:  Add printf format/argument verification and fix fallout
  fs/jfs: Add printf format/argument verification
  fs/udf: Add printf format/argument verification

 fs/adfs/adfs.h                |    1 +
 fs/adfs/dir.c                 |    2 +-
 fs/affs/affs.h                |    2 +
 fs/affs/file.c                |   14 ++++---
 fs/befs/befs.h                |    3 ++
 fs/befs/btree.c               |    5 ++-
 fs/befs/datastream.c          |   76 ++++++++++++++++++++++++-----------------
 fs/befs/inode.c               |   11 ++++--
 fs/befs/io.c                  |   12 ++++--
 fs/befs/linuxvfs.c            |   19 ++++++----
 fs/ecryptfs/crypto.c          |   20 ++++++----
 fs/ecryptfs/ecryptfs_kernel.h |    1 +
 fs/ecryptfs/file.c            |    6 ++--
 fs/ecryptfs/keystore.c        |    7 ++--
 fs/ecryptfs/main.c            |    7 ++--
 fs/ecryptfs/mmap.c            |   13 ++++---
 fs/jfs/jfs_superblock.h       |    2 +
 fs/udf/udfdecl.h              |    2 +
 18 files changed, 124 insertions(+), 79 deletions(-)

-- 
1.7.3.1.g432b3.dirty

