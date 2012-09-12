Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2ILVQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:16:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36388 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab2ILVQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:16:00 -0400
From: Vaibhav Hiremath <hvaibhav@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <paul@pwsan.com>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 0/2] ARM: AM33XX: hwmod: Minor fixes for v3.7
Date: Thu, 13 Sep 2012 02:45:49 +0530
Message-ID: <1347484551-11775-1-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today Paul had given pull request for AM33XX hwmod data and related
patches, and I wanted to make sure that things are working fine
irrespective of merge window changes coming in. I without adding any
further delay I tried the pull request on linux-next/master (-rc6)
linux-omap/master (-rc4 + omap merges) and found that hwmod needs
minor changes required for both, build and to boot.

[1/2]: With recent mainline changes on gpio and mcspi drivers,
       platform specific header files (plat/gpio.h and plat/mcspi.h)
       have been removed, which results into build failure.
       Observed on linux-next/master checkout.

[2/2]: With recent migration of omap architectures to SPARSE_IRQ
       framework, it is important to add OMAP_INTC_START to all interrupt
       numbers which will be eventually requested by drivers.
       Observed on linux-omap/master checkout.

Both the patches have been varified for,
     - Build Test (omap2plus_defconfig)
     - Boot tested on Bone
     - Sparse check pass

Paul,
Request to review these patches and give another pull request for this.

Vaibhav Hiremath (2):
  ARM: AM33XX: hwmod: Remove platform specific header files
  ARM: AM33XX: hwmod: Add OMAP_INTC_START offset to all module int nos

 arch/arm/mach-omap2/omap_hwmod_33xx_data.c |  174 ++++++++++++++--------------
 1 files changed, 88 insertions(+), 86 deletions(-)

