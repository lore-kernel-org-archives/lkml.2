Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341Ab0HENSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 09:18:22 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46332 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760235Ab0HENST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 09:18:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 5 Aug 2010 15:14:03 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates post 2.6.35
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.20603dae546d97d7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following FireWire (IEEE 1394) subsystem updates:

  - <linux/firewire-cdev.h> userspace ABI update:

      - Add missing source node data to incoming request events.
        This, together with a libraw1394 update which is in the release
        pipeline, is required to support FFADO (FireWire audio drivers
        in userspace) in the presence of multiple devices on the same
        bus.  It is also required for other firewire-cdev.h clients that
        need to act as responders, especially target-type client
        applications.

      - Also for some kinds of responders:  Add missing extended tcode
        to incoming lock request events.  Improve the ABI for address
        range allocation to provide the same comfort as for kernelspace
        drivers.

      - Implement PHY packet transmission and reception.  Among else
        this allows to implement VersaPHY drivers in userspace (or
        kernelspace).

      - Implement multichannel isochronous reception.  This is the last
        noteworthy (though rarely used) feature of the older ieee1394
        stack that was not yet implemented by firewire-core and -ohci.

  - New driver:  Nosy, a packet sniffer.  This turns a PCILynx
    controller into a low-cost FireWire bus analyzer.  A small userspace
    front-end to this driver is provided under tools/firewire/. 

  - Close last gaps in firewire-core's Command and Status Registers
    support.

  - Enable Message Signaled Interrupts on native PCIe controllers,
    except for known broken ones.

  - As usual, several bug fixes.

Credits:  The shortlog does not give away that a good deal of
firewire-cdev related updates were prototypically implemented or
otherwise brought forward by Jay Fenlason.  The driver Nosy was written
by Kristian Høgsberg, I merely merged the stand-alone sources into the
kernel tree.

Thanks.

Clemens Ladisch (20):
      firewire: ohci: add MSI support
      firewire: check cdev response length
      firewire: ohci: speed up PHY register accesses
      firewire: core: retry on local errors in bus manager election
      firewire: core: add CSR STATE_CLEAR/STATE_SET support
      firewire: add read_csr_reg driver callback
      firewire: add CSR NODE_IDS support
      firewire: core: add CSR RESET_START support
      firewire: core: add CSR SPLIT_TIMEOUT support
      firewire: add CSR CYCLE_TIME write support
      firewire: add CSR BUS_TIME support
      firewire: add CSR BUSY_TIMEOUT support
      firewire: add CSR PRIORITY_BUDGET support
      firewire: core: add CSR MAINT_UTILITY support
      firewire: add CSR cmstr support
      firewire: core: add CSR abdicate support
      firewire: allocate broadcast channel in hardware
      firewire: core: always enable cycle master packets
      firewire: cdev: fix race in iso context creation
      firewire: cdev: check write quadlet request length to avoid buffer overflow

Jay Fenlason (2):
      firewire: cdev: fix responses to nodes at different card
      firewire: expose extended tcode of incoming lock requests to (userspace) drivers

Joe Perches (1):
      ieee1394: Remove unnecessary casts of private_data

Julia Lawall (1):
      ieee1394: video1394: Use memdup_user

Stefan Richter (59):
      firewire: ohci: do not enable interrupts without the handler
      firewire: core: trivial fix for warning strings
      firewire: 'add CSR_... support' addendum
      firewire: drop sizeof expressions from some request size arguments
      firewire: replace get_features card driver hook
      firewire: normalize STATE_CLEAR/SET CSR access interface
      firewire: core: combine some repeated code
      firewire: rename CSR access driver methods
      ieee1394: remove unused variables
      firewire: core: remove unused variable
      firewire: core: remove an unnecessary zero initialization
      firewire: remove an unused function argument
      firewire: cdev: count references of cards during inbound transactions
      firewire: cdev: freeze FW_CDEV_VERSION due to libraw1394 bug
      firewire: cdev: fix ABI for FCP and address range mapping, add fw_cdev_event_request2
      firewire: cdev: extend fw_cdev_event_iso_interrupt documentation
      firewire: core: no need to track irq flags in bm_work
      firewire: cdev: fix fw_cdev_event_bus_reset.bm_node_id
      firewire: core: fix fw_send_request kerneldoc comment
      firewire: core: ensure some userspace API constants match corresponding kernel API constants
      firewire: cdev: fix fw_cdev_event_bus_reset emission after local config ROM changes
      firewire: core: integrate software-forced bus resets with bus management
      firewire: normalize status values in packet callbacks
      firewire: cdev: some clarifications to the API documentation
      firewire: core: use C99 initializer in array of ioctl handlers
      firewire: cdev: add PHY packet transmission
      firewire: cdev: add PHY packet reception
      firewire: cdev: add PHY pinging
      firewire: core: fix upper bound of possible CSR allocations
      firewire: cdev: improve FW_CDEV_IOC_ALLOCATE
      firewire: new driver: nosy - IEEE 1394 traffic sniffer
      firewire: nosy: misc cleanups
      firewire: nosy: convert to unlocked ioctl
      firewire: nosy: fix list corruption by NOSY_IOC_STOP
      firewire: nosy: use flagless variants of spinlock accessors
      firewire: nosy: unroll some simple functions
      firewire: nosy: fix IRQ handler for card ejection
      firewire: nosy: handle errors in device probe
      firewire: nosy: fix device shutdown with active client
      firewire: nosy: annotate __user pointers and __iomem pointers
      firewire: nosy: endianess fixes and annotations
      firewire: nosy: use generic printk macros
      firewire: nosy: note ioctls in ioctl-number.txt
      tools/firewire: add userspace front-end of nosy
      tools/firewire: nosy-dump: fix it on x86-64
      tools/firewire: nosy-dump: work around segfault in decode_fcp
      tools/firewire: nosy-dump: change to kernel coding style
      tools/firewire: nosy-dump: make some symbols static or const
      tools/firewire: nosy-dump: break up a deeply nested function
      tools/firewire: nosy-dump: use linux/firewire-constants.h
      tools/firewire: nosy-dump: remove unused code
      tools/firewire: nosy-dump: increment program version
      firewire: ohci: use memory barriers to order descriptor updates
      firewire: ohci: release channel in error path
      firewire: core: remove unused code
      firewire: core: small clarifications in core-cdev
      firewire: add isochronous multichannel reception
      firewire: core: add forgotten dummy driver methods, remove unused ones
      Merge firewire branches to be released post v2.6.35

 Documentation/ioctl/ioctl-number.txt    |    1 +
 MAINTAINERS                             |    1 +
 drivers/firewire/Kconfig                |   24 +
 drivers/firewire/Makefile               |    1 +
 drivers/firewire/core-card.c            |  218 ++++--
 drivers/firewire/core-cdev.c            |  409 +++++++--
 drivers/firewire/core-device.c          |   11 +-
 drivers/firewire/core-iso.c             |   34 +-
 drivers/firewire/core-topology.c        |   22 +-
 drivers/firewire/core-transaction.c     |  306 +++++--
 drivers/firewire/core.h                 |   24 +-
 drivers/firewire/net.c                  |    4 +-
 drivers/firewire/nosy-user.h            |   25 +
 drivers/firewire/nosy.c                 |  721 ++++++++++++++++
 drivers/firewire/nosy.h                 |  237 ++++++
 drivers/firewire/ohci.c                 |  701 ++++++++++++----
 drivers/firewire/ohci.h                 |    1 +
 drivers/firewire/sbp2.c                 |   13 +-
 drivers/ieee1394/dv1394.c               |   18 +-
 drivers/ieee1394/eth1394.c              |    3 -
 drivers/ieee1394/raw1394.c              |    7 +-
 drivers/ieee1394/sbp2.c                 |   11 +-
 drivers/ieee1394/video1394.c            |   17 +-
 drivers/media/dvb/firewire/firedtv-fw.c |    4 +-
 include/linux/firewire-cdev.h           |  501 +++++++++--
 include/linux/firewire.h                |   62 +-
 tools/firewire/Makefile                 |   19 +
 tools/firewire/decode-fcp.c             |  213 +++++
 tools/firewire/list.h                   |   62 ++
 tools/firewire/nosy-dump.c              | 1031 +++++++++++++++++++++++
 tools/firewire/nosy-dump.h              |  173 ++++
 31 files changed, 4303 insertions(+), 571 deletions(-)
 create mode 100644 drivers/firewire/nosy-user.h
 create mode 100644 drivers/firewire/nosy.c
 create mode 100644 drivers/firewire/nosy.h
 create mode 100644 tools/firewire/Makefile
 create mode 100644 tools/firewire/decode-fcp.c
 create mode 100644 tools/firewire/list.h
 create mode 100644 tools/firewire/nosy-dump.c
 create mode 100644 tools/firewire/nosy-dump.h

-- 
Stefan Richter
-=====-==-=- =--- --=-=
http://arcgraph.de/sr/



