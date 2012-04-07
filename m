Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab2DGXRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 19:17:00 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:5567 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2DGXQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 19:16:59 -0400
Message-Id: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 7 Apr 2012 16:53:03 -0400
Subject: [PATCH 0/3] arch/tile: provide PCIe support for tilegx
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        David Howells <dhowells@redhat.com>
X-OriginalArrivalTime: 07 Apr 2012 23:16:58.0942 (UTC) FILETIME=[8808CDE0:01CD1514]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of changes adds PCIe support to the tilegx architecture
using the on-chip TRIO ("Transation I/O") hardware.  The last change is
the one that adds PCI support per-se and it is cc'ed to a wider audience.

As usual, any code review would be appreciated.  This is layered on
top of the GXIO IORPC mechanism presented in the previous patch series,
which provided networking support for tilegx.

 arch/tile/Kconfig                            |   13 +-
 arch/tile/gxio/Kconfig                       |    9 +
 arch/tile/gxio/Makefile                      |    1 +
 arch/tile/gxio/iorpc_trio.c                  |  352 ++++++
 arch/tile/gxio/trio.c                        |   49 +
 arch/tile/include/arch/trio.h                |   68 ++
 arch/tile/include/arch/trio_constants.h      |   36 +
 arch/tile/include/arch/trio_def.h            |   41 +
 arch/tile/include/arch/trio_pcie_intfc.h     |  203 ++++
 arch/tile/include/arch/trio_pcie_intfc_def.h |   32 +
 arch/tile/include/arch/trio_pcie_rc.h        |  144 +++
 arch/tile/include/arch/trio_pcie_rc_def.h    |   24 +
 arch/tile/include/arch/trio_shm.h            |  111 ++
 arch/tile/include/arch/trio_shm_def.h        |   19 +
 arch/tile/include/asm/pci.h                  |   97 ++-
 arch/tile/include/gxio/iorpc_trio.h          |  198 ++++
 arch/tile/include/gxio/trio.h                |  303 +++++
 arch/tile/include/hv/drv_trio_intf.h         |  196 ++++
 arch/tile/kernel/Makefile                    |    4 +
 arch/tile/kernel/pci_gx.c                    | 1597 ++++++++++++++++++++++++++
 arch/tile/kernel/setup.c                     |    6 +
 arch/tile/mm/pgtable.c                       |    7 -
 drivers/pci/quirks.c                         |    6 +-
 23 files changed, 3490 insertions(+), 26 deletions(-)
