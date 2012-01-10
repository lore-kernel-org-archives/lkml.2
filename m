Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2AJIYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:24:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:36072 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab2AJIYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:24:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="94193523"
Date: Tue, 10 Jan 2012 16:23:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] writeback for 3.3
Message-ID: <20120110082358.GA9131@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull tag 'writeback' from

  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git writeback-for-linus

They are mostly further improvements to the IO-less balance_dirty_pages().

Jan Kara (1):
      writeback: Include all dirty inodes in background writeback

Wu Fengguang (10):
      writeback: charge leaked page dirties to active tasks
      writeback: fix dirtied pages accounting on sub-page writes
      writeback: fix dirtied pages accounting on redirty
      btrfs: fix dirtied pages accounting on sub-page writes
      writeback: dirty ratelimit - think time compensation
      writeback: max, min and target dirty pause time
      writeback: avoid tiny dirty poll intervals
      writeback: do strict bdi dirty_exceeded
      writeback: balanced_rate cannot exceed write bandwidth
      writeback: move MIN_WRITEBACK_PAGES to fs-writeback.c

 fs/btrfs/file.c                  |    3 +-
 fs/fs-writeback.c                |   16 ++-
 include/linux/sched.h            |    1 +
 include/linux/writeback.h        |    9 +-
 include/trace/events/writeback.h |   14 ++-
 kernel/exit.c                    |    3 +
 kernel/fork.c                    |    1 +
 mm/page-writeback.c              |  246 +++++++++++++++++++++++++++++---------
 8 files changed, 227 insertions(+), 66 deletions(-)

Thanks,
Fengguang
