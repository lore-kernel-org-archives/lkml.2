Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab1JRMG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:06:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53163 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab1JRMGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:06:54 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, jic23@cam.ac.uk, hemanthv@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv2 3/7] input/cma3000_d0x: Keep configuration on poweroff
Date: Tue, 18 Oct 2011 14:06:32 +0200
Message-Id: <1318939596-27330-4-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the device goes to poweroff keep the spi/i2c configuration.
Otherwhise the device could not wake up if it was in spi mode.

---

v2: Fixes suggested by Jonathan Cameron
    -Code Style

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/input/misc/cma3000_d0x.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
index 3877cbe..e1d27d0 100644
--- a/drivers/input/misc/cma3000_d0x.c
+++ b/drivers/input/misc/cma3000_d0x.c
@@ -44,6 +44,7 @@
 #define CMA3000_RANGE2G    (1 << 7)
 #define CMA3000_RANGE8G    (0 << 7)
 #define CMA3000_BUSI2C     (0 << 4)
+#define CMA3000_BUSSPI     (1 << 4)
 #define CMA3000_MODEMASK   (7 << 1)
 #define CMA3000_GRANGEMASK (1 << 7)
 
@@ -230,8 +231,11 @@ static int cma3000_poweron(struct cma3000_accl_data *data)
 static int cma3000_poweroff(struct cma3000_accl_data *data)
 {
 	int ret;
+	u8 ctrl = CMAMODE_POFF;
 
-	ret = CMA3000_SET(data, CMA3000_CTRL, CMAMODE_POFF, "Mode setting");
+	ctrl |= data->bus_ops->ctrl_mod;
+
+	ret = CMA3000_SET(data, CMA3000_CTRL, ctrl, "Mode setting");
 	msleep(CMA3000_SETDELAY);
 
 	return ret;
-- 
1.7.7

