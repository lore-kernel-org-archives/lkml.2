Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab2KMOHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:07:00 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9830 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2KMOG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:06:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Nov 2012 06:06:55 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 RESEND 0/4] mfd: tps65910: use regmap irq framework for interrupt
Date: Tue, 13 Nov 2012 19:33:55 +0530
Message-ID: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
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

