Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2GLM5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:57:24 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:25884 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2GLM5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:57:23 -0400
Message-Id: <201207121255.q6CCtdE6028265@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Thu, 12 Jul 2012 13:53:35 +0100
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, <linux-kernel@vger.kernel.org>
References: <20120711142606.GK3938@opensource.wolfsonmicro.com>
	<201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
	<20120711132655.GG3938@opensource.wolfsonmicro.com>
	<201207111421.q6BELFoF006060@sw-eng-lt-dc-vm2>
	<201207111513.q6BFDR1x016181@sw-eng-lt-dc-vm2>
	<20120711174257.GN3938@opensource.wolfsonmicro.com>
	<201207121052.q6CAq3Ix004450@sw-eng-lt-dc-vm2>
In-Reply-To: <201207121052.q6CAq3Ix004450@sw-eng-lt-dc-vm2>
Subject: [PATCH] regulator: Add REGULATOR_STATUS_UNDEFINED.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

REGULATOR_STATUS_UNDEFINED is to be returned by regulator, if any other state
doesn't really apply.

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/regulator/core.c         |    5 ++++-
 include/linux/regulator/driver.h |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index af44b94..f042a8a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -427,6 +427,9 @@ static ssize_t regulator_status_show(struct device *dev,
 	case REGULATOR_STATUS_STANDBY:
 		label = "standby";
 		break;
+	case REGULATOR_STATUS_UNDEFINED:
+		label = "undefined";
+		break;
 	default:
 		return -ERANGE;
 	}
@@ -2912,7 +2915,7 @@ int regulator_mode_to_status(unsigned int mode)
 	case REGULATOR_MODE_STANDBY:
 		return REGULATOR_STATUS_STANDBY;
 	default:
-		return 0;
+		return REGULATOR_STATUS_UNDEFINED;
 	}
 }
 EXPORT_SYMBOL_GPL(regulator_mode_to_status);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index b0432cc..180ac49 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -32,6 +32,8 @@ enum regulator_status {
 	REGULATOR_STATUS_NORMAL,
 	REGULATOR_STATUS_IDLE,
 	REGULATOR_STATUS_STANDBY,
+	/* in case that any other status doesn't apply */
+	REGULATOR_STATUS_UNDEFINED,
 };
 
 /**
-- 
1.7.0.4

