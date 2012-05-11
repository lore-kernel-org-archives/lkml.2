Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab2EKLFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:05:23 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1282 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab2EKLFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:05:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 11 May 2012 04:05:10 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <dan.j.williams@intel.com>, <vinod.koul@intel.com>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 0/2] dmaengine: tegra: add dma driver
Date: Fri, 11 May 2012 16:30:42 +0530
Message-ID: <1336734044-14275-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add NVIDIA Tegra's APB dma controller driver based on dmaengine.
There is already old driver in mach-tegra/dma.c and we want to get rid
of this old style driver which exposes private apis.
Once this driver get through, there will be series of patches to move all
existing driver to use the dmaengine based driver and old mach-tegra/dma.c
will get deleted. This driver has following feature than old one:
- better queue managment.
- Cyclic transfer supports.
- Platform driver.
- Full support for device tree.
- Multiple bug fixes over old driver.

Changes from V1:
- Incorportaed review comments from Vinod.
- get rid of the tegra_dma header.
- Having clock control through runtime pm.
- Remove regmap support.

Changes from V2:
- Taken care of aall review comments provided by Vinod.
- Drop cyclic_half notify mode of dma and implemented as cyclic only.
  This will make the this patch as simple. Also this can be achive
  by cyclic once mode. If require, we will add later.
- Remove goto most of places.
- Remove the cookie_complete() in aborted case.
- Remove callback when terminating.
- Macro names are now namespaced.
- Message prints are well formated to have in 1 or 2 line.

Laxman Dewangan (2):
  dma: dmaengine: add slave req id in slave_config
  dma: tegra: add dmaengine based dma driver

 drivers/dma/Kconfig       |   13 +
 drivers/dma/Makefile      |    1 +
 drivers/dma/tegra_dma.c   | 1594 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |    4 +
 4 files changed, 1612 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/tegra_dma.c

