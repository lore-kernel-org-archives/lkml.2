Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab2EaMMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:12:12 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:59357 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab2EaMMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:12:10 -0400
X-ASG-Debug-ID: 1338466329-03d6a5030e35000001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FC76016.3040108@fusionio.com>
Date: Thu, 31 May 2012 14:12:06 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] followup block pull request
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] followup block pull request
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1338466329
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.98530
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Includes the fix from Eric to resolve the infinite loop in looking up /
creating an IO context for an exiting task.

Also a bunch of mtip32xx patches. Fairly trivial stuff.  It's fairly new
though, but no point in keeping it out of the tree until 3.6 imho. I've
thrown it through basic testing locally as well, works fine. The one
contentious part is the patch that Greg complained about (sysfs file
with multiple values, should be a debugfs file), which is perfectly
valid, but not a regression from what the file contains now. That will
be fixed up separately.

  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Asai Thambi S P (10):
      mtip32xx: fix clearing an incorrect register in mtip_init_port
      mtip32xx: Set custom timeouts for PIO commands
      mtip32xx: Change HDIO_GET_IDENTITY to return stored data
      mtip32xx: Fix to handle TFE for PIO(IOCTL/internal) commands
      mtip32xx: Set block queue boundary variables
      mtip32xx: Use plain spinlock for 'cmd_issue_lock'
      mtip32xx: Fix to support more than one sector in exec_drive_command()
      mtip32xx: minor performance tweak
      mtip32xx: Convert macro definitions for flag bits to enum
      mtip32xx: Changes to sysfs entries

Eric Dumazet (1):
      block: avoid infinite loop in get_task_io_context()

 Documentation/ABI/testing/sysfs-block-rssd |  12 +-
 block/blk-ioc.c                            |   6 +-
 drivers/block/mtip32xx/mtip32xx.c          | 276 ++++++++++++++++++-----------
 drivers/block/mtip32xx/mtip32xx.h          |  48 ++---
 4 files changed, 212 insertions(+), 130 deletions(-)

-- 
Jens Axboe

