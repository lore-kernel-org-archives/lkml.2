Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185Ab0JXUJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 16:09:37 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:45196 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab0JXUJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 16:09:36 -0400
X-ASG-Debug-ID: 1287950975-16967a390001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CC49274.3030803@fusionio.com>
Date: Sun, 24 Oct 2010 22:09:24 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Revert of the IO stat fix
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Revert of the IO stat fix
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1287950975
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.4381 1.0000 0.0000
X-Barracuda-Spam-Score: 0.23
X-Barracuda-Spam-Status: No, SCORE=0.23 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=RCVD_ILLEGAL_IP
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.44632
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.23 RCVD_ILLEGAL_IP        Received: contains illegal IP address
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The fix for cross-partition merges screwing up disk stats turns out
to be problematic on various levels. Lets revert this one so we have
time to come up with a proper solution for this.


  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (1):
      Revert "block: fix accounting bug on cross partition merges"

 block/blk-core.c         |   24 ++++++++----------------
 block/blk-merge.c        |    2 +-
 block/blk.h              |    4 ++++
 block/genhd.c            |   14 --------------
 fs/partitions/check.c    |   12 ------------
 include/linux/blkdev.h   |    1 -
 include/linux/elevator.h |    2 --
 include/linux/genhd.h    |    1 -
 8 files changed, 13 insertions(+), 47 deletions(-)

-- 
Jens Axboe

