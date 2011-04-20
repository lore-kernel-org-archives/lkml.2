Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab1DTL7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:59:44 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:53145 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab1DTL7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:59:43 -0400
X-ASG-Debug-ID: 1303300778-01de284cf816ddc0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DAECAAB.3040601@fusionio.com>
Date: Wed, 20 Apr 2011 13:59:39 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block IO bits for 2.6.39-rc
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block IO bits for 2.6.39-rc
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303300778
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61402
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

- Fix a long standing bug in CFQ that assumes that read_lock() implies
  rcu_read_lock() as well. No known cases of this hitting (it would have
  to be a lucky punch during IO scheduler switch), but a bug none the
  less.

- Get rid of QUEUE_FLAG_REENTER. I know you love it, but it must go.
  SCSI unconditionally does async queue runs, in most cases they don't
even need to do that. I'll pass a patch through James to correct that.

- Two buglets in the block sysfs code, missing cleanup on error and code
  clarification change.

- blk_flush_plug_list() is no longer used externally, it's only called
  by schedule(). So we can kill the export now.

Please pull!


  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (4):
      block: kill blk_flush_plug_list() export
      cfq-iosched: read_lock() does not always imply rcu_read_lock()
      block: get rid of QUEUE_FLAG_REENTER
      block: remove stale kerneldoc member from __blk_run_queue()

Liu Yuan (1):
      block, blk-sysfs: Fix an err return path in blk_register_queue()

Tao Ma (1):
      block: Remove the extra check in queue_requests_store

 block/blk-core.c                 |   13 ++-----------
 block/blk-sysfs.c                |    8 +++++---
 block/blk.h                      |    1 -
 block/cfq-iosched.c              |   20 ++++++--------------
 drivers/scsi/scsi_lib.c          |   17 +----------------
 drivers/scsi/scsi_transport_fc.c |   19 ++++---------------
 include/linux/blkdev.h           |   26 +++++++++++++-------------
 7 files changed, 31 insertions(+), 73 deletions(-)

-- 
Jens Axboe

