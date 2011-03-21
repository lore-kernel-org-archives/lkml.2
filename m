Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1CUOeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:34:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41126 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1CUOef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:34:35 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 21 Mar 2011 15:34:17 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post 2.6.38
Message-ID: <20110321153417.586f5e2a@stein>
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
This series contains various housekeeping bits, a fix for a bug that bites
with a firewire sound driver which was merged three days ago via ALSA, and
improved compatibility with some rare quirky devices.

Topmost three changes were committed way after you opened the merge
window, but these contain said quirk handling and I would have sent them
to you even outside of a merge window.

Thanks.

Clemens Ladisch (9):
      firewire: ohci: log dead DMA contexts
      firewire: cdev: remove unneeded idr_find() from complete_transaction()
      firewire: cdev: always wait for outbound transactions to complete
      firewire: cdev: remove unneeded reference
      firewire: core: fix card->reset_jiffies overflow
      firewire: core: rename some variables
      firewire: ohci: prevent iso completion callbacks after context stop
      firewire: ohci: prevent starting of iso contexts with empty queue
      firewire: core: increase default SPLIT_TIMEOUT value

Oleg Drokin (1):
      firewire: ohci: Misleading kfree in ohci.c::pci_probe/remove

Stefan Richter (4):
      firewire: nosy: should work on Power Mac G4 PCI too
      firewire: ohci: omit IntEvent.busReset check rom AT queueing
      firewire: sbp2: revert obsolete 'fix stall with "Unsolicited response"'
      firewire: core: ignore link-active bit of new nodes, fix device recognition

 drivers/firewire/Kconfig         |    3 +-
 drivers/firewire/core-card.c     |   21 +++++++---
 drivers/firewire/core-cdev.c     |   54 +++++++++++++-----------
 drivers/firewire/core-device.c   |   22 ++++++----
 drivers/firewire/core-iso.c      |   22 +++++-----
 drivers/firewire/core-topology.c |    2 +-
 drivers/firewire/ohci.c          |   85 ++++++++++++++++++++++++++++---------
 drivers/firewire/sbp2.c          |   11 +----
 include/linux/firewire.h         |    2 +-
 9 files changed, 140 insertions(+), 82 deletions(-)
-- 
Stefan Richter
-=====-==-== --== =-=-=
http://arcgraph.de/sr/
