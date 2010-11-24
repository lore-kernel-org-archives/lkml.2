Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0KXSkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:40:00 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:12690 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0KXSj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:39:59 -0500
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Nov 2010 13:39:59 EST
Date: Wed, 24 Nov 2010 13:24:46 -0500
Message-Id: <201011241824.oAOIOkCw001546@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile drivers (PCI RC and Ethernet) for v2.6.37
X-OriginalArrivalTime: 24 Nov 2010 18:24:47.0778 (UTC) FILETIME=[E01A7820:01CB8C04]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for new drivers for the "tile"
architecture, specifically PCI root complex support and built-in
Ethernet support.  The changes are sufficiently standalone that I think
it's plausible to apply them to the 2.6.37 rc series, despite the fact
that they are not strictly bug fixes.  However, they enable the use of
tile standalone boxes (TILEmpower and Quanta S2Q) that otherwise can't
currently be used with the existing 2.6.36 or the 2.6.37 rc's.

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git drivers

The changes were mailed out to linux-net and linux-pci around Nov 2
and generated only some mild syntactical feedback.  The second round of
patches on Nov 15 generated no further comment.

The changes include the following:

Chris Metcalf (3):
      MAINTAINERS: add drivers/char/hvc_tile.c as maintained by tile
      drivers/net/tile/: on-chip network drivers for the tile architecture
      pci root complex: support for tile architecture

 MAINTAINERS                          |    2 +
 arch/tile/Kconfig                    |   12 +
 arch/tile/include/asm/cacheflush.h   |   52 +
 arch/tile/include/asm/io.h           |   15 +-
 arch/tile/include/asm/pci-bridge.h   |  117 --
 arch/tile/include/asm/pci.h          |  107 +-
 arch/tile/include/asm/processor.h    |   10 +
 arch/tile/include/hv/drv_xgbe_impl.h |  300 ++++
 arch/tile/include/hv/drv_xgbe_intf.h |  615 +++++++
 arch/tile/include/hv/netio_errors.h  |  122 ++
 arch/tile/include/hv/netio_intf.h    | 2975 ++++++++++++++++++++++++++++++++++
 arch/tile/kernel/Makefile            |    1 +
 arch/tile/kernel/pci.c               |  621 +++++++
 arch/tile/mm/init.c                  |    8 +-
 drivers/net/Kconfig                  |   12 +
 drivers/net/Makefile                 |    1 +
 drivers/net/tile/Makefile            |   10 +
 drivers/net/tile/tilepro.c           | 2406 +++++++++++++++++++++++++++
 drivers/pci/Makefile                 |    1 +
 drivers/pci/quirks.c                 |   18 +
 20 files changed, 7216 insertions(+), 189 deletions(-)
 delete mode 100644 arch/tile/include/asm/pci-bridge.h
 create mode 100644 arch/tile/include/hv/drv_xgbe_impl.h
 create mode 100644 arch/tile/include/hv/drv_xgbe_intf.h
 create mode 100644 arch/tile/include/hv/netio_errors.h
 create mode 100644 arch/tile/include/hv/netio_intf.h
 create mode 100644 arch/tile/kernel/pci.c
 create mode 100644 drivers/net/tile/Makefile
 create mode 100644 drivers/net/tile/tilepro.c
