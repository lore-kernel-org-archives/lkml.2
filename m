Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2JIKXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:23:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1722 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab2JIKXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:23:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 09 Oct 2012 03:12:07 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>
CC: <sameo@linux.intel.com>, <vbyravarasu@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/4] regulator: tps65090: fix regulator registration and add external control support
Date: Tue, 9 Oct 2012 15:18:58 +0530
Message-ID: <1349776142-6409-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes the regulator registration issue and add support
for external control.
Patch 1: It renames the driver name and regulators to more appropriate.
Patch 2: Fix the issue with regulator registration.
Patch 3: Add LDO support.
Patch 4: Add voltage output level information.
Patch 5: Add support for extenal control for DCDC.

Changes from V1:
- Shuffle patch 1 and 2 to make patch2 to patch1.
- Remove patch 4 for output voltage level.
- Move some of implementation from patch 5 to new patch1 for patch1
  completion.
- Move the content of tps65090-regulator.h to mfd/tps65090.h and remove
  this file.

Laxman Dewangan (4):
  regulator; tps65090: Register all regulators in single probe call
  regulator: tps65090: rename driver name and regulator name
  regulator: tps65090: Add support for LDO regulators
  regulator: tps65090: add external control support for DCDC

 drivers/regulator/tps65090-regulator.c       |  245 +++++++++++++++++++-------
 include/linux/mfd/tps65090.h                 |   35 ++++
 include/linux/regulator/tps65090-regulator.h |   50 ------
 3 files changed, 218 insertions(+), 112 deletions(-)
 delete mode 100644 include/linux/regulator/tps65090-regulator.h

