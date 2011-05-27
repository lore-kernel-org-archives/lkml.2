Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab1E0NKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:10:24 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:60523 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab1E0NKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:10:19 -0400
X-ASG-Debug-ID: 1306501818-03d6a512a80f670001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDFA2B6.3000404@fusionio.com>
Date: Fri, 27 May 2011 15:10:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Follow up block fixes
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Follow up block fixes
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306501818
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64816
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Mainly pushing this a bit early to resolve an oops that has been
reported by Eric Dumazet. Some good fixes apart from that, though,
Namhyung Kim has been busy fixing oopsable conditions in brd, loop,
and nbd. The latter is not in yet. Most patches are stable candidates.

- Fix floppy regression from Tejun
- brd/loop fixes from Namhyung Kim
- Removal of an only-written variable in bio_attempt_front_merge()
- Export blk_{get,put}_queue() for the SCSI fix
- Fix oops shortly after boot reported by Eric.


Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (2):
      block: fix oops on !disk->queue and sysfs discard alignment display
      block: export blk_{get,put}_queue()

Luca Tettamanti (1):
      block: remove unused variable in bio_attempt_front_merge()

Namhyung Kim (6):
      brd: get rid of unused members from struct brd_device
      brd: limit 'max_part' module param to DISK_MAX_PARTS
      brd: handle on-demand devices correctly
      brd: fix comment on initial device creation
      brd: export module parameters
      loop: export module parameters

Tejun Heo (1):
      block: always allocate genhd->ev if check_events is implemented

 block/blk-core.c      |    5 ++---
 block/genhd.c         |    2 +-
 drivers/block/brd.c   |   42 ++++++++++++++++++++++++++----------------
 drivers/block/loop.c  |   17 ++++++++++++++---
 fs/partitions/check.c |    8 +++++---
 5 files changed, 48 insertions(+), 26 deletions(-)

-- 
Jens Axboe

