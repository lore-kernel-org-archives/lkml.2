Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906Ab2CVVNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:13:30 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58814 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759807Ab2CVVN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:13:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 22 Mar 2012 22:13:01 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post v3.3
Message-ID: <20120322221301.17c7ff5e@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-updates" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-updates

to receive the following IEEE 1394 (FireWire) subsystem updates:
  - Some SBP-2 initiator fixes, side product from ongoing work on a target.
  - Reintroduction of an isochronous I/O feature of the older ieee1394 driver
    stack (flush buffer completions); it was evidently rarely used but not
    actually unused.  Matching libraw1394 code is already available.
  - Be sure to prefix all kernel log messages with device name or card name,
    and other logging related cleanups.
  - Misc other small cleanups, among them a small API change that affects
    sound/firewire/.  Clemens Ladisch is aware of it.

Chris Boot (3):
      firewire: sbp2: Take into account Unit_Unique_ID
      firewire: sbp2: Ignore SBP-2 targets on the local node
      firewire: sbp2: Fix SCSI sense data mangling

Clemens Ladisch (9):
      firewire: ohci: fix too-early completion of IR multichannel buffers
      firewire: cdev: fix IR multichannel event documentation
      firewire: ohci: copy_iso_headers(): make comment match the code
      firewire: ohci: remove unused excess_bytes field
      firewire: ohci: optimize control bit checks
      firewire: ohci: simplify iso header pointer arithmetic
      firewire: ohci: factor out iso completion flushing code
      firewire: prevent dropping of completed iso packet header data
      firewire: allow explicit flushing of iso packet completions

Stefan Richter (13):
      firewire: move fw_device reference counting from drivers to core
      firewire: ohci: use dev_printk API
      firewire: sbp2: use dev_printk API
      firewire: sbp2: identify to driver core as "firewire_sbp2", not "sbp2"
      firewire: net: identify to driver core as "firewire_net", not "net"
      firewire: net: use dev_printk API
      firewire: core: prefix log messages with card name
      firewire: core: remove obsolete comment
      firewire: core: fix race at address_handler unregistration
      firewire: core: convert AR-req handler lock from _irqsave to _bh
      firewire: sbp2: replace a GFP_ATOMIC allocation
      firewire: tone down some diagnostic log messages
      firewire: ohci: move runtime debug facility out of #ifdef

santosh nayak (1):
      firewire: nosy: Use the macro DMA_BIT_MASK().

 drivers/firewire/Kconfig            |    5 -
 drivers/firewire/core-card.c        |   34 +++-
 drivers/firewire/core-cdev.c        |   24 ++-
 drivers/firewire/core-device.c      |   62 +++----
 drivers/firewire/core-iso.c         |    6 +
 drivers/firewire/core-topology.c    |   17 +-
 drivers/firewire/core-transaction.c |   44 ++---
 drivers/firewire/core.h             |   21 ++
 drivers/firewire/net.c              |   43 +++--
 drivers/firewire/nosy.c             |    4 +-
 drivers/firewire/ohci.c             |  350 +++++++++++++++++++++--------------
 drivers/firewire/sbp2.c             |  130 ++++++++-----
 include/linux/firewire-cdev.h       |   39 ++++-
 include/linux/firewire.h            |   16 +--
 sound/firewire/isight.c             |    4 +-
 sound/firewire/speakers.c           |    4 -
 16 files changed, 478 insertions(+), 325 deletions(-)

Thanks.
-- 
Stefan Richter
-=====-===-- --== =-==-
http://arcgraph.de/sr/
