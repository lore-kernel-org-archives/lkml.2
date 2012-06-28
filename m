Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab2F1Jb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:31:57 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:42206 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932562Ab2F1Jb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:31:56 -0400
MIME-Version: 1.0
Date: Thu, 28 Jun 2012 15:01:53 +0530
Message-ID: <CADysL2b9bTqAZ6f48nGThosYn5mTGiSNFgKLyLROVk4XeDZDCg@mail.gmail.com>
Subject: [PATCH v3 0/2] OMAP:IOMMU:flush L1 and L2 caches
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a5dc6e2ebee40b4f6cf51c1ec3c67476ffb8efc3 Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Thu, 28 Jun 2012 11:53:54 +0530
Subject: [PATCH v3 0/2] OMAP:IOMMU:flush L1 and L2 caches

This patch series is the next version to
- add a new cache maintenance api to support non-coherent iommu drivers.
- flush both L1 and L2 caches from OMAP iommu whenever the page table
  memory is updated.

Changes since the previous patch set
- Renamed the new api to reflect the purpose.
- Fixed the kernel compilation issues by adding the
  new api support for all the ARM versions.
- Validated the changes on the Pandaboard.
- Compile tested the kernel for all other ARM configurations.

The implementation of the new api is based on
the approach[1] discussed.

[1]http://marc.info/?l=linux-kernel&m=131316512713815&w=2

Signed-off-by: Ramesh Gupta G <grgupta@ti.com>

Ramesh Gupta G (2):
  ARM: new cache maintenance api for iommu
  OMAP:IOMMU:flush L1 and L2 caches

 arch/arm/include/asm/cacheflush.h |   26 ++++++++++++++++++++++++++
 arch/arm/include/asm/glue-cache.h |    1 +
 arch/arm/mm/cache-fa.S            |   15 +++++++++++++++
 arch/arm/mm/cache-v3.S            |   14 +++++++++++++-
 arch/arm/mm/cache-v4.S            |   15 +++++++++++++++
 arch/arm/mm/cache-v4wb.S          |   21 +++++++++++++++++++++
 arch/arm/mm/cache-v4wt.S          |   17 +++++++++++++++++
 arch/arm/mm/cache-v6.S            |   20 ++++++++++++++++++++
 arch/arm/mm/cache-v7.S            |   21 +++++++++++++++++++++
 arch/arm/mm/proc-arm1020.S        |   22 ++++++++++++++++++++++
 arch/arm/mm/proc-arm1020e.S       |   20 ++++++++++++++++++++
 arch/arm/mm/proc-arm1022.S        |   20 ++++++++++++++++++++
 arch/arm/mm/proc-arm1026.S        |   20 ++++++++++++++++++++
 arch/arm/mm/proc-arm920.S         |   17 +++++++++++++++++
 arch/arm/mm/proc-arm922.S         |   17 +++++++++++++++++
 arch/arm/mm/proc-arm925.S         |   22 ++++++++++++++++++++++
 arch/arm/mm/proc-arm926.S         |   22 ++++++++++++++++++++++
 arch/arm/mm/proc-arm940.S         |   26 ++++++++++++++++++++++++++
 arch/arm/mm/proc-arm946.S         |   24 ++++++++++++++++++++++++
 arch/arm/mm/proc-feroceon.S       |   30 ++++++++++++++++++++++++++++++
 arch/arm/mm/proc-macros.S         |    1 +
 arch/arm/mm/proc-mohawk.S         |   18 ++++++++++++++++++
 arch/arm/mm/proc-xsc3.S           |   17 +++++++++++++++++
 arch/arm/mm/proc-xscale.S         |   19 +++++++++++++++++++
 drivers/iommu/omap-iommu.c        |   26 +++++++++-----------------
 25 files changed, 453 insertions(+), 18 deletions(-)


-- 
regards
Ramesh Gupta G
