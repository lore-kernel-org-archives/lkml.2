Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2IMHJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:09:32 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:44587 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756044Ab2IMHJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:09:30 -0400
MIME-Version: 1.0
Date: Thu, 13 Sep 2012 12:39:29 +0530
Message-ID: <CADysL2Y=aLJ8Eq5aJhB28VhwBvVY+4DyMFpu=MyOg6Sj+D+rYg@mail.gmail.com>
Subject: [PATCH v6 0/2] ARM: New cache API for iommu
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a00cbfadc0053a3c21812593997a1b7338234a9f Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Thu, 13 Sep 2012 11:43:20 +0530
Subject: [PATCH v6  0/2] ARM: New cache API for iommu

This patch series is the next version to
- add a new cache maintenance api to support non-coherent iommu drivers.
- flush both L1 and L2 caches from OMAP iommu whenever the page table
  memory is updated.

Changes since the previous patch set (v5)
- Fixed the RMK's comments on the flush function names in omap-iommu
to reflect the
  purpose.

The implementation of the new api is based on
the approach[1] discussed.

[1]http://marc.info/?l=linux-kernel&m=131316512713815&w=2

Ramesh Gupta G (2):
  ARM: new cache maintenance api for iommu
  OMAP:IOMMU:flush L1 and L2 caches

 arch/arm/include/asm/cacheflush.h |   21 +++++++++++++++++++
 arch/arm/include/asm/glue-cache.h |    1 +
 arch/arm/mm/cache-fa.S            |   16 ++++++++++++++
 arch/arm/mm/cache-v3.S            |   14 ++++++++++++-
 arch/arm/mm/cache-v4.S            |   15 +++++++++++++
 arch/arm/mm/cache-v4wb.S          |   22 ++++++++++++++++++++
 arch/arm/mm/cache-v4wt.S          |   18 ++++++++++++++++
 arch/arm/mm/cache-v6.S            |   21 +++++++++++++++++++
 arch/arm/mm/cache-v7.S            |   22 ++++++++++++++++++++
 arch/arm/mm/proc-arm1020.S        |   23 +++++++++++++++++++++
 arch/arm/mm/proc-arm1020e.S       |   21 +++++++++++++++++++
 arch/arm/mm/proc-arm1022.S        |   21 +++++++++++++++++++
 arch/arm/mm/proc-arm1026.S        |   20 ++++++++++++++++++
 arch/arm/mm/proc-arm920.S         |   18 ++++++++++++++++
 arch/arm/mm/proc-arm922.S         |   18 ++++++++++++++++
 arch/arm/mm/proc-arm925.S         |   23 +++++++++++++++++++++
 arch/arm/mm/proc-arm926.S         |   23 +++++++++++++++++++++
 arch/arm/mm/proc-arm940.S         |   26 ++++++++++++++++++++++++
 arch/arm/mm/proc-arm946.S         |   25 +++++++++++++++++++++++
 arch/arm/mm/proc-feroceon.S       |   32 +++++++++++++++++++++++++++++
 arch/arm/mm/proc-macros.S         |    1 +
 arch/arm/mm/proc-mohawk.S         |   19 +++++++++++++++++
 arch/arm/mm/proc-xsc3.S           |   18 ++++++++++++++++
 arch/arm/mm/proc-xscale.S         |   20 ++++++++++++++++++
 drivers/iommu/omap-iommu.c        |   40 ++++++++++++++++--------------------
 25 files changed, 475 insertions(+), 23 deletions(-)


-- 
regards
Ramesh Gupta G
