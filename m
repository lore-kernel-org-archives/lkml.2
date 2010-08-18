Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab0HRQ1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:27:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45730 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab0HRQ1b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:27:31 -0400
Date: Wed, 18 Aug 2010 09:25:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, linux-mmc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mmc: build fix: mmc_pm_notify is only available with
 CONFIG_PM=y
Message-Id: <20100818092538.f36a2246.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König  <u.kleine-koenig@pengutronix.de>

This fixes a build breakage introduced by

	4c2ef25 (mmc: fix all hangs related to mmc/sd card insert/removal during suspend/resume)

Cc: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-mmc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Maxim Levitsky <maximlevitsky@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---
 drivers/mmc/core/host.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

There have been 3 patches like this posted, but no one is pushing it
for merging...


diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 0efe631..d80cfdc 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -86,7 +86,9 @@ struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 	init_waitqueue_head(&host->wq);
 	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
 	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
+#ifdef CONFIG_PM
 	host->pm_notify.notifier_call = mmc_pm_notify;
+#endif
 
 	/*
 	 * By default, hosts do not support SGIO or large requests.
-- 
1.7.1

--
