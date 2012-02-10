Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab2BJTmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:42:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61948 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab2BJTmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:42:22 -0500
Subject: [PATCH 0/4] shmem: radix-tree cleanups and swapoff optimizations
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Feb 2012 23:42:18 +0400
Message-ID: <20120210193249.6492.18768.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here some shmem patches related to the radix-tree iterator patchset,
they cleans radix-tree usage in shmem and notably optimizes swapoff operation.
Last patch is slightly off-topic, but it shares test results with previous patch.

---

Konstantin Khlebnikov (4):
      shmem: simlify shmem_unlock_mapping
      shmem: tag swap entries in radix tree
      shmem: use radix-tree iterator in shmem_unuse_inode()
      mm: use swap readahead at swapoff


 include/linux/radix-tree.h |    1 
 lib/radix-tree.c           |   93 --------------------------------------------
 mm/shmem.c                 |   60 ++++++++++++++++++++--------
 mm/swapfile.c              |    3 -
 4 files changed, 44 insertions(+), 113 deletions(-)

-- 
Signature
