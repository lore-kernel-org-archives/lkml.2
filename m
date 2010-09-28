Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760499Ab0I1BZ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 21:25:59 -0400
Received: from imr4.ericy.com ([198.24.6.8]:32930 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab0I1BZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 21:25:56 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Fenghua Yu <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH v3] hwmon (coretemp): Fix build breakage if SMP is undefined
Date: Mon, 27 Sep 2010 18:32:32 -0700
Message-ID: <1285637552-1058-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e40cc4bdfd4b89813f072f72bd9c7055814d3f0f introduced
a build breakage if CONFIG_SMP is undefined. This commit
fixes the problem.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
v2: Fix compile warning due to unused variable i if SMP is undefined
v3: include asm/smp.h instead of using ifdef CONFIG_SMP

 drivers/hwmon/coretemp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index baa842a..a23b17a 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -36,6 +36,7 @@
 #include <linux/pci.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
+#include <asm/smp.h>
 
 #define DRVNAME	"coretemp"
 
-- 
1.7.0.87.g0901d

