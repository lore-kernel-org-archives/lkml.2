Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050Ab0FJNoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:44:15 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52806 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab0FJNoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:44:14 -0400
Message-ID: <4C10EC2A.8060002@fusionio.com>
Date: Thu, 10 Jun 2010 15:44:10 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block/io bits for 2.6.35-rc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Some important fixes for 2.6.35:

- A set of patches fixing the WB_SYNC_NONE writeback from Christoph. So
  we should finally have both functional and working WB_SYNC_NONE from
  umount context.

- Two fixes for the pipe resizing and fcntl() interface, where the
  last conversion to a byte API introduced a dumb bug.

- Fix for the module count problem from Nick.

Please pull.


  git://git.kernel.dk/linux-2.6-block.git for-linus

Christoph Hellwig (8):
      writeback: fix writeback completion notifications
      writeback: queue work on stack in writeback_inodes_sb
      writeback: enforce s_umount locking in writeback_inodes_sb
      writeback: fix writeback_inodes_wb from writeback_inodes_sb
      writeback: simplify wakeup_flusher_threads
      writeback: simplify and split bdi_start_writeback
      writeback: add missing requeue_io in writeback_inodes_wb
      writeback: fix pin_sb_for_writeback

Jens Axboe (1):
      block: remove duplicate BUG_ON() in bd_finish_claiming()

Miklos Szeredi (2):
      pipe: fix pipe buffer resizing
      pipe: fix check in "set size" fcntl

Nick Piggin (2):
      block: bd_start_claiming fix module refcount
      block: bd_start_claiming cleanup

 fs/block_dev.c              |   72 ++++++++----
 fs/fs-writeback.c           |  254 ++++++++++++++++++-------------------------
 fs/pipe.c                   |   20 +++-
 fs/ubifs/budget.c           |    2 +
 include/linux/backing-dev.h |    4 +-
 mm/page-writeback.c         |    5 +-
 6 files changed, 175 insertions(+), 182 deletions(-)

-- 
Jens Axboe

