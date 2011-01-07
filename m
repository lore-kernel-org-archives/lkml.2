Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1AGQ40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:56:26 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40947 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab1AGQ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:56:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 7 Jan 2011 17:55:39 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post 2.6.37
Message-ID: <20110107175539.2b882d3d@stein>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following updates for the IEEE 1394 (FireWire) subsystem.
Most importantly this improves reception of asynchronous block packets
with larger payload (outside physical DMA), as used by IP over 1394 or
for example forensics applications.

As not all patches had been crossposted to lkml yet, I will send the
full log and diff as reply to this mail.

Clemens Ladisch (10):
      firewire: ohci: Asynchronous Reception rewrite
      firewire: ohci: fix AT context initialization error handling
      firewire: ohci: flush MMIO writes in the interrupt handler
      firewire: ohci: properly clear posted write errors
      firewire: make PHY packet header format consistent
      firewire: ohci: optimize iso context checks in the interrupt handler
      firewire: ohci: use common buffer for self IDs and AR descriptors
      firewire: ohci: flush AT contexts after bus reset for OHCI 1.2
      firewire: ohci: cache the context run bit
      firewire: use split transaction timeout only for split transactions

Joe Perches (1):
      firewire: core: Update WARN uses

Maxim Levitsky (4):
      firewire: ohci: restore GUID on resume.
      firewire: ohci: restart iso DMA contexts on resume from low power mode
      firewire: net: ratelimit error messages
      firewire: net: add carrier detection

Stefan Richter (4):
      firewire: nosy: char device is not seekable
      firewire: net: set carrier state at ifup
      firewire: ohci: flush AT contexts after bus reset - addendum
      firewire: ohci: consolidate context status flags

 drivers/firewire/Kconfig            |    2 +-
 drivers/firewire/core-cdev.c        |    7 +-
 drivers/firewire/core-transaction.c |   58 ++-
 drivers/firewire/core.h             |    4 +-
 drivers/firewire/net.c              |   47 ++-
 drivers/firewire/nosy.c             |    3 +-
 drivers/firewire/ohci.c             |  672 ++++++++++++++++++++++++-----------
 include/linux/firewire.h            |    2 +-
 8 files changed, 548 insertions(+), 247 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-==-== ---= --===
http://arcgraph.de/sr/
