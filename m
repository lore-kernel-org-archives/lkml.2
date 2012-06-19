Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab2FSLmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:42:36 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:48890 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954Ab2FSLmd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:42:33 -0400
MIME-Version: 1.0
Date: Tue, 19 Jun 2012 17:12:29 +0530
Message-ID: <CADysL2apkpGLcSgrTwGqYLM5k8zKH5QYDq25HEz5C7pH6+8tsw@mail.gmail.com>
Subject: [RESEND][PATCH v2 0/4] OMAP:IOMMU:Add L1 and L2 cache flush
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 639d8228c118f884e0d04d33331338bf9561700e Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Fri, 15 Jun 2012 17:06:14 +0530
Subject: [PATCH v2 0/4] OMAP:IOMMU:Add L1 and L2 cache flush

This patch series is second version to
- add a new cache maintenance api to flush L1 cache.
- flush both L1 and L2 caches from iommu whenever the pagetable memory
  is updated.

Added the new api support for ARMv6 and ARMv7
based on the dma functions. The implementation of the
new api is based on the approach[1] discussed some time back.

[1]http://marc.info/?l=linux-kernel&m=131316512713815&w=2

These patches have been validated on Panda Board.

Signed-off-by: Ramesh Gupta G <grgupta@ti.com>

Ramesh Gupta G (4):
  ARM: new cache maintenance api for iommu mem flush
  ARM: add flush_mem api for ARMv6
  ARM: add flush_mem api for ARMv7
  OMAP:IOMMU: flush L1 and L2 caches

 arch/arm/include/asm/cacheflush.h |   17 +++++++++++++++++
 arch/arm/include/asm/glue-cache.h |    1 +
 arch/arm/mm/cache-v6.S            |   28 ++++++++++++++++++++++++++++
 arch/arm/mm/cache-v7.S            |   21 +++++++++++++++++++++
 arch/arm/mm/proc-macros.S         |    1 +
 drivers/iommu/omap-iommu.c        |   26 +++++++++-----------------
 6 files changed, 77 insertions(+), 17 deletions(-)


--
regards
Ramesh Gupta G
