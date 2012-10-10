Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab2JJRxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:53:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2360 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096Ab2JJRxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:53:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 10 Oct 2012 10:53:26 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/5]mfd: tps65910: use regmap irq framework for interrupt
Date: Wed, 10 Oct 2012 22:49:00 +0530
Message-ID: <1349889545-21517-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series has following change:
- Use regmap irq framework for interrupt registration. Corrected the
  register bit definition for interrupts.
- Move the irq table to tps65910.c and get rid of tps65910-irq.c.
- Raarrange the init sequence of different sub moduled of tps65910 like
  irq, clock and then mfd devices.
- Export the irq domain handle from regmap to use in mfd driver.
- Pass the irq domain in mfd_add_devices to have proper interrupt mapping
  for sub devices like RTC.


Changes from V1:
- rearrange patch on which older patch3 become the new patch 1.
- Add stub for new api in the regmap.
- Add empty line if paragraph change in description.

Laxman Dewangan (5):
  mfd: tps65910: Initialize mfd devices after all initialization done
  mfd: tps65910: use regmap irq framework for interrupt support
  mfd: tps65910: move interrupt implementation code to mfd file
  regmap: add API to get irq_domain from regmap irq
  mfd: tps65910: pass irq_domain when adding mfd sub devices

 drivers/base/regmap/regmap-irq.c |   16 +++
 drivers/mfd/Makefile             |    2 +-
 drivers/mfd/tps65910-irq.c       |  260 --------------------------------------
 drivers/mfd/tps65910.c           |  233 +++++++++++++++++++++++++++++++++--
 include/linux/mfd/tps65910.h     |  143 +++++++++++++++-------
 include/linux/regmap.h           |    8 ++
 6 files changed, 349 insertions(+), 313 deletions(-)
 delete mode 100644 drivers/mfd/tps65910-irq.c

