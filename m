Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2ECHoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:44:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6964 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2ECHoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:44:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 03 May 2012 00:44:13 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-tegra@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/2] dmaengine: tegra: add dma driver
Date: Thu,  3 May 2012 13:11:27 +0530
Message-Id: <1336030889-32269-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
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

Laxman Dewangan (2):
  dma: dmaengine: add slave req id in slave_config
  dmaengine: tegra: add dma driver

 drivers/dma/Kconfig       |   13 +
 drivers/dma/Makefile      |    1 +
 drivers/dma/tegra_dma.c   | 1714 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |    4 +
 4 files changed, 1732 insertions(+), 0 deletions(-)
 create mode 100644 drivers/dma/tegra_dma.c

