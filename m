Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030515Ab2B1WeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:34:25 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46881 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030241Ab2B1WeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:34:22 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/5] watchdog: use dev_ functions
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Feb 2012 22:48:37 +0000
Message-ID: <20120228224835.8961.25351.stgit@bob.linux.org.uk>
In-Reply-To: <20120228224710.8961.46003.stgit@bob.linux.org.uk>
References: <20120228224710.8961.46003.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

While they are registered all our watchdogs now have a valid device object
so we can in turn use that to report problems nicely.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/watchdog/watchdog_dev.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 7edab6d..b38361e 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -110,8 +110,7 @@ static int watchdog_stop(struct watchdog_device *wddev)
 	int err = -EBUSY;
 
 	if (test_bit(WDOG_NO_WAY_OUT, &wddev->status)) {
-		pr_info("%s: nowayout prevents watchdog to be stopped!\n",
-							wddev->info->identity);
+		dev_info(wddev->dev, "nowayout prevents watchdog being stopped!\n");
 		return err;
 	}
 
@@ -353,7 +352,7 @@ static int watchdog_release(struct inode *inode, struct file *file)
 
 	/* If the watchdog was not stopped, send a keepalive ping */
 	if (err < 0) {
-		pr_crit("%s: watchdog did not stop!\n", wdd->info->identity);
+		dev_crit(wdd->dev, "watchdog did not stop!\n");
 		watchdog_ping(wdd);
 	}
 

