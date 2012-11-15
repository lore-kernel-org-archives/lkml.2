Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423601Ab2KOHof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:44:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5092 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423305Ab2KOHod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:44:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 14 Nov 2012 23:44:29 -0800
From: Danny Huang <dahuang@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Danny Huang <dahuang@nvidia.com>
Subject: [PATCH V2 0/3] ARM: tegra: add speedo identification for T20/T30
Date: Thu, 15 Nov 2012 15:42:31 +0800
Message-ID: <1352965354-650-1-git-send-email-dahuang@nvidia.com>
X-Mailer: git-send-email 1.8.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds speedo identification functionality for tegra
T20 and T30. It reads speedo value from fuse and chooses CPU and core 
process ID by checking speedo corner tables.

V2:
* Split spare fuse related changes to a separate patch
* Keep original fuse init flow on an unknown chip
* Change size check of speedo cornor table
* Set speedo id to 0 with unknown chip revision/SKU
* Set process id to 0 when speedo value out of range

Danny Huang (3):
  ARM: tegra: flexible spare fuse read function
  ARM: tegra: Add speedo-based process identification
  ARM: tegra: T30 speedo-based process identification

 arch/arm/mach-tegra/Makefile         |   2 +
 arch/arm/mach-tegra/fuse.c           |  49 ++++--
 arch/arm/mach-tegra/fuse.h           |  16 ++
 arch/arm/mach-tegra/tegra20_speedo.c | 109 +++++++++++++
 arch/arm/mach-tegra/tegra30_speedo.c | 292 +++++++++++++++++++++++++++++++++++
 5 files changed, 457 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm/mach-tegra/tegra20_speedo.c
 create mode 100644 arch/arm/mach-tegra/tegra30_speedo.c

-- 
1.8.0

