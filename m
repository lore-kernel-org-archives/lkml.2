Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab1EFAnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:43:37 -0400
Received: from kroah.org ([198.145.64.141]:37185 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab1EFAZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:15 2011
Message-Id: <20110506002215.733039547@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, linux-mmc@vger.kernel.org,
        =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: [107/143] mmc: build fix: mmc_pm_notify is only available with CONFIG_PM=y
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit 81ca03a0e2ea0207b2df80e0edcf4c775c07a505 upstream.

This fixes a build breakage introduced by commit 4c2ef25fe0b8 ("mmc: fix
all hangs related to mmc/sd card insert/removal during suspend/resume")

Cc: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-mmc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Maxim Levitsky <maximlevitsky@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/core/host.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -85,7 +85,9 @@ struct mmc_host *mmc_alloc_host(int extr
 	init_waitqueue_head(&host->wq);
 	INIT_DELAYED_WORK(&host->detect, mmc_rescan);
 	INIT_DELAYED_WORK_DEFERRABLE(&host->disable, mmc_host_deeper_disable);
+#ifdef CONFIG_PM
 	host->pm_notify.notifier_call = mmc_pm_notify;
+#endif
 
 	/*
 	 * By default, hosts do not support SGIO or large requests.


