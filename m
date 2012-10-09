Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab2JIMCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:02:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7504 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2JIMCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:02:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 09 Oct 2012 05:00:21 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/5] mfd: tps65910: use regmap irq framework for interrupt
Date: Tue, 9 Oct 2012 16:58:31 +0530
Message-ID: <1349782116-9757-1-git-send-email-ldewangan@nvidia.com>
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

Laxman Dewangan (5):
  mfd: tps65910: use regmap irq framework for interrupt support
  mfd: tps65910: move interrupt implementation code to mfd file
  mfd: tps65910: Initialize mfd devices after all initialization done
  regmap: add API to get irq_domain from regmap irq
  mfd: tps65910: pass irq_domain when adding mfd sub devices

 drivers/base/regmap/regmap-irq.c |   16 +++
 drivers/mfd/Makefile             |    2 +-
 drivers/mfd/tps65910-irq.c       |  260 --------------------------------------
 drivers/mfd/tps65910.c           |  235 +++++++++++++++++++++++++++++++++--
 include/linux/mfd/tps65910.h     |  143 +++++++++++++++-------
 include/linux/regmap.h           |    1 +
 6 files changed, 343 insertions(+), 314 deletions(-)
 delete mode 100644 drivers/mfd/tps65910-irq.c

