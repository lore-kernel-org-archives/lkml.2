Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab0KYIHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 03:07:10 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:57083 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab0KYIHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:07:09 -0500
X-ASG-Debug-ID: 1290672427-6da359860001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CEE1928.3080809@fusionio.com>
Date: Thu, 25 Nov 2010 09:07:04 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.37-rc3
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block bits for 2.6.37-rc3
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1290672427
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.1851 1.0000 -0.9073
X-Barracuda-Spam-Score: -0.91
X-Barracuda-Spam-Status: No, SCORE=-0.91 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.47618
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The "big" part here is the xen/blkfront transition to a
functional barrier replacement setup. Other than that,
a few fixes for build warnings/breaks, one more RCU fix
for the ioprio code, and a fix for a bug in the
blk-throttle code.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Greg Thelen (1):
      ioprio: grab rcu_read_lock in sys_ioprio_{set,get}()

Jens Axboe (2):
      Merge branch 'upstream/blkfront' of git://git.kernel.org/.../jeremy/xen into for-linus
      cciss: fix build for PROC_FS disabled

Jeremy Fitzhardinge (4):
      xen/blkfront: map REQ_FLUSH into a full barrier
      xen/blkfront: change blk_shadow.request to proper pointer
      xen/blkfront: Implement FUA with BLKIF_OP_WRITE_BARRIER
      xen/blkfront: cope with backend that fail empty BLKIF_OP_WRITE_BARRIER requests

Vivek Goyal (2):
      blk-throttle: Fix calculation of max number of WRITES to be dispatched
      block: fix amiga and atari floppy driver compile warning

 block/blk-throttle.c         |    2 +-
 drivers/block/amiflop.c      |    2 +-
 drivers/block/ataflop.c      |    2 +-
 drivers/block/cciss.c        |    3 +-
 drivers/block/xen-blkfront.c |   55 +++++++++++++++++++++++++----------------
 fs/ioprio.c                  |   31 ++++-------------------
 6 files changed, 43 insertions(+), 52 deletions(-)

-- 
Jens Axboe

