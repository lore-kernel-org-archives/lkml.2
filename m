Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab1KBRBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:01:04 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36314 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab1KBRBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:01:01 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18IpAbij2ew55iQ9xfpM6lu
Date: Wed, 2 Nov 2011 10:00:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mike Turquette <mturquette@ti.com>, Kevin Hilman <khilman@ti.com>
Subject: PM / OPP: Fix build when CONFIG_PM_OPP is not set
Message-ID: <20111102170055.GI31337@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 03ca370fbf7b76d6d002380dbdc2cdc2319f9c80 (PM / OPP: Add
OPP availability change notifier) does not compile if CONFIG_PM_OPP
is not set:

arch/arm/plat-omap/omap-pm-noop.o: In function `opp_get_notifier':
include/linux/opp.h:103: multiple definition of `opp_get_notifier'
include/linux/opp.h:103: first defined here

Also fix incorrect comment.

Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mike Turquette <mturquette@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---

I'm seeing this with omap1_defconfig at least.

--- a/include/linux/opp.h
+++ b/include/linux/opp.h
@@ -97,11 +97,11 @@ static inline int opp_disable(struct device *dev, unsigned long freq)
 	return 0;
 }
 
-struct srcu_notifier_head *opp_get_notifier(struct device *dev)
+static inline struct srcu_notifier_head *opp_get_notifier(struct device *dev)
 {
 	return ERR_PTR(-EINVAL);
 }
-#endif		/* CONFIG_PM */
+#endif		/* CONFIG_PM_OPP */
 
 #if defined(CONFIG_CPU_FREQ) && defined(CONFIG_PM_OPP)
 int opp_init_cpufreq_table(struct device *dev,
