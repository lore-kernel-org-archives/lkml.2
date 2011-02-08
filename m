Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1BHXh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:37:58 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:49370 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1BHXh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 18:37:57 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH RFCv5 0/2] CARMA Board Support
Date: Tue,  8 Feb 2011 15:37:45 -0800
Message-Id: <1297208267-27087-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Tue, 08 Feb 2011 15:37:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

This is the fifth posting of these drivers, taking into account comments from
earlier postings. I would appreciate as much review as you can offer.

RFCv4 -> RFCv5:
- remove unecessary locking per review comments
- do not clobber return values from *_interruptible()
- explicitly track buffer DMA mapping
- use #defines instead of raw hex addresses
- change enable sysfs attribute to root-writeable only

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
 drivers/misc/carma/carma-fpga-program.c | 1084 ++++++++++++++++++++++++
 drivers/misc/carma/carma-fpga.c         | 1396 +++++++++++++++++++++++++++++++
 6 files changed, 2502 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/carma/Kconfig
 create mode 100644 drivers/misc/carma/Makefile
 create mode 100644 drivers/misc/carma/carma-fpga-program.c
 create mode 100644 drivers/misc/carma/carma-fpga.c

-- 
1.7.3.4

