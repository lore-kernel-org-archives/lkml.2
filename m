Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab0EKQj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:39:58 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:33750 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab0EKQjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:39:54 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] power/ds2760_battery: use factor of 20 for rated_capacity
Date: Tue, 11 May 2010 18:38:46 +0200
Message-Id: <1273595926-26249-3-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the ds2760 driver, the currently used factor of 10 to store the rated
battery capacity internally is not sufficient for batteries > 2.55 Ah,
as the 8-bit register will overflow for bigger values.

Change the factor to 20 to broaden that range. Note that due to
RATED_CAPACITY_FACTOR, the external interface won't change, neither for
the writeable sysfs entires nor for the kernel rated_capacity module
parameter.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/ds2760_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index b82bf92..7b3043f 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -78,7 +78,7 @@ MODULE_PARM_DESC(current_accum, "current accumulator value");
 
 /* Some batteries have their rated capacity stored a N * 10 mAh, while
  * others use an index into this table. */
-#define RATED_CAPACITY_FACTOR 10
+#define RATED_CAPACITY_FACTOR 20
 static int rated_capacities[] = {
 	0,
 	920,	/* Samsung */
-- 
1.7.1

