Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab1CHGLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 01:11:39 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30682 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1CHGLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 01:11:33 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6278"; a="78610002"
From: adharmap@codeaurora.org
To: davidb@codeaurora.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        Thomas Glexiner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [Qualcomm PM8921 MFD v2 0/6] pmic 8921 core and subdevices
Date: Mon,  7 Mar 2011 22:09:44 -0800
Message-Id: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

This patch series adds support for pmic 8921 chip and its subdevices.
The pmic 8921 chip is used as a power management ic for 8960 based boards. It
communicates over the ssbi bus, ssbi bus can be found here

https://patchwork.kernel.org/patch/601771/

The patch set contains support for interrupt, gpio and mpp (multi purpose pin)
subdevices.

Note that gpio and mpp subdevices need the interrupt subdevice to
be operational, this is becuase the reading the the value of gpio/mpp lines
happens by doing a transaction over registers managed by the interrupt subdev.
The code invokes a call on interrupt subdevice, rather than writing to those
registers directly, avoiding race conditions.

Suggestions from, Mark Brown to not create a device for interrupts
Joe Perches to use a pattern in the MAINTAINERS file are implemented. Thanks to
both of you.

Also realised that the irq chip functions now should be taking struct irq_data
instead of an irq number. This has been fixed in V2 patches.


Abhijeet Dharmapurikar (5):
  mfd: pm8921: Add PMIC 8921 core driver
  mfd: pm8xxx: Add irq support
  gpio: pm8xxx-gpio: Add pm8xxx gpio driver
  MAINTAINERS: Add patterns for pmic 8921 files to MSM subsystem
  msm: board-8960: Add support for pm8921

David Collins (1):
  mfd: pm8xxx-mpp: Add pm8xxx MPP driver

 MAINTAINERS                                |    3 +
 arch/arm/mach-msm/board-msm8960.c          |   47 ++-
 arch/arm/mach-msm/include/mach/irqs-8960.h |    9 +-
 drivers/gpio/Kconfig                       |   10 +
 drivers/gpio/Makefile                      |    1 +
 drivers/gpio/pm8xxx-gpio.c                 |  451 +++++++++++++++++++++++
 drivers/mfd/Kconfig                        |   36 ++
 drivers/mfd/Makefile                       |    3 +
 drivers/mfd/pm8921-core.c                  |  307 ++++++++++++++++
 drivers/mfd/pm8xxx-irq.c                   |  551 ++++++++++++++++++++++++++++
 drivers/mfd/pm8xxx-mpp.c                   |  320 ++++++++++++++++
 include/linux/mfd/pm8921.h                 |   48 +++
 include/linux/mfd/pm8xxx/core.h            |   75 ++++
 include/linux/mfd/pm8xxx/gpio.h            |  132 +++++++
 include/linux/mfd/pm8xxx/irq.h             |   81 ++++
 include/linux/mfd/pm8xxx/mpp.h             |  233 ++++++++++++
 16 files changed, 2292 insertions(+), 15 deletions(-)
 create mode 100644 drivers/gpio/pm8xxx-gpio.c
 create mode 100644 drivers/mfd/pm8921-core.c
 create mode 100644 drivers/mfd/pm8xxx-irq.c
 create mode 100644 drivers/mfd/pm8xxx-mpp.c
 create mode 100644 include/linux/mfd/pm8921.h
 create mode 100644 include/linux/mfd/pm8xxx/core.h
 create mode 100644 include/linux/mfd/pm8xxx/gpio.h
 create mode 100644 include/linux/mfd/pm8xxx/irq.h
 create mode 100644 include/linux/mfd/pm8xxx/mpp.h

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
