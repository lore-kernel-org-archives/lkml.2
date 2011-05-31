Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab1EaXKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 19:10:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30836 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab1EaXKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 19:10:04 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6362"; a="94560411"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCH] msm: timer: Fix SMP build error
Date: Tue, 31 May 2011 16:10:00 -0700
Message-Id: <1306883400-32711-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.3.367.ga9930
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build breakage on SMP=y builds due to 0f7b332 (ARM:
consolidate SMP cross call implementation, 2011-04-03)

arch/arm/mach-msm/timer.c: In function 'local_timer_setup':
arch/arm/mach-msm/timer.c:295: error: implicit declaration of
function 'gic_enable_ppi'

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/timer.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 38b95e9..9bfdd5a 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -23,6 +23,8 @@
 #include <linux/io.h>
 
 #include <asm/mach/time.h>
+#include <asm/hardware/gic.h>
+
 #include <mach/msm_iomap.h>
 #include <mach/cpu.h>
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

