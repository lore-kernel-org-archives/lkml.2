Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762987Ab2KBRbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:31:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14432 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761470Ab2KBRby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:31:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 Nov 2012 10:31:49 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 0/4] mfd: tps65910: use regmap irq framework for interrupt
Date: Fri, 2 Nov 2012 22:59:54 +0530
Message-ID: <1351877398-11389-1-git-send-email-ldewangan@nvidia.com>
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

Changes from V2:
- Remove the older 4th patch where API for getting irq_domain was added
  in regmap. It is already taken care by Mark B.

Laxman Dewangan (4):
  mfd: tps65910: Initialize mfd devices after all initialization done
  mfd: tps65910: use regmap irq framework for interrupt support
  mfd: tps65910: move interrupt implementation code to mfd file
  mfd: tps65910: pass irq_domain when adding mfd sub devices

 drivers/mfd/Makefile         |    2 +-
 drivers/mfd/tps65910-irq.c   |  260 ------------------------------------------
 drivers/mfd/tps65910.c       |  233 ++++++++++++++++++++++++++++++++++++--
 include/linux/mfd/tps65910.h |  143 ++++++++++++++++-------
 4 files changed, 325 insertions(+), 313 deletions(-)
 delete mode 100644 drivers/mfd/tps65910-irq.c

