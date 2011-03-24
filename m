Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934380Ab1CXXev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:34:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30136 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab1CXXet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:34:49 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6295"; a="81727464"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 0/2] msm: dummy no-op clock support
Date: Thu, 24 Mar 2011 16:34:44 -0700
Message-Id: <1301009686-4042-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.415.g5e839
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for dummy no-op clocks. Some older MSM
targets combined the AHB clock (what we call pclk) with the core clk
and newer targets split the clocks out. Since we don't want to clutter
drivers with ifdefs or add checks for IS_ERR clocks add support for a
dummy clock. This simplifies drivers because they can always assume a
clock is present and error out if it isn't.

On top of this, add dummy clocks for 8960 to ease driver development.

Stephen Boyd (2):
  msm: clock: Support dummy clocks
  msm: 8960: Add dummy clocks for 8960

 arch/arm/mach-msm/Makefile          |    1 +
 arch/arm/mach-msm/board-msm8960.c   |    7 ++
 arch/arm/mach-msm/clock-dummy.c     |   81 ++++++++++++++++++
 arch/arm/mach-msm/clock.h           |   11 +++
 arch/arm/mach-msm/devices-msm8960.c |  160 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/devices.h         |    3 +
 6 files changed, 263 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-dummy.c

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

