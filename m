Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab0KTDCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 22:02:42 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63924 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195Ab0KTDCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 22:02:40 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6172"; a="63448325"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 0/3] msm: iommu: Further improvements to the MSM IOMMU driver
Date: Fri, 19 Nov 2010 19:02:31 -0800
Message-Id: <1290222154-11096-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This depends on the clock control driver. Please hold off
on this until the clock driver is in.

Simplify the IOMMU clock control, probe functions, and
initialization, since we no longer have to work around
having a dummy clock driver. As a result, all the IOMMU
devices can now be safely be probed and initialized. Also
add clock control for the IOMMU bus interconnect, which is
only needed for access to IOMMU registers and now can be
disabled for most of the time.

Stepan Moskovchenko (3):
  msm: iommu: Add bus clocks to platform data
  msm: iommu: Clock control for the IOMMU driver
  msm: iommu: Simplify the platform clock code

 arch/arm/mach-msm/devices-msm8x60-iommu.c |    5 -
 arch/arm/mach-msm/include/mach/iommu.h    |   12 +-
 arch/arm/mach-msm/iommu.c                 |   82 ++++++++++--
 arch/arm/mach-msm/iommu_dev.c             |  204 +++++++++++++++++------------
 4 files changed, 196 insertions(+), 107 deletions(-)

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

