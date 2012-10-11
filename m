Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab2JKLzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 07:55:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36385 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578Ab2JKLzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 07:55:40 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <peter.ujfalusi@ti.com>
Subject: [PATCH 0/6] MFD: twl6040: Conversion to use regmap_irq
Date: Thu, 11 Oct 2012 13:55:27 +0200
Message-ID: <1349956533-6374-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series will convert the twl6040 MFD core driver to use regmap_irq instead
of the custom interrupt code it used. In this way considerable amount of code
can be removed and we are going to use common, well tested code for the interrupt
dispatch.

The series is for 3.8.

Regards,
Peter
---
Peter Ujfalusi (6):
  MFD: twl6040: Fix typo for power on failure
  MFD: twl6040: Remove unused parameter for
    twl6040_power_up_completion()
  MFD: twl6040: Restructure power up and down code
  MFD: twl6040: Correct Ready and Thermal interrupt handling
  MFD: twl6040: Convert to use regmap_irq
  MFD: twl6040: Rename the core driver

 drivers/mfd/Kconfig                       |   4 +-
 drivers/mfd/Makefile                      |   2 +-
 drivers/mfd/twl6040-irq.c                 | 205 ------------------------------
 drivers/mfd/{twl6040-core.c => twl6040.c} | 137 ++++++++++++--------
 include/linux/mfd/twl6040.h               |  10 +-
 5 files changed, 92 insertions(+), 266 deletions(-)
 delete mode 100644 drivers/mfd/twl6040-irq.c
 rename drivers/mfd/{twl6040-core.c => twl6040.c} (84%)

-- 
1.7.12

