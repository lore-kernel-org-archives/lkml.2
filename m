Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab2E3Rq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:46:57 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:35173 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327Ab2E3Rqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:46:50 -0400
Date: Wed, 30 May 2012 19:45:30 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jean Delvare <khali@linux-fr.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: [PATCH RFC 0/3] i2c-nomadik changes
Message-ID: <cover.1338398567.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch set turns a platform device into an amba device. Its users,
i.e. mach-ux500, are converted too.  The set has no external
dependencies, although is has no visible effect until other patches
are accepted.

Reasoning:

In the STA2X11 I/O hub we are exporting a number of AMBA peripherals
to the PCI world. Using a generic pci-amba driver there is no further
code for each device, provided they are already registered under the
AMBA bus.  I already submitted the generic bridge
(https://lkml.org/lkml/2012/5/28/194).

Status of this patch set:

The users of the driver (i.e. mach-ux600) compile properly, but I
couldn't test on any board.  The driver, as is, works on x86 under the
PCI bridge, with the not-yet-upstream clock framework and platform
data for sta2x11 devices.  However, this set is not introducing any
dead code as it only adds more flexibility.  The big part of it is a
massive s/platform_device/amba_device/ and s/pdev/adev/ .

The cell-id I used in the table are the one for ux500 (only as far as
I know from the stn-8815 manuals) and the one for STA2X11.

Alessandro Rubini (3):
  i2c-nomadik: move header from <plat/i2c.h> to <linux/i2c-nomadik.h>
  i2c-nomadik: turn the platform driver to an amba driver
  i2c-nomadik: depend on ARM_AMBA, not PLAT_NOMADIK

 arch/arm/mach-ux500/board-mop500.c       |    2 +-
 arch/arm/mach-ux500/devices-common.h     |   23 +----
 arch/arm/plat-nomadik/include/plat/i2c.h |   39 --------
 drivers/i2c/busses/Kconfig               |    5 +-
 drivers/i2c/busses/i2c-nomadik.c         |  140 +++++++++++++++---------------
 include/linux/i2c-nomadik.h              |   39 ++++++++
 6 files changed, 116 insertions(+), 132 deletions(-)
 delete mode 100644 arch/arm/plat-nomadik/include/plat/i2c.h
 create mode 100644 include/linux/i2c-nomadik.h

-- 
1.7.7.2
