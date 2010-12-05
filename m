Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab0LER3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:29:37 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59041 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab0LER3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Kxksp0EW2rNMtylaXQAdOUdZBYoeLXileVtaPYDPFCwawb+49bDLY846JvKaO5mJTk
         XP1jGv2bnCOZ0Heo+KJ5rhaQ0+Rmh9cadzonMOXgxk2pxq56zSq4sDpqa7B9YTztFW0r
         31dkZKR5fdjUMvtdZ7KrsrAXw7LNjSGL+0htg=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v4 0/7] f/madivse(DONTNEED) support
Date: Mon,  6 Dec 2010 02:29:08 +0900
Message-Id: <cover.1291568905.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently there is a report about working set page eviction due to rsync
workload. application programmers want to use fadvise but it's not easy.
You could see detailed description on [2/7].
 - [1/7] is to remove checkpatch's reporting in mm/swap.c
 - [2/7] is to move invalidated page which is dirty/writeback on active list
   into inactive list's head.
 - [3/7] is to move memcg reclaimable page on inactive's tail.
 - [4/7] is for moving invalidated page into inactive list's tail when the
   page's writeout is completed for reclaim asap.
 - [5/7] is to add profing information for evaluation.
 - [6/7] is to remove zap_detail NULL dependency to some functions. It is for
	next patch.
 - [7/7] is to not calling mark_page_accessed in case of madvise(DONTNEED)

This patches are based on mmotm-12-02
Before applying the series, Please, remove below patches.
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

Minchan Kim (7):
  Fix checkpatch's report in swap.c
  deactivate invalidated pages
  move memcg reclaimable page into tail of inactive list
  Reclaim invalidated page ASAP
  add profile information for invalidated page reclaim
  Remove zap_details NULL dependency
  Prevent activation of page in madvise_dontneed

 include/linux/memcontrol.h |    6 ++
 include/linux/mm.h         |   10 ++++
 include/linux/swap.h       |    1 +
 include/linux/vmstat.h     |    4 +-
 mm/madvise.c               |   13 +++--
 mm/memcontrol.c            |   27 +++++++++
 mm/memory.c                |   19 ++++---
 mm/mmap.c                  |    6 ++-
 mm/page-writeback.c        |   12 ++++-
 mm/swap.c                  |  127 +++++++++++++++++++++++++++++++++++++++++---
 mm/truncate.c              |   17 +++++--
 mm/vmstat.c                |    3 +
 12 files changed, 216 insertions(+), 29 deletions(-)

