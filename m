Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245Ab0EYUqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:46:31 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56162 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934159Ab0EYUqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:46:30 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 25 May 2010 22:45:44 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates post 2.6.34
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.2b42a7f3deecfba0@s5r6.in-berlin.de>
Message-ID: <tkrat.b588758b18cda936@s5r6.in-berlin.de>
References: <tkrat.2b42a7f3deecfba0@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry, got Subject and Cc wrong in the previous mail.)

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following IEEE 1394/ FireWire subsystem updates.
You will get a trivial conflict in feature-removal-schedule.txt which,
AFAIU, you would fix up yourselves.  (If not, pull the 'post-2.6.34'
branch instead which contains an additional trivial merge commit.)

We have got here:
  - Mark character device files of the old ieee1394 stack and of the new
    firewire stack as not seekable.  Otherwise somebdy might think that
    these drivers had a use for the BKL grabbing default seek handler.
    (They don't.)
  - Transaction layer fixes.  Tweaks to PHY chip settings.
  - Announcement of drivers/ieee1394 to be removed in 2.6.37.

Thanks.

Clemens Ladisch (6):
      firewire: ohci: add a function for reading PHY registers
      firewire: ohci: do not clear PHY interrupt status inadvertently
      firewire: ohci: enable 1394a enhancements
      firewire: ohci: fix up configuration of TI chips
      firewire: core: make transaction label allocation more robust
      firewire: core: use separate timeout for each transaction

Peter Hurley (1):
      firewire: core: Fix tlabel exhaustion problem

Stefan Richter (6):
      firewire: ohci: wait for PHY register accesses to complete
      firewire: ohci: cleanups and fix for nonstandard build without debug facility
      firewire: cdev: mark char device files as not seekable
      ieee1394: mark char device files as not seekable
      firewire: core: clean up config ROM related defined constants
      ieee1394: schedule for removal

 Documentation/feature-removal-schedule.txt |   10 +
 drivers/firewire/core-card.c               |   22 +--
 drivers/firewire/core-cdev.c               |    8 +-
 drivers/firewire/core-transaction.c        |   96 ++++++----
 drivers/firewire/core.h                    |    6 +-
 drivers/firewire/ohci.c                    |  188 ++++++++++++++++----
 drivers/firewire/ohci.h                    |   10 +-
 drivers/ieee1394/dv1394.c                  |   11 +-
 drivers/ieee1394/raw1394.c                 |    3 +-
 drivers/ieee1394/video1394.c               |    5 +-
 include/linux/firewire.h                   |    5 +-
 11 files changed, 258 insertions(+), 106 deletions(-)
-- 
Stefan Richter
-=====-==-=- -=-= ==--=
http://arcgraph.de/sr/

