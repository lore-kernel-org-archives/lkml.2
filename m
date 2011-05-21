Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1EUKIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 06:08:18 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51965 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1EUKIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 06:08:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 21 May 2011 12:07:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [git pull] FireWire updates post 2.6.39
Message-ID: <20110521120718.6a67029e@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following updates for the IEEE 1394 (FireWire) subsystem.
They contain small fixes and some optimizations, e.g. to CPU utilization
during isochronous I/O.

The changes in {drivers/media/dvb,sound}/firewire/ have been Cc'd to
linux-media and alsa-devel but I did not request explicit Acks.  There
are no conflicts yet and are unlikely to arise during the merge window.

Thanks.

Clemens Ladisch (4):
      firewire: ohci: do not start DMA contexts before link is enabled
      firewire: ohci: avoid separate DMA mapping for small AT payloads
      firewire: ohci: optimize find_branch_descriptor()
      firewire: optimize iso queueing by setting wake only after the last packet

Stefan Richter (6):
      Merge tag 'v2.6.39-rc7'
      firewire: octlet AT payloads can be stack-allocated
      firewire: core: use non-reentrant workqueue with rescuer
      firewire: sbp2: omit Scsi_Host lock from queuecommand
      firewire: sbp2: octlet AT payloads can be stack-allocated
      firewire: sbp2: parallelize login, reconnect, logout

 drivers/firewire/core-card.c             |   27 +++++++-----
 drivers/firewire/core-cdev.c             |    7 +--
 drivers/firewire/core-device.c           |   31 +++++++++-----
 drivers/firewire/core-iso.c              |   27 ++++++++-----
 drivers/firewire/core-transaction.c      |   19 +++++++--
 drivers/firewire/core.h                  |    2 +
 drivers/firewire/net.c                   |    4 +-
 drivers/firewire/ohci.c                  |   64 +++++++++++++++++++----------
 drivers/firewire/sbp2.c                  |   37 +++++------------
 drivers/media/dvb/firewire/firedtv-avc.c |   15 +------
 drivers/media/dvb/firewire/firedtv-fw.c  |    1 +
 include/linux/firewire.h                 |    6 ++-
 sound/firewire/amdtp.c                   |    1 +
 sound/firewire/cmp.c                     |    3 +-
 sound/firewire/iso-resources.c           |   12 +----
 sound/firewire/iso-resources.h           |    1 -
 16 files changed, 140 insertions(+), 117 deletions(-)
-- 
Stefan Richter
-=====-==-== -=-= =-=-=
http://arcgraph.de/sr/
