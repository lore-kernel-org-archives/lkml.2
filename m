Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab2BINmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:42:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59941 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754255Ab2BINmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:42:12 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Don't add the function name to pr_fmt
Date: Thu,  9 Feb 2012 13:42:05 +0000
Message-Id: <1328794926-4892-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam pointed out via IM that since we now use the pure function name for
all regulator logging a lot of the messages such as those logging the
constraints are getting a bit noisy due to the implementation detail
that is the function name:

print_constraints: VDDARM: 1000 <--> 1300 mV at 1300 mV at 0 mA

In discussion it seemed like the best thing was to just drop the pr_fmt
and clarify individual log messages where there is an issue otherwise
we get into silly things like renaming the functions to suit the logging.

This is mostly an issue as we have a moderate amount of non-error logging
in the boot sequence to aid debug if something goes wrong since regulator
misconfiguration can kill the system pretty quickly.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 8057451..68acc2f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -13,8 +13,6 @@
  *
  */
 
-#define pr_fmt(fmt) "%s: " fmt, __func__
-
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/debugfs.h>
-- 
1.7.9.rc1

