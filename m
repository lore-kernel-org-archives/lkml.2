Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0HBJOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:14:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51532 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab0HBJOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:14:36 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        lm-sensors@lm-sensors.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/2] mfd/mc13783: new function exposing flags
Date: Mon,  2 Aug 2010 11:14:17 +0200
Message-Id: <1280740459-11500-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for the mc13783-adc driver to decide if a touch screen is
connected.  If so some channels are not available as generic hwmon inputs.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mc13783-core.c  |    6 ++++++
 include/linux/mfd/mc13783.h |    2 ++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index ead84e4..a4fa191 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -226,6 +226,12 @@ int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
 }
 EXPORT_SYMBOL(mc13783_reg_rmw);
 
+int mc13783_get_flags(struct mc13783 *mc13783)
+{
+	return mc13783->flags;
+}
+EXPORT_SYMBOL(mc13783_get_flags);
+
 int mc13783_irq_mask(struct mc13783 *mc13783, int irq)
 {
 	int ret;
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index 4a894f6..0fa44fb 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -21,6 +21,8 @@ int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val);
 int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
 		u32 mask, u32 val);
 
+int mc13783_get_flags(struct mc13783 *mc13783);
+
 int mc13783_irq_request(struct mc13783 *mc13783, int irq,
 		irq_handler_t handler, const char *name, void *dev);
 int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
-- 
1.7.1

