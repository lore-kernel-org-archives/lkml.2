Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab2FRPUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:20:18 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:64689 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab2FRPUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:20:03 -0400
Message-ID: <4FDF4720.1010801@tilera.com>
Date: Mon, 18 Jun 2012 11:20:00 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [GIT PULL] tilegx ethernet driver support
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/16/2012 9:01 PM, Linus Torvalds wrote:
> Apart from the new tilegx ethernet driver that came in through the
> networking tree, it's all reasonably small.

There are five additional commits that are required to make that driver
actually buildable: the tilegx GXIO IORPC framework, including DMA support,
the GXIO support for the tilegx ethernet engine, <asm/io.h> support for
MMIO-based readb/writeb, and a minor refactoring change.  These have been
through some rounds of review on LKML and have been on linux-next for a
couple of months.

I thought David was queueing the driver for 3.6, and he presumably thought
all the prerequisite core tile changes were already in 3.5 :-)

I'm happy to just say "oh well" and leave the tilegx network driver
unbuildable until 3.6.  Or, you can pull those five commits; they are 100%
tile-specific and only affect tilegx iorpc drivers, of which this is now
the only one in the tree.  (Two more are queued up in linux-next for 3.6,
namely PCIe root complex and USB host.)

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git tilegx-net

----------------------------------------------------------------
Chris Metcalf (5):
      arch/tile: introduce GXIO IORPC framework for tilegx
      arch/tile: common DMA code for the GXIO IORPC subsystem
      arch/tile: support MMIO-based readb/writeb etc.
      arch/tile: provide kernel support for the tilegx mPIPE shim
      arch/tile: break out the "csum a long" function to <asm/checksum.h>

 arch/tile/Kconfig                         |    2 +
 arch/tile/Makefile                        |    2 +
 arch/tile/gxio/Kconfig                    |   17 +
 arch/tile/gxio/Makefile                   |    7 +
 arch/tile/gxio/dma_queue.c                |  176 +++
 arch/tile/gxio/iorpc_globals.c            |   89 ++
 arch/tile/gxio/iorpc_mpipe.c              |  529 +++++++++
 arch/tile/gxio/iorpc_mpipe_info.c         |   85 ++
 arch/tile/gxio/kiorpc.c                   |   61 +
 arch/tile/gxio/mpipe.c                    |  545 +++++++++
 arch/tile/include/arch/mpipe.h            |  359 ++++++
 arch/tile/include/arch/mpipe_constants.h  |   42 +
 arch/tile/include/arch/mpipe_def.h        |   39 +
 arch/tile/include/arch/mpipe_shm.h        |  509 +++++++++
 arch/tile/include/arch/mpipe_shm_def.h    |   23 +
 arch/tile/include/asm/checksum.h          |   18 +
 arch/tile/include/asm/io.h                |  144 ++-
 arch/tile/include/gxio/common.h           |   40 +
 arch/tile/include/gxio/dma_queue.h        |  161 +++
 arch/tile/include/gxio/iorpc_globals.h    |   38 +
 arch/tile/include/gxio/iorpc_mpipe.h      |  136 +++
 arch/tile/include/gxio/iorpc_mpipe_info.h |   46 +
 arch/tile/include/gxio/kiorpc.h           |   29 +
 arch/tile/include/gxio/mpipe.h            | 1736 +++++++++++++++++++++++++++++
 arch/tile/include/hv/drv_mpipe_intf.h     |  602 ++++++++++
 arch/tile/include/hv/iorpc.h              |  714 ++++++++++++
 arch/tile/lib/checksum.c                  |   15 +-
 27 files changed, 6122 insertions(+), 42 deletions(-)
 create mode 100644 arch/tile/gxio/Kconfig
 create mode 100644 arch/tile/gxio/Makefile
 create mode 100644 arch/tile/gxio/dma_queue.c
 create mode 100644 arch/tile/gxio/iorpc_globals.c
 create mode 100644 arch/tile/gxio/iorpc_mpipe.c
 create mode 100644 arch/tile/gxio/iorpc_mpipe_info.c
 create mode 100644 arch/tile/gxio/kiorpc.c
 create mode 100644 arch/tile/gxio/mpipe.c
 create mode 100644 arch/tile/include/arch/mpipe.h
 create mode 100644 arch/tile/include/arch/mpipe_constants.h
 create mode 100644 arch/tile/include/arch/mpipe_def.h
 create mode 100644 arch/tile/include/arch/mpipe_shm.h
 create mode 100644 arch/tile/include/arch/mpipe_shm_def.h
 create mode 100644 arch/tile/include/gxio/common.h
 create mode 100644 arch/tile/include/gxio/dma_queue.h
 create mode 100644 arch/tile/include/gxio/iorpc_globals.h
 create mode 100644 arch/tile/include/gxio/iorpc_mpipe.h
 create mode 100644 arch/tile/include/gxio/iorpc_mpipe_info.h
 create mode 100644 arch/tile/include/gxio/kiorpc.h
 create mode 100644 arch/tile/include/gxio/mpipe.h
 create mode 100644 arch/tile/include/hv/drv_mpipe_intf.h
 create mode 100644 arch/tile/include/hv/iorpc.h

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

