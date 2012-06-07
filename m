Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab2FGNxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:53:32 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:58667 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab2FGNx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:53:29 -0400
Date: Thu, 7 Jun 2012 15:52:24 +0200
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
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH V2 0/3] i2c-nomadik changes
Message-ID: <cover.1339076448.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2:
	- use linux/platform_data/i2c-nomadik.h not linux/i2c-nomadik.h
	- format patch with -M
	- added lee jones to the Cc: list (for device tree support)
	- minor rewording of the commit messages

Slightly edited for typos explanation, otherwise same as V1:

The patch set turns a platform device into an amba device. Its users,
i.e. mach-ux500, are converted too.  The set has no external
dependencies, although is has no visible effect until other patches
are accepted.

Reasoning:

In the STA2X11 I/O hub we are exporting a number of AMBA peripherals
to the PCI world. By using a generic pci-amba driver there is no further
code for each device, provided they are already registered under the
AMBA bus.  I already submitted the generic bridge and I'm waiting for
feedback on it (https://lkml.org/lkml/2012/5/28/194).

Status of this patch set:

The users of the driver (i.e. mach-ux500) compile properly, but I
couldn't test on any board.  The driver, as is, works on x86 under the
PCI bridge, with the not-yet-upstream clock framework and platform
data for sta2x11 devices.  However, this set is not introducing any
dead code as it only adds more flexibility.  Most of the patch is
just two renames: s/platform_device/amba_device/ and s/pdev/adev/ .

Alessandro Rubini (3):
  i2c-nomadik: move header to <linux/platform_data/i2c-nomadik.h>
  i2c-nomadik: turn the platform driver to an amba driver
  i2c-nomadik: depend on ARM_AMBA, not PLAT_NOMADIK

 arch/arm/mach-ux500/board-mop500.c                 |    2 +-
 arch/arm/mach-ux500/devices-common.h               |   23 +---
 drivers/i2c/busses/Kconfig                         |    5 +-
 drivers/i2c/busses/i2c-nomadik.c                   |  140 ++++++++++----------
 .../linux/platform_data/i2c-nomadik.h              |    6 +-
 5 files changed, 80 insertions(+), 96 deletions(-)
 rename arch/arm/plat-nomadik/include/plat/i2c.h => include/linux/platform_data/i2c-nomadik.h (91%)

-- 
1.7.7.2
