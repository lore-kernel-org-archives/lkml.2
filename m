Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab0FPBMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 21:12:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37055 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0FPBMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 21:12:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Venkatesh Pallipadi <venki@google.com>, Len Brown <len.brown@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] acpi: fix unused function warning
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100616100728.382C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 16 Jun 2010 10:12:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len, Is this known issue?


=========================================================
When CONFIG_ACPI_PROCFS=n, processor_idle.c makes following warning.

	drivers/acpi/processor_idle.c:83: warning: 'us_to_pm_timer_ticks'
	defined but not used.

This patch fixes it.

Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/acpi/processor_idle.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0e562d0..3c36769 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -80,10 +80,13 @@ module_param(nocst, uint, 0000);
 static unsigned int latency_factor __read_mostly = 2;
 module_param(latency_factor, uint, 0644);
 
+#ifdef CONFIG_ACPI_PROCFS
 static u64 us_to_pm_timer_ticks(s64 t)
 {
 	return div64_u64(t * PM_TIMER_FREQUENCY, 1000000);
 }
+#endif
+
 /*
  * IBM ThinkPad R40e crashes mysteriously when going into C2 or C3.
  * For now disable this. Probably a bug somewhere else.
-- 
1.6.5.2



