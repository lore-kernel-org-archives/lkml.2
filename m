Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab2GEFUO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 01:20:14 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:41574 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869Ab2GEFUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 01:20:10 -0400
MIME-Version: 1.0
Date: Thu, 5 Jul 2012 10:50:07 +0530
Message-ID: <CADysL2ZD0yCpCodeuwDpiaiD=uYuDfv4MDXN=YWa-LfY1-8pjA@mail.gmail.com>
Subject: [PATCH v4 0/2] add new cache maintenance api
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 393c4effbbec74ff9b969d53ce4d36fde56b71df Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Wed, 4 Jul 2012 16:43:41 +0530
Subject: [PATCH v4 0/2] add new cache maintenance api

This patch series is the next version to
- add a new cache maintenance api to support non-coherent iommu drivers.
- flush both L1 and L2 caches from OMAP iommu whenever the page table
  memory is updated.

Changes since the previous patch set (v3)
- Minor cleanup for fixing checkpatch warnings.

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
 arch/arm/mm/proc-arm940.S         |   25 +++++++++++++++++++++++++
 arch/arm/mm/proc-arm946.S         |   24 ++++++++++++++++++++++++
 arch/arm/mm/proc-feroceon.S       |   30 ++++++++++++++++++++++++++++++
 arch/arm/mm/proc-macros.S         |    1 +
 arch/arm/mm/proc-mohawk.S         |   18 ++++++++++++++++++
 arch/arm/mm/proc-xsc3.S           |   17 +++++++++++++++++
 arch/arm/mm/proc-xscale.S         |   19 +++++++++++++++++++
 drivers/iommu/omap-iommu.c        |   26 +++++++++-----------------
 25 files changed, 452 insertions(+), 18 deletions(-)


-- 
regards
Ramesh Gupta G
