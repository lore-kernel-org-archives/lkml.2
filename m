Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2AOJwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 04:52:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42239 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2AOJwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 04:52:17 -0500
Message-ID: <4F12A1CC.50105@kernel.dk>
Date: Sun, 15 Jan 2012 10:52:12 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block drivers for 3.3-rc
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please see below for the 3.3-rc1 block driver pull request.

Essentially two different categories here:

- Adds the driver for the Micron RealSSD P320 pci-express flash card.

- Discard improvements for xen block front/back driver

This sits "on top of" the for-3.3/core pull request. Please pull.


  git://git.kernel.dk/linux-block.git for-3.3/drivers


Asai Thambi S P (2):
      mtip32xx: updates based on feedback
      mtip32xx: do rebuild monitoring asynchronously

Dan Carpenter (1):
      mtip32xx: uninitialized variable in mtip_quiesce_io()

Jens Axboe (8):
      mtip32xx: fix warnings/errors on 32-bit compiles
      mtip32xx: cleanup compat ioctl handling
      mtip32xx: ensure that all local functions are static
      mtip32xx: mark a few more items static
      mtip32xx: add module.h include to avoid conflict with moduleh tree
      mtip32xx: update to new ->make_request() API
      Merge branch 'stable/for-jens-3.3' of git://git.kernel.org/.../konrad/xen into for-3.3/drivers
      Merge branch 'for-3.3/mtip32xx' into for-3.3/drivers

Konrad Rzeszutek Wilk (3):
      xen/blk[front|back]: Squash blkif_request_rw and blkif_request_discard together
      xen/blk[front|back]: Enhance discard support with secure erasing support.
      xen/blkback: Move processing of BLKIF_OP_DISCARD from dispatch_rw_block_io

Li Dongyang (1):
      xen-blkback: convert hole punching to discard request on loop devices

Sam Bradshaw (1):
      block: Add driver for Micron RealSSD pcie flash cards

Thomas Meyer (1):
      xen-blkfront: Use kcalloc instead of kzalloc to allocate array

 drivers/block/Kconfig               |    2 +
 drivers/block/Makefile              |    1 +
 drivers/block/mtip32xx/Kconfig      |    9 +
 drivers/block/mtip32xx/Makefile     |    5 +
 drivers/block/mtip32xx/mtip32xx.c   | 3651 +++++++++++++++++++++++++++++++++++
 drivers/block/mtip32xx/mtip32xx.h   |  423 ++++
 drivers/block/xen-blkback/blkback.c |   84 +-
 drivers/block/xen-blkback/common.h  |   67 +-
 drivers/block/xen-blkback/xenbus.c  |   12 +
 drivers/block/xen-blkfront.c        |   79 +-
 include/xen/interface/io/blkif.h    |   40 +-
 11 files changed, 4261 insertions(+), 112 deletions(-)
 create mode 100644 drivers/block/mtip32xx/Kconfig
 create mode 100644 drivers/block/mtip32xx/Makefile
 create mode 100644 drivers/block/mtip32xx/mtip32xx.c
 create mode 100644 drivers/block/mtip32xx/mtip32xx.h

-- 
Jens Axboe

