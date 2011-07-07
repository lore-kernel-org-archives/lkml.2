Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1GGJiI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:38:08 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:41936 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1GGJiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:38:04 -0400
X-ASG-Debug-ID: 1310031483-03d6a510a8122650001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E157E77.6070906@fusionio.com>
Date: Thu, 7 Jul 2011 11:37:59 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Important block fixes for 3.0-rc
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Important block fixes for 3.0-rc
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1310031483
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.68215
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two parts to this:

- Silencing an RCU warning introduced with the commit fixing
  the long standing CFQ crash.

- A handful of bug fixes for drbd.

Please pull.

  git://git.kernel.dk/linux-block.git for-linus

Jens Axboe (1):
      Merge branch 'for-3.0-important' of git://git.drbd.org/linux-2.6-drbd into for-linus

Lars Ellenberg (6):
      drbd: add missing spinlock to bitmap receive
      drbd: don't cond_resched_lock with IRQs disabled
      drbd: account bitmap IO during resync as resync-(related-)-io
      drbd: when receive times out on meta socket, also check last receive time on data socket
      drbd: fix limit define, we support 1 PiByte now
      drbd: we should write meta data updates with FLUSH FUA

Philipp Reisner (1):
      drbd: Use the correct max_bio_size when creating resync requests

Shaohua Li (2):
      cfq-iosched: fix a rcu warning
      cfq-iosched: make code consistent

 block/cfq-iosched.c                |    8 +++++-
 drivers/block/drbd/drbd_actlog.c   |    2 +-
 drivers/block/drbd/drbd_bitmap.c   |   37 ++++++++++++++++++++++-------------
 drivers/block/drbd/drbd_receiver.c |    6 +++++
 drivers/block/drbd/drbd_worker.c   |    7 +-----
 include/linux/drbd_limits.h        |    4 +-
 6 files changed, 39 insertions(+), 25 deletions(-)

-- 
Jens Axboe

