Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1FCTlE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:41:04 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:51840 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1FCTlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:41:03 -0400
X-ASG-Debug-ID: 1307130061-01de280c1e216c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE938C9.9060505@fusionio.com>
Date: Fri, 3 Jun 2011 21:40:57 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block bits for 3.0-rc2
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Block bits for 3.0-rc2
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1307130061
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65485
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A collection of smallish fixes for -rc2.

- One bio documentation improvement, that I see Al already pushed out.
  Should be identical, if not I'm sure you are up to the merge.

- Two bug fixes for the XEN blkback driver.

- A revert of a patch that caused a regression in sysfs discard
  alignment display.

- Further patches from Namhyung Kim, giving nbd the same fixup treatment
  for max_part oopsable conditions. Also fixes an ancient bug in there
  were the recvmsg() flags aren't correctly passed in.

- Two fixes from Paul Bolle, removing an if that was always false and
  correcting usage of list_entry() to hlist_entry() (cosmetical).

- A blkdev_get() fixup from Tejun.

Please pull.

  git://git.kernel.dk/linux-block.git for-linus

Andreas Gruenbacher (1):
      block: improve the bio_add_page() and bio_add_pc_page() descriptions

Dan Carpenter (1):
      xen/blkback: potential null dereference in error handling

Jens Axboe (2):
      Revert "block: Remove extra discard_alignment from hd_struct."
      Merge branch 'for-jens/xen-blkback.fixes' of git://git.kernel.org/.../konrad/xen into for-linus

Kyungmin Park (1):
      CFQ: Fix typo and remove unnecessary semicolon

Laszlo Ersek (1):
      xen/blkback: don't call vbd_size() if bd_disk is NULL

Namhyung Kim (4):
      nbd: pass MSG_* flags to kernel_recvmsg()
      nbd: limit module parameters to a sane value
      nbd: adjust 'max_part' according to part_shift
      block: remove unwanted semicolons

Paul Bolle (2):
      cfq-iosched: Remove bogus check in queue_fail path
      block: Use hlist_entry() for io_context.cic_list.first

Tejun Heo (1):
      block: blkdev_get() should access ->bd_disk only after success

 block/blk-ioc.c                     |    4 ++--
 block/cfq-iosched.c                 |   11 ++++-------
 drivers/block/nbd.c                 |   22 ++++++++++++++++++++--
 drivers/block/xen-blkback/blkback.c |   10 ++++++----
 drivers/block/xen-blkback/xenbus.c  |    3 +--
 fs/bio.c                            |   16 ++++++++--------
 fs/block_dev.c                      |    4 ++--
 fs/partitions/check.c               |   10 +++-------
 include/linux/blkdev.h              |    4 ++--
 include/linux/genhd.h               |    1 +
 10 files changed, 49 insertions(+), 36 deletions(-)

-- 
Jens Axboe

