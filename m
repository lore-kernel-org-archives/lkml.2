Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab0JYHdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 03:33:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60630 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab0JYHdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 03:33:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 25 Oct 2010 09:32:58 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates post 2.6.36 (ieee1394 removal)
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.4e75ce27ff762e5b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the ieee1394-removal branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git ieee1394-removal

to receive what it says on the outside.  The replacement,
drivers/firewire/, although superior in many respects, still has some
issues that are not present in the old drivers.  But I think we are at a
point now where two IEEE 1394 stacks in the kernel are becoming more
burden than convenience for downstreams.

There is a trivial merge conflict:  The net tree edited a file which
is to be removed now.

Stefan Richter (2):
      ieee1394: move init_ohci1394_dma to drivers/firewire/
      ieee1394: remove the old IEEE 1394 driver stack

 Documentation/ABI/obsolete/dv1394                  |    9 -
 Documentation/ABI/removed/dv1394                   |   14 +
 Documentation/ABI/removed/raw1394                  |   15 +
 .../ABI/removed/raw1394_legacy_isochronous         |   16 -
 Documentation/ABI/removed/video1394                |   16 +
 Documentation/feature-removal-schedule.txt         |   10 -
 drivers/Makefile                                   |    1 -
 drivers/firewire/Kconfig                           |    5 -
 drivers/firewire/Makefile                          |    1 +
 drivers/{ieee1394 => firewire}/init_ohci1394_dma.c |   76 +-
 drivers/ieee1394/Kconfig                           |  182 -
 drivers/ieee1394/Makefile                          |   18 -
 drivers/ieee1394/config_roms.c                     |  194 --
 drivers/ieee1394/config_roms.h                     |   19 -
 drivers/ieee1394/csr.c                             |  843 -----
 drivers/ieee1394/csr.h                             |   99 -
 drivers/ieee1394/csr1212.c                         | 1467 --------
 drivers/ieee1394/csr1212.h                         |  383 ---
 drivers/ieee1394/dma.c                             |  289 --
 drivers/ieee1394/dma.h                             |   89 -
 drivers/ieee1394/dv1394-private.h                  |  587 ----
 drivers/ieee1394/dv1394.c                          | 2584 --------------
 drivers/ieee1394/dv1394.h                          |  305 --
 drivers/ieee1394/eth1394.c                         | 1736 ----------
 drivers/ieee1394/eth1394.h                         |  234 --
 drivers/ieee1394/highlevel.c                       |  691 ----
 drivers/ieee1394/highlevel.h                       |  141 -
 drivers/ieee1394/hosts.c                           |  249 --
 drivers/ieee1394/hosts.h                           |  201 --
 drivers/ieee1394/ieee1394-ioctl.h                  |  106 -
 drivers/ieee1394/ieee1394.h                        |  220 --
 drivers/ieee1394/ieee1394_core.c                   | 1380 --------
 drivers/ieee1394/ieee1394_core.h                   |  172 -
 drivers/ieee1394/ieee1394_hotplug.h                |   19 -
 drivers/ieee1394/ieee1394_transactions.c           |  595 ----
 drivers/ieee1394/ieee1394_transactions.h           |   40 -
 drivers/ieee1394/ieee1394_types.h                  |   69 -
 drivers/ieee1394/iso.c                             |  568 ----
 drivers/ieee1394/iso.h                             |  195 --
 drivers/ieee1394/nodemgr.c                         | 1901 -----------
 drivers/ieee1394/nodemgr.h                         |  186 -
 drivers/ieee1394/ohci1394.c                        | 3590 --------------------
 drivers/ieee1394/ohci1394.h                        |  453 ---
 drivers/ieee1394/pcilynx.c                         | 1554 ---------
 drivers/ieee1394/pcilynx.h                         |  468 ---
 drivers/ieee1394/raw1394-private.h                 |   81 -
 drivers/ieee1394/raw1394.c                         | 3096 -----------------
 drivers/ieee1394/raw1394.h                         |  191 --
 drivers/ieee1394/sbp2.c                            | 2138 ------------
 drivers/ieee1394/sbp2.h                            |  346 --
 drivers/ieee1394/video1394.c                       | 1528 ---------
 drivers/ieee1394/video1394.h                       |   67 -
 52 files changed, 96 insertions(+), 29341 deletions(-)
 delete mode 100644 Documentation/ABI/obsolete/dv1394
 create mode 100644 Documentation/ABI/removed/dv1394
 create mode 100644 Documentation/ABI/removed/raw1394
 delete mode 100644 Documentation/ABI/removed/raw1394_legacy_isochronous
 create mode 100644 Documentation/ABI/removed/video1394
 rename drivers/{ieee1394 => firewire}/init_ohci1394_dma.c (84%)
 delete mode 100644 drivers/ieee1394/Kconfig
 delete mode 100644 drivers/ieee1394/Makefile
 delete mode 100644 drivers/ieee1394/config_roms.c
 delete mode 100644 drivers/ieee1394/config_roms.h
 delete mode 100644 drivers/ieee1394/csr.c
 delete mode 100644 drivers/ieee1394/csr.h
 delete mode 100644 drivers/ieee1394/csr1212.c
 delete mode 100644 drivers/ieee1394/csr1212.h
 delete mode 100644 drivers/ieee1394/dma.c
 delete mode 100644 drivers/ieee1394/dma.h
 delete mode 100644 drivers/ieee1394/dv1394-private.h
 delete mode 100644 drivers/ieee1394/dv1394.c
 delete mode 100644 drivers/ieee1394/dv1394.h
 delete mode 100644 drivers/ieee1394/eth1394.c
 delete mode 100644 drivers/ieee1394/eth1394.h
 delete mode 100644 drivers/ieee1394/highlevel.c
 delete mode 100644 drivers/ieee1394/highlevel.h
 delete mode 100644 drivers/ieee1394/hosts.c
 delete mode 100644 drivers/ieee1394/hosts.h
 delete mode 100644 drivers/ieee1394/ieee1394-ioctl.h
 delete mode 100644 drivers/ieee1394/ieee1394.h
 delete mode 100644 drivers/ieee1394/ieee1394_core.c
 delete mode 100644 drivers/ieee1394/ieee1394_core.h
 delete mode 100644 drivers/ieee1394/ieee1394_hotplug.h
 delete mode 100644 drivers/ieee1394/ieee1394_transactions.c
 delete mode 100644 drivers/ieee1394/ieee1394_transactions.h
 delete mode 100644 drivers/ieee1394/ieee1394_types.h
 delete mode 100644 drivers/ieee1394/iso.c
 delete mode 100644 drivers/ieee1394/iso.h
 delete mode 100644 drivers/ieee1394/nodemgr.c
 delete mode 100644 drivers/ieee1394/nodemgr.h
 delete mode 100644 drivers/ieee1394/ohci1394.c
 delete mode 100644 drivers/ieee1394/ohci1394.h
 delete mode 100644 drivers/ieee1394/pcilynx.c
 delete mode 100644 drivers/ieee1394/pcilynx.h
 delete mode 100644 drivers/ieee1394/raw1394-private.h
 delete mode 100644 drivers/ieee1394/raw1394.c
 delete mode 100644 drivers/ieee1394/raw1394.h
 delete mode 100644 drivers/ieee1394/sbp2.c
 delete mode 100644 drivers/ieee1394/sbp2.h
 delete mode 100644 drivers/ieee1394/video1394.c
 delete mode 100644 drivers/ieee1394/video1394.h

-- 
Stefan Richter
-=====-==-=- =-=- ==--=
http://arcgraph.de/sr/

