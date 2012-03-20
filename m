Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab2CTWBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 18:01:13 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:47755 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758439Ab2CTWBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 18:01:11 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2012 18:01:10 EDT
From: Graeme Gregory <gg@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH] REGULATOR: core add 3 new modes/statuses
Date: Tue, 20 Mar 2012 21:50:58 +0000
Message-Id: <1332280258-5044-2-git-send-email-gg@slimlogic.co.uk>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332280258-5044-1-git-send-email-gg@slimlogic.co.uk>
References: <1332280258-5044-1-git-send-email-gg@slimlogic.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds three new modes to the regulator core these are present
in many TI PMICs and I expect ones by other manufecturers.

USBBOOST this effectively turns the regulator around instead of using
the USB 5v and converting this down to power USB hardware the regulator
instead takes the internal voltage and boosts it to 5v for USB. Most
commonly used when a device goes into OTG host mode.

BYPASS the input voltage on the regulator is transferred directly to the
output.

TRACKING the regulator tracks another resource and produces the same
voltage. This is commonly used where an switching power supply produces
a voltage but a quality smoothed version of the same voltage produced
by an LDO is required as well.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/regulator/core.c           |   15 +++++++++++++++
 include/linux/regulator/consumer.h |    3 +++
 include/linux/regulator/driver.h   |    3 +++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c056abd..a4e5da4 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -414,6 +414,15 @@ static ssize_t regulator_status_show(struct device *dev,
 	case REGULATOR_STATUS_STANDBY:
 		label = "standby";
 		break;
+	case REGULATOR_STATUS_USBBOOST:
+		label = "usbboost";
+		break;
+	case REGULATOR_STATUS_BYPASS:
+		label = "bypass";
+		break;
+	case REGULATOR_STATUS_TRACKING:
+		label = "tracking";
+		break;
 	default:
 		return -ERANGE;
 	}
@@ -2680,6 +2689,12 @@ int regulator_mode_to_status(unsigned int mode)
 		return REGULATOR_STATUS_IDLE;
 	case REGULATOR_STATUS_STANDBY:
 		return REGULATOR_STATUS_STANDBY;
+	case REGULATOR_MODE_USBBOOST:
+		return REGULATOR_STATUS_USBBOOST;
+	case REGULATOR_MODE_BYPASS:
+		return REGULATOR_STATUS_BYPASS;
+	case REGULATOR_MODE_TRACKING:
+		return REGULATOR_STATUS_TRACKING;
 	default:
 		return 0;
 	}
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 4ed1b30..6d5c6ed 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -81,6 +81,9 @@ struct notifier_block;
 #define REGULATOR_MODE_NORMAL			0x2
 #define REGULATOR_MODE_IDLE			0x4
 #define REGULATOR_MODE_STANDBY			0x8
+#define REGULATOR_MODE_USBBOOST			0x10
+#define REGULATOR_MODE_BYPASS			0x20
+#define REGULATOR_MODE_TRACKING			0x40
 
 /*
  * Regulator notifier events.
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index fa8b55b..594f0fe 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -31,6 +31,9 @@ enum regulator_status {
 	REGULATOR_STATUS_NORMAL,
 	REGULATOR_STATUS_IDLE,
 	REGULATOR_STATUS_STANDBY,
+	REGULATOR_STATUS_USBBOOST,
+	REGULATOR_STATUS_BYPASS,
+	REGULATOR_STATUS_TRACKING,
 };
 
 /**
-- 
1.7.5.4

