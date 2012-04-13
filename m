Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab2DMINQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:13:16 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:35030 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab2DMING (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:13:06 -0400
X-Greylist: delayed 733 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2012 04:13:06 EDT
X-ASG-Debug-ID: 1334304050-03d6a54a8017c8f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4F87DD2D.4030507@fusionio.com>
Date: Fri, 13 Apr 2012 10:00:45 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block core bits for 3.4
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block core bits for 3.4
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1334304050
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0038 1.0000 -1.9964
X-Barracuda-Spam-Score: -2.00
X-Barracuda-Spam-Status: No, SCORE=-2.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.93982
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

It's a nice and quiet round this time, since most of the
tricky stuff has been pushed to 3.5 to give it more time
to mature. After a few hectic block IO core changes for
3.3 and 3.2, I'm quite happy with a slow round.

Really minor stuff in here, the only real functional change is making
the auto-unplug threshold a per-queue entity. The threshold is set so
that it's low enough that we don't hold off IO for too long, but still
big enough to get a nice benefit from the batched insert (and hence
queue lock cost reduction). For raid configurations, this currently
breaks down.

Please pull.

  git://git.kernel.dk/linux-block.git for-3.4/core

Andi Kleen (1):
      block: use lockdep_assert_held for queue locking

Dan Carpenter (1):
      block: blk_alloc_queue_node(): use caller's GFP flags instead of GFP_KERNEL

Shaohua Li (1):
      block: make auto block plug flush threshold per-disk based

Tao Ma (2):
      block: Make cfq_target_latency tunable through sysfs.
      Documentation: Add sysfs ABI change for cfq's target latency.

 Documentation/ABI/testing/sysfs-cfq-target-latency |    8 ++++++++
 block/blk-core.c                                   |    5 +++--
 block/blk-throttle.c                               |    2 +-
 block/cfq-iosched.c                                |   10 ++++++++--
 include/linux/blkdev.h                             |   18 +++++++-----------
 5 files changed, 27 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-cfq-target-latency

-- 
Jens Axboe

