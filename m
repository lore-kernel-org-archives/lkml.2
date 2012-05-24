Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483Ab2EXTX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:23:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52161 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934108Ab2EXTPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:15:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 24 May 2012 21:14:55 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire updates post v3.4
Message-ID: <20120524211455.6c3464cd@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
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

  - Fix mismatch between DMA mapping direction (was wrong) and DMA synchronization
    direction (was correct) of isochronous reception buffers of userspace drivers
    if vma-mapped for R/W access.  For example, libdc1394 was affected.

  - more consistent retry stategy in device discovery/ rediscovery, and improved
    failure diagnostics

  - various small cleanups, e.g. use SCSI layer's DMA mapping API in firewire-sbp2

The last few commits happened rather late for this pull request but I feel comfortable
with them.  ALSA firewire-lib changes were written by Clemens, hence are implicitly ACKed.

Axel Lin (1):
      firewire: use module_pci_driver

Clemens Ladisch (10):
      firewire: core: wait for inaccessible devices after bus reset
      firewire: core: improve reread_config_rom() interface
      firewire: move rcode_string() to core
      firewire: core: log error in case of failed bus manager lock
      firewire: core: log config rom reading errors
      firewire: core: fw_device_refresh(): clean up error handling
      firewire: sbp2: give correct DMA device to scsi framework
      firewire: sbp2: use scsi_dma_(un)map
      firewire: sbp2: remove superfluous blk_queue_max_segment_size() call
      firewire: sbp2: document the absence of alignment requirements

Stefan Richter (4):
      firewire: core: fix DMA mapping direction
      firewire: ohci: correct signedness of a local variable
      firewire: ohci: omit spinlock IRQ flags where possible
      Merge tag 'v3.4' with SCSI updates, needed for subsequent firewire-sbp2 changes

 drivers/firewire/core-card.c        |    4 +-
 drivers/firewire/core-cdev.c        |   51 ++++++++++++---
 drivers/firewire/core-device.c      |  116 +++++++++++++++++------------------
 drivers/firewire/core-iso.c         |   80 +++++++++++++++---------
 drivers/firewire/core-transaction.c |   26 ++++++++
 drivers/firewire/core.h             |    7 ++-
 drivers/firewire/nosy.c             |   20 ++----
 drivers/firewire/ohci.c             |   42 +++++--------
 drivers/firewire/sbp2.c             |   28 ++++-----
 include/linux/firewire.h            |    2 +
 sound/firewire/cmp.c                |    2 +-
 sound/firewire/lib.c                |   28 +--------
 sound/firewire/lib.h                |    1 -
 13 files changed, 218 insertions(+), 189 deletions(-)

Thanks,
-- 
Stefan Richter
-=====-===-- -=-= ==---
http://arcgraph.de/sr/
