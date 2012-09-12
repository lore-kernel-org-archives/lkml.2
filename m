Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985Ab2ILPQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:16:40 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:35091 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486Ab2ILPQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:16:37 -0400
MIME-Version: 1.0
Date: Wed, 12 Sep 2012 20:46:35 +0530
Message-ID: <CADysL2bwAtpNgtbOMkvoYfoX8WhWpaGQeSEBDnKDabK2J_Xx8g@mail.gmail.com>
Subject: [PATCH v5 0/2] ARM: New cache API for iommu
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7d2c3436a9225b774be1eeede599c7d5bfc4c9d0 Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Wed, 12 Sep 2012 19:22:43 +0530
Subject: [PATCH v5 0/2] ARM: New cache API for iommu

This patch series is the next version to
- add a new cache maintenance api to support non-coherent iommu drivers.
- flush both L1 and L2 caches from OMAP iommu whenever the page table
  memory is updated.

Changes since the previous patch set (v4)
- Fixed RMK's comments on the api params.
- Validated the changes on the Panda board.
- Compile tested the kernel for all other ARM configurations.

The implementation of the new api is based on
the approach[1] discussed.

[1]http://marc.info/?l=linux-kernel&m=131316512713815&w=2

Ramesh Gupta G (2):
  ARM: new cache maintenance api for iommu
  OMAP:IOMMU:flush L1 and L2 caches

 arch/arm/include/asm/cacheflush.h |   21 +++++++++++++++++++
 arch/arm/include/asm/glue-cache.h |    1 +
 arch/arm/mm/cache-fa.S            |   16 ++++++++++++++
 arch/arm/mm/cache-v3.S            |   14 +++++++++++-
 arch/arm/mm/cache-v4.S            |   15 +++++++++++++
 arch/arm/mm/cache-v4wb.S          |   22 +++++++++++++++++++
 arch/arm/mm/cache-v4wt.S          |   18 ++++++++++++++++
 arch/arm/mm/cache-v6.S            |   21 +++++++++++++++++++
 arch/arm/mm/cache-v7.S            |   22 +++++++++++++++++++
 arch/arm/mm/proc-arm1020.S        |   23 ++++++++++++++++++++
 arch/arm/mm/proc-arm1020e.S       |   21 +++++++++++++++++++
 arch/arm/mm/proc-arm1022.S        |   21 +++++++++++++++++++
 arch/arm/mm/proc-arm1026.S        |   20 ++++++++++++++++++
 arch/arm/mm/proc-arm920.S         |   18 ++++++++++++++++
 arch/arm/mm/proc-arm922.S         |   18 ++++++++++++++++
 arch/arm/mm/proc-arm925.S         |   23 ++++++++++++++++++++
 arch/arm/mm/proc-arm926.S         |   23 ++++++++++++++++++++
 arch/arm/mm/proc-arm940.S         |   26 +++++++++++++++++++++++
 arch/arm/mm/proc-arm946.S         |   25 ++++++++++++++++++++++
 arch/arm/mm/proc-feroceon.S       |   32 ++++++++++++++++++++++++++++
 arch/arm/mm/proc-macros.S         |    1 +
 arch/arm/mm/proc-mohawk.S         |   19 +++++++++++++++++
 arch/arm/mm/proc-xsc3.S           |   18 ++++++++++++++++
 arch/arm/mm/proc-xscale.S         |   20 ++++++++++++++++++
 drivers/iommu/omap-iommu.c        |   41 +++++++++++++++++-------------------
 25 files changed, 476 insertions(+), 23 deletions(-)


-- 
regards
Ramesh Gupta G
