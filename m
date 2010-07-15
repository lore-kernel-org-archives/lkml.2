Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab0GOD1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 23:27:12 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:4346 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab0GOD1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 23:27:10 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/4] OMFS bug fixes
Date: Wed, 14 Jul 2010 23:26:17 -0400
Message-Id: <1279164381-9247-1-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes a memory leak on mount failures of
OMFS, and various crashes that were found with fuzzed disk images
some time ago.  All patches passed omfsprogs test suite.

Bob Copeland (3):
  omfs: check bounds on block numbers before passing to sb_bread
  omfs: refuse to mount if bitmap pointer is obviously wrong
  omfs: sanity check cluster size

Davidlohr Bueso (1):
  omfs: fix memory leak

 fs/omfs/dir.c     |   22 ++++++++--------------
 fs/omfs/file.c    |    8 ++++----
 fs/omfs/inode.c   |   44 +++++++++++++++++++++++++++++++++-----------
 fs/omfs/omfs.h    |    1 +
 fs/omfs/omfs_fs.h |    1 +
 5 files changed, 47 insertions(+), 29 deletions(-)


