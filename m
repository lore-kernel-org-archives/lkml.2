Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab0ICWbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 18:31:32 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:42432 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0ICWba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 18:31:30 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH RFCv1 0/3] CARMA Board Support
Date: Fri,  3 Sep 2010 15:30:49 -0700
Message-Id: <1283553052-23576-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 03 Sep 2010 15:31:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Yesterday I asked where board specific drivers should be located in the
source tree. Several people suggested I just post the drivers for review
right away, and let the reviewers comment on where to put the drivers.

Here they are. I've created a new drivers/fpga/carma/ directory for the
drivers. I expect that this will not be their final resting place.

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

Ira W. Snyder (3):
  fpga: add basic CARMA board support
  fpga: add CARMA DATA-FPGA Access Driver
  fpga: add CARMA DATA-FPGA Programmer support

 drivers/Kconfig                         |    2 +
 drivers/Makefile                        |    1 +
 drivers/fpga/Kconfig                    |    1 +
 drivers/fpga/Makefile                   |    1 +
 drivers/fpga/carma/Kconfig              |   38 +
 drivers/fpga/carma/Makefile             |    3 +
 drivers/fpga/carma/carma-fpga-program.c | 1136 ++++++++++++++++++++++++
 drivers/fpga/carma/carma-fpga.c         | 1447 +++++++++++++++++++++++++++++++
 drivers/fpga/carma/carma.c              |   73 ++
 drivers/fpga/carma/carma.h              |   22 +
 10 files changed, 2724 insertions(+), 0 deletions(-)
 create mode 100644 drivers/fpga/Kconfig
 create mode 100644 drivers/fpga/Makefile
 create mode 100644 drivers/fpga/carma/Kconfig
 create mode 100644 drivers/fpga/carma/Makefile
 create mode 100644 drivers/fpga/carma/carma-fpga-program.c
 create mode 100644 drivers/fpga/carma/carma-fpga.c
 create mode 100644 drivers/fpga/carma/carma.c
 create mode 100644 drivers/fpga/carma/carma.h

