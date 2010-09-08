Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0IHQlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:41:35 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:44226 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab0IHQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:41:32 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH RFCv2 0/5] CARMA Board Support
Date: Wed,  8 Sep 2010 09:41:17 -0700
Message-Id: <1283964082-30133-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Wed, 08 Sep 2010 09:41:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

This is the second posting of these drivers, taking into account comments
from the RFCv1 post. Thanks to all that contributed.

The changes:
- change comments to kerneldoc format
- Kconfig improvements
- use the videobuf_dma_sg API in the programmer
- updates for Freescale DMAEngine DMA_SLAVE API changes

In a seperate thread, AKPM asked for some changes to the Freescale
DMAEngine driver. They are already part of -mm, and do not need review. To
make testing easier, I have included the changes as the first two patches
in this series. If you are using -mm, please ignore them.

Information about the CARMA board:

The CARMA board is essentially an MPC8349EA MDS reference design with a
1GHz ADC and 4 high powered data processing FPGAs connected to the local
bus. It is all packed into a compact PCI form factor. It is used at the
Owens Valley Radio Observatory as the main component in the correlator
system.

For more information, see this webpage, maintained by the board's hardware
engineer: http://www.mmarray.org/~dwh/carma_board/index.html

These drivers are the necessary pieces to get the data processing FPGAs
working and producing data. Despite the fact that the hardware is custom
and we are the only users, I'd still like to get the drivers upstream.
Several people have suggested that this is possible.

Some further patches will be forthcoming. I have a driver for the LED
subsystem and the PPS subsystem. The LED register layout is expected to
change soon, so I won't post the driver until that is finished. The PPS
driver will be posted seperately from this patch series; it is very
generic.

Thanks for any review and comments you can offer!
Ira

Ira W. Snyder (5):
  fsldma: fix missing header include
  fsldma: move DMA_SLAVE support functions to the driver
  fpga: add basic CARMA board support
  fpga: add CARMA DATA-FPGA Access Driver
  fpga: add CARMA DATA-FPGA Programmer support

 arch/powerpc/include/asm/fsldma.h       |   71 +--
 drivers/Kconfig                         |    2 +
 drivers/Makefile                        |    1 +
 drivers/dma/fsldma.c                    |   77 ++
 drivers/fpga/Kconfig                    |    1 +
 drivers/fpga/Makefile                   |    1 +
 drivers/fpga/carma/Kconfig              |   38 +
 drivers/fpga/carma/Makefile             |    3 +
 drivers/fpga/carma/carma-fpga-program.c | 1023 +++++++++++++++++++++
 drivers/fpga/carma/carma-fpga.c         | 1471 +++++++++++++++++++++++++++++++
 drivers/fpga/carma/carma.c              |   73 ++
 drivers/fpga/carma/carma.h              |   22 +
 12 files changed, 2719 insertions(+), 64 deletions(-)
 create mode 100644 drivers/fpga/Kconfig
 create mode 100644 drivers/fpga/Makefile
 create mode 100644 drivers/fpga/carma/Kconfig
 create mode 100644 drivers/fpga/carma/Makefile
 create mode 100644 drivers/fpga/carma/carma-fpga-program.c
 create mode 100644 drivers/fpga/carma/carma-fpga.c
 create mode 100644 drivers/fpga/carma/carma.c
 create mode 100644 drivers/fpga/carma/carma.h

