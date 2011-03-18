Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1CREWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:22:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51049 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab1CREWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:22:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6288"; a="80466416"
From: adharmap@codeaurora.org
To: davidb@codeaurora.org, dwalker@fifo99.com
Cc: linux-arm-msm-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.intradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        Thomas Glexiner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PM8921 MFD V4 0/6] pm8921 core and subdevices
Date: Thu, 17 Mar 2011 21:21:52 -0700
Message-Id: <1300422118-13888-1-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


Updates from V3:
cleanup irq driver's local storage, Thomas Glexiner pointed out the remnants
cleanup the copyright comments, suggested by Grant Likely
move the mpp code from drivers/mfd to drivers/gpio

Abhijeet Dharmapurikar (5):
  mfd: pm8921: Add PMIC 8921 core driver
  mfd: pm8xxx: Add irq support
  gpio: pm8xxx-gpio: Add pm8xxx gpio driver
  MAINTAINERS: Add patterns for pmic 8921 files to MSM subsystem
  msm: board-8960: Add support for pm8921

David Collins (1):
  mfd: pm8xxx-mpp: Add pm8xxx MPP driver

 MAINTAINERS                                |    2 +
 arch/arm/mach-msm/board-msm8960.c          |   47 +++-
 arch/arm/mach-msm/include/mach/irqs-8960.h |    9 +-
 drivers/gpio/Kconfig                       |   16 +
 drivers/gpio/Makefile                      |    2 +
 drivers/gpio/pm8xxx-gpio.c                 |  451 ++++++++++++++++++++++++++++
 drivers/gpio/pm8xxx-mpp.c                  |  326 ++++++++++++++++++++
 drivers/mfd/Kconfig                        |   28 ++
 drivers/mfd/Makefile                       |    2 +
 drivers/mfd/pm8921-core.c                  |  279 +++++++++++++++++
 drivers/mfd/pm8xxx-irq.c                   |  364 ++++++++++++++++++++++
 include/linux/mfd/pm8xxx/core.h            |   81 +++++
 include/linux/mfd/pm8xxx/gpio.h            |  133 ++++++++
 include/linux/mfd/pm8xxx/irq.h             |   72 +++++
 include/linux/mfd/pm8xxx/mpp.h             |  233 ++++++++++++++
 include/linux/mfd/pm8xxx/pm8921.h          |   49 +++
 16 files changed, 2079 insertions(+), 15 deletions(-)
 create mode 100644 drivers/gpio/pm8xxx-gpio.c
 create mode 100644 drivers/gpio/pm8xxx-mpp.c
 create mode 100644 drivers/mfd/pm8921-core.c
 create mode 100644 drivers/mfd/pm8xxx-irq.c
 create mode 100644 include/linux/mfd/pm8xxx/core.h
 create mode 100644 include/linux/mfd/pm8xxx/gpio.h
 create mode 100644 include/linux/mfd/pm8xxx/irq.h
 create mode 100644 include/linux/mfd/pm8xxx/mpp.h
 create mode 100644 include/linux/mfd/pm8xxx/pm8921.h

 --
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
