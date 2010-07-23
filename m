Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999Ab0GWP7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:59:54 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53866 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab0GWP7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:59:51 -0400
From: florian@mickler.org
To: linux-acpi@vger.kernel.org
Cc: Florian Mickler <florian@mickler.org>, Len Brown <lenb@kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fix warning: us_to_pm_timer_ticks defined but not used
Date: Fri, 23 Jul 2010 17:59:02 +0200
Message-Id: <1279900743-4733-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move it under the same ifdef as its sole caller is.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/acpi/processor_idle.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index b1b3856..8525070 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -80,10 +80,6 @@ module_param(nocst, uint, 0000);
 static unsigned int latency_factor __read_mostly = 2;
 module_param(latency_factor, uint, 0644);
 
-static u64 us_to_pm_timer_ticks(s64 t)
-{
-	return div64_u64(t * PM_TIMER_FREQUENCY, 1000000);
-}
 /*
  * IBM ThinkPad R40e crashes mysteriously when going into C2 or C3.
  * For now disable this. Probably a bug somewhere else.
@@ -685,6 +681,12 @@ static int acpi_processor_get_power_info(struct acpi_processor *pr)
 }
 
 #ifdef CONFIG_ACPI_PROCFS
+
+static u64 us_to_pm_timer_ticks(s64 t)
+{
+	return div64_u64(t * PM_TIMER_FREQUENCY, 1000000);
+}
+
 static int acpi_processor_power_seq_show(struct seq_file *seq, void *offset)
 {
 	struct acpi_processor *pr = seq->private;
-- 
1.7.1.1

