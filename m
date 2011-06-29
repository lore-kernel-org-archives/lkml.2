Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1F2PWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:22:51 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44447 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab1F2PWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:22:48 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jun 2011 11:22:47 EDT
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] DRBD minor fixes for 3.0-rc6
Date: Wed, 29 Jun 2011 17:14:56 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291714.57384.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a1c15c59feee36267c43142a41152fbf7402afb6:

  loop: handle on-demand devices correctly (2011-05-24 16:48:55 +0200)

are available in the git repository at:
  git://git.drbd.org/linux-2.6-drbd.git for-jens

David Howells (1):
      DRBD: Fix comparison always false warning due to long/long long compare

Lars Ellenberg (10):
      drbd: cosmetic: fix accidental division instead of modulo when pretty printing
      drbd: add missing spinlock to bitmap receive
      drbd: don't cond_resched_lock with IRQs disabled
      drbd: spelling fix: too small
      drbd: account bitmap IO during resync as resync-(related-)-io
      drbd: when receive times out on meta socket, also check last receive time on data socket
      drbd: allow ping-timeout of up to 30 seconds
      drbd: downgraded error printk to info
      drbd: fix limit define, we support 1 PiByte now
      drbd: we should write meta data updates with FLUSH FUA

Philipp Reisner (3):
      drbd: Lower log priority for an event that is definitely not an error
      drbd: Use the correct max_bio_size when creating resync requests
      drbd: Only print sanitize state's warnings, if the state change happens

 drivers/block/drbd/drbd_actlog.c   |    2 +-
 drivers/block/drbd/drbd_bitmap.c   |   37 +++++++++++++--------
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |   61 ++++++++++++++++++++++++-----------
 drivers/block/drbd/drbd_nl.c       |    8 ++--
 drivers/block/drbd/drbd_proc.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |    8 ++++-
 drivers/block/drbd/drbd_worker.c   |    7 +---
 include/linux/drbd.h               |    4 +-
 include/linux/drbd_limits.h        |    6 ++--
 10 files changed, 85 insertions(+), 52 deletions(-)
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
