Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab1BGXqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 18:46:35 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:57054 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab1BGXqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 18:46:33 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH RFCv4 0/2] CARMA Board Support
Date: Mon,  7 Feb 2011 15:23:39 -0800
Message-Id: <1297121021-3522-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Mon, 07 Feb 2011 15:23:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

This is the fourth posting of these drivers, taking into account comments
from earlier postings. The DMAEngine patches are in mainline now, and
therefore are not part of this series anymore.

RFCv3 -> RFCv4:
- updates for DATA-FPGA version 2

RFCv2 -> RFCv3:
- use miscdevice framework (removing the carma class)
- add bitfile readback capability to the programmer

RFCv1 -> RFCv2:
- change comments to kerneldoc format
- Kconfig improvements
- use the videobuf_dma_sg API in the programmer
- updates for Freescale DMAEngine DMA_SLAVE API changes

Information about the CARMA board:

The CARMA board is essentially an MPC8349EA MDS reference design with a
1GHz ADC and 4 high powered data processing FPGAs connected to the local
bus. It is all packed into a compact PCI form factor. It is used at the
Owens Valley Radio Observatory as the main component in the correlator
system.

For board information, see:
http://www.mmarray.org/~dwh/carma_board/index.html

For DATA-FPGA register layout, see:
http://www.mmarray.org/memos/carma_memo46.pdf

These drivers are the necessary pieces to get the data processing FPGAs
working and producing data. Despite the fact that the hardware is custom
and we are the only users, I'd still like to get the drivers upstream.
Several people have suggested that this is possible.

Some further patches will be forthcoming. I have a driver for the LED
subsystem and the PPS subsystem. The LED register layout is expected to
change soon, so I won't post the driver until that is finished. The PPS
driver will be posted seperately from this patch series; it is very
generic.

Thanks to everyone who has provided comments on earlier versions!

Ira W. Snyder (2):
  misc: add CARMA DATA-FPGA Access Driver
  misc: add CARMA DATA-FPGA Programmer support

 drivers/misc/Kconfig                    |    1 +
 drivers/misc/Makefile                   |    1 +
 drivers/misc/carma/Kconfig              |   18 +
 drivers/misc/carma/Makefile             |    2 +
 drivers/misc/carma/carma-fpga-program.c | 1084 +++++++++++++++++++++++
 drivers/misc/carma/carma-fpga.c         | 1446 +++++++++++++++++++++++++++++++
 6 files changed, 2552 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/carma/Kconfig
 create mode 100644 drivers/misc/carma/Makefile
 create mode 100644 drivers/misc/carma/carma-fpga-program.c
 create mode 100644 drivers/misc/carma/carma-fpga.c

-- 
1.7.3.4

