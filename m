Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2LDKLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:11:35 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45905 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab2LDKLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:11:31 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: John Stultz <johnstul@us.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 2/2] cpufreq: db8500: set CPUFREQ_CONST_LOOPS
Date: Tue,  4 Dec 2012 11:10:45 +0100
Message-Id: <1354615845-2758-3-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1354615845-2758-1-git-send-email-fabio.baltieri@linaro.org>
References: <1354615845-2758-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As ux500 is being converted to timer based delay loops, and the timer
used is not depending on CPUs clock frequency, set cpufreq_driver flag
CPUFREQ_CONST_LOOPS to prevent cpufreq rescaling loops_for_jiffies.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/cpufreq/db8500-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
index 74b830b..e758891 100644
--- a/drivers/cpufreq/db8500-cpufreq.c
+++ b/drivers/cpufreq/db8500-cpufreq.c
@@ -150,7 +150,7 @@ static int __cpuinit db8500_cpufreq_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver db8500_cpufreq_driver = {
-	.flags  = CPUFREQ_STICKY,
+	.flags  = CPUFREQ_STICKY | CPUFREQ_CONST_LOOPS,
 	.verify = db8500_cpufreq_verify_speed,
 	.target = db8500_cpufreq_target,
 	.get    = db8500_cpufreq_getspeed,
-- 
1.7.12.1

