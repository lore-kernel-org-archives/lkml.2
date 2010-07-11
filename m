Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab0GKQPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 12:15:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55375 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0GKQPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 12:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=sl4ioN6JR1Sbkpej7kkjdK9a++n1IvM/IyikuCegCZL5lhpXSjgugDpNabXvtAl+TW
         wFpBPjsOxdecZhRZjNLQyQl6AQUNeVhC9W4+1TPsDW6mfAOWgZUW26BRSBt73VwIYRyy
         mFG0BYY9HPEkajyUuQehcDfUFgKcikcCwRoXA=
From: Kevin Winchester <kjwinchester@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: Fix warning: 'us_to_pm_timer_ticks' defined but not used
Date: Sun, 11 Jul 2010 13:14:53 -0300
Message-Id: <1278864893-26281-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Len Brown <lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using:

	gcc (GCC) 4.5.0 20100610 (prerelease)

The following warning is seen:

	drivers/acpi/processor_idle.c:83:12: warning: ‘us_to_pm_timer_ticks’ defined but not used

This is because us_to_pm_timer_ticks is only used when
CONFIG_ACPI_PROCFS is defined.

Fix the warning by moving the function definition into the #ifdef
CONFIG_ACPI_PROCFS block.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
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

