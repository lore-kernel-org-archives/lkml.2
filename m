Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2BFSrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:47:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48540 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425Ab2BFSrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:47:41 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: We don't need to runtime resume by default
Date: Mon,  6 Feb 2012 18:47:37 +0000
Message-Id: <1328554057-10380-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the default state that the runtime PM infrastructure expects so
instead just kick the runtime PM core to suspend us if we're not doing
anything (as is default).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index e294717..b2de65b 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -636,7 +636,7 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 	}
 
 	pm_runtime_enable(wm8994->dev);
-	pm_runtime_resume(wm8994->dev);
+	pm_runtime_idle(wm8994->dev);
 
 	return 0;
 
-- 
1.7.9.rc1

