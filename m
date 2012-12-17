Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab2LQPea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:34:30 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52255
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab2LQPe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:34:29 -0500
Message-ID: <50CF3B82.9000904@kernel.dk>
Date: Mon, 17 Dec 2012 16:34:26 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] core block IO bits for 3.8
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the core block IO bits for 3.8. The branch contains:

- The final version of the surprise device removal fixups from Bart.

- Don't hide EFI partitions under advanced partition types. It's fairly
  wide spread these days. This is especially dangerous for systems that
  have both msdos and efi partition tables, where you want to keep them
  in sync.

- Cleanup of using -1 instead of the proper NUMA_NO_NODE

- Export control of bdi flusher thread CPU mask and default to using the
  home node (if known) from Jeff.

- Export unplug tracepoint for MD.

- Core improvements from Shaohua. Reinstate the recursive merge, as the
  original bug has been fixed. Add plugging for discard and also fix a
  problem handling non pow-of-2 discard limits.

Please pull! There's a trivial merge in block/blk-exec.c due to a fix
that went into 3.7-rc at a later point than -rc4 where this is based.


  git://git.kernel.dk/linux-block.git for-3.8/core


----------------------------------------------------------------
Bart Van Assche (6):
      block: Rename queue dead flag
      block: Let blk_drain_queue() caller obtain the queue lock
      block: Avoid that request_fn is invoked on a dead queue
      block: Avoid scheduling delayed work on a dead queue
      block: Make blk_cleanup_queue() wait until request_fn finished
      bsg: Remove unused function bsg_goose_queue()

Diego Calleja (1):
      partitions: enable EFI/GPT support by default

Ezequiel Garcia (1):
      block: use NUMA_NO_NODE instead of -1

Jeff Moyer (1):
      bdi: add a user-tunable cpu_list for the bdi flusher threads

NeilBrown (1):
      block: export block_unplug tracepoint

Shaohua Li (4):
      block CFQ: avoid moving request to different queue
      block: recursive merge requests
      block: discard granularity might not be power of 2
      block: add plug for blkdev_issue_discard

xiaobing tu (1):
      deadline: Allow 0ms deadline latency, increase the read speed

 block/blk-cgroup.c          |    2 +-
 block/blk-core.c            |  127 ++++++++++++++++++++++++++-----------------
 block/blk-exec.c            |    4 +-
 block/blk-lib.c             |   26 +++++----
 block/blk-settings.c        |    6 +-
 block/blk-sysfs.c           |    4 +-
 block/blk-throttle.c        |    2 +-
 block/blk.h                 |    4 +-
 block/bsg-lib.c             |   13 -----
 block/cfq-iosched.c         |    3 +-
 block/deadline-iosched.c    |    2 +-
 block/elevator.c            |   16 ++++--
 block/genhd.c               |    2 +-
 block/partitions/Kconfig    |    4 +-
 drivers/scsi/scsi_lib.c     |    2 +-
 include/linux/backing-dev.h |    4 ++
 include/linux/blkdev.h      |   17 ++++--
 include/linux/bsg-lib.h     |    1 -
 mm/backing-dev.c            |   84 ++++++++++++++++++++++++++++
 19 files changed, 224 insertions(+), 99 deletions(-)

-- 
Jens Axboe

