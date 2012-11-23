Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2KWOCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 09:02:24 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:59817 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab2KWOCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 09:02:22 -0500
X-ASG-Debug-ID: 1353679341-0421b52b8133860001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50AF81A7.6020108@fusionio.com>
Date: Fri, 23 Nov 2012 15:01:11 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Important block fixes for 3.7
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Important block fixes for 3.7
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1353679341
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.115037
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Distilled down version of bug fixes for 3.7. The patches have been well
tested. If you notice that commit dates are from today, it's because I
pulled less important bits out and shuffled them into the 3.8 mix. Apart
from that, no changes, base still the same.

It contains:

- Fix for aoe, don't run request_fn while it's plugged.

- Fix for a regression in floppy since 3.6, which causes
  problems if no floppy is found.

- Stable fix for blk_exec(), don't touch a request after it
  has been sent to the scheduler (and the device as well).

- Five fixes for various nasties in mtip32xx.

Please pull.

  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
for-linus-20121123

----------------------------------------------------------------
Ed L. Cashin (1):
      aoe: avoid running request handler on plugged queue

Jens Axboe (2):
      dm: fix deadlock with request based dm and queue request_fn recursion
      mtip32xx: fix shift larger than type warning

Jiri Kosina (1):
      floppy: destroy floppy workqueue before cleaning up the queue

Roland Dreier (1):
      block: Don't access request after it might be freed

Selvan Mani (4):
      mtip32xx: fix potential crash on SEC_ERASE_UNIT
      mtip32xx: Fix to make lba address correct in big-endian systems
      mtip32xx: Fix incorrect mask used for erase mode
      mtip32xx: Fix padding issue

Wei Yongjun (1):
      mtip32xx: fix potential NULL pointer dereference in mtip_timeout_function()

 block/blk-exec.c                  |  8 +++++++-
 drivers/block/aoe/aoecmd.c        |  2 +-
 drivers/block/floppy.c            |  5 +++--
 drivers/block/mtip32xx/mtip32xx.c | 18 ++++++++++++------
 drivers/block/mtip32xx/mtip32xx.h |  6 +++---
 drivers/md/dm.c                   |  8 +++++++-
 6 files changed, 33 insertions(+), 14 deletions(-)

-- 
Jens Axboe

