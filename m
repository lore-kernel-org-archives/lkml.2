Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1HRRZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:25:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25536 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1HRRZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:25:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6441"; a="111290065"
From: David Brown <davidb@codeaurora.org>
To: Randy Dunlap <rdunlap@xenotime.net>, Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-serial@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v3 0/4] Initial DT support for MSM8660
Date: Thu, 18 Aug 2011 10:25:41 -0700
Message-Id: <1313688345-17699-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds initial support for booting the MSM8660 via
devicetree.  The target boots with a serial console, and no platform
data.

In order to test this with a devicetree boot, it is necessary to
include patches allowing the devicetree to be appended to the kernel,
and merge ATAG values into the DT.

Once these patches reach mainline, I intend to remove the non-DT boot
for this target.

History:
  v2 - Consistent name for msm-uart devices.
  v3 - Use separate names for hsuart and lsuart, and common name.
       Clean up io mapping for FPGA registers.

David Brown (4):
  msm_serial: Use relative resources for iomem
  msm_serial: Add devicetree support
  ARM: msm: Add devicetree support for msm8660-surf
  ARM: msm: Describe MSM 8660 SURF FPGA registers in DT

 .../devicetree/bindings/tty/serial/msm_serial.txt  |   22 +++++
 arch/arm/boot/dts/msm8660-surf.dts                 |   29 ++++++
 arch/arm/mach-msm/board-msm8x60.c                  |   98 ++++++++++++++++++--
 drivers/tty/serial/msm_serial.c                    |   30 ++++--
 4 files changed, 162 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/msm_serial.txt
 create mode 100644 arch/arm/boot/dts/msm8660-surf.dts

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

