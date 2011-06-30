Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab1F3IIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:08:47 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33905 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab1F3IIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:08:38 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] DRBD minor fixes for 3.0-rc6
Date: Thu, 30 Jun 2011 10:08:32 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
References: <201106291714.57384.philipp.reisner@linbit.com> <4E0B6B85.5090202@kernel.dk>
In-Reply-To: <4E0B6B85.5090202@kernel.dk>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106301008.32832.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 29. Juni 2011, 20:14:29 schrieb Jens Axboe:
> On 2011-06-29 17:14, Philipp Reisner wrote:
> > The following changes since commit a1c15c59feee36267c43142a41152fbf7402afb6:
> >   loop: handle on-demand devices correctly (2011-05-24 16:48:55 +0200)
> > 
> > are available in the git repository at:
> >   git://git.drbd.org/linux-2.6-drbd.git for-jens
> 
> This looks way too big for -rc6. Take another look at the list and
> re-send with what is absolutely crucial this late in the cycle, please.

Hi Jens,

I categorised them into three branches:
for-3.0-important, for-3.0-non-important-trivia and for-3.0-non-trivial-cosmetic.

Please consider to pull the first one, eventually the second one. (The third
one is only there for sake of completeness, to document that this patch will
be scheduled for the next merge window)



The following changes since commit a1c15c59feee36267c43142a41152fbf7402afb6:

  loop: handle on-demand devices correctly (2011-05-24 16:48:55 +0200)

are available in the git repository at:
  git://git.drbd.org/linux-2.6-drbd.git for-3.0-important

Lars Ellenberg (6):
      drbd: add missing spinlock to bitmap receive
      drbd: don't cond_resched_lock with IRQs disabled
      drbd: account bitmap IO during resync as resync-(related-)-io
      drbd: when receive times out on meta socket, also check last receive time on data socket
      drbd: fix limit define, we support 1 PiByte now
      drbd: we should write meta data updates with FLUSH FUA

Philipp Reisner (1):
      drbd: Use the correct max_bio_size when creating resync requests

 drivers/block/drbd/drbd_actlog.c   |    2 +-
 drivers/block/drbd/drbd_bitmap.c   |   37 ++++++++++++++++++++++-------------
 drivers/block/drbd/drbd_receiver.c |    6 +++++
 drivers/block/drbd/drbd_worker.c   |    7 +-----
 include/linux/drbd_limits.h        |    4 +-
 5 files changed, 33 insertions(+), 23 deletions(-)



The following changes since commit 86e1e98e5c6b4edab97e2b058466ef553cfd878e:

  drbd: we should write meta data updates with FLUSH FUA (2011-06-30 09:23:46 +0200)

are available in the git repository at:
  git://git.drbd.org/linux-2.6-drbd.git for-3.0-non-important-trivia

David Howells (1):
      DRBD: Fix comparison always false warning due to long/long long compare

Lars Ellenberg (4):
      drbd: cosmetic: fix accidental division instead of modulo when pretty printing
      drbd: spelling fix: too small
      drbd: allow ping-timeout of up to 30 seconds
      drbd: downgraded error printk to info

Philipp Reisner (1):
      drbd: Lower log priority for an event that is definitely not an error

 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |    6 ++----
 drivers/block/drbd/drbd_nl.c       |    8 ++++----
 drivers/block/drbd/drbd_proc.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |    2 +-
 include/linux/drbd.h               |    4 ++--
 include/linux/drbd_limits.h        |    2 +-
 7 files changed, 12 insertions(+), 14 deletions(-)



The following changes since commit 7b3353ab3f25aa23e6b52af1e0e81c1954f68852:

  drbd: downgraded error printk to info (2011-06-30 09:54:03 +0200)

are available in the git repository at:
  git://git.drbd.org/linux-2.6-drbd.git for-3.0-non-trivial-cosmetic

Philipp Reisner (1):
      drbd: Only print sanitize state's warnings, if the state change happens

 drivers/block/drbd/drbd_main.c |   55 +++++++++++++++++++++++++++++-----------
 1 files changed, 40 insertions(+), 15 deletions(-)
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
