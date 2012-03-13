Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030262Ab2CMAem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:34:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:48744 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965096Ab2CMAYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        David Brownell <david-b@pacbell.net>,
        Alan Stern <stern@rowland.harvard.edu>, linux-mmc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 147/196] mmc: build fix: mmc_pm_notify is only available with CONFIG_PM=y
Date: Mon, 12 Mar 2012 20:21:00 -0400
Message-Id: <1331598109-31424-102-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mmc/core/host.c |    2 ++
 1 file changed, 2 insertions(+)

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
1.7.9.3

