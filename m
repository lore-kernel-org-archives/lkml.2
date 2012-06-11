Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2FKJSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:18:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:14189 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab2FKJSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:18:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="178292052"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH for v3.5 2/2] misc: mei: set WDIOF_ALARMONLY on mei watchdog
Date: Mon, 11 Jun 2012 12:18:31 +0300
Message-Id: <1339406311-27283-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1339406311-27283-1-git-send-email-tomas.winkler@intel.com>
References: <1339406311-27283-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei watchdog doesn't reboot the system it only produces event
therefore mark it as WDIOF_ALARMONLY.

This patch depends on:
commit 2bbeed016dd96045ec82c3a309afddcc3a0db1d2
Author: Alan Cox <alan@linux.intel.com>
watchdog: Add a flag to indicate the watchdog doesn't reboot things

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/wd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 6be5605..e2ec050 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -341,7 +341,7 @@ static const struct watchdog_ops wd_ops = {
 };
 static const struct watchdog_info wd_info = {
 		.identity = INTEL_AMT_WATCHDOG_ID,
-		.options = WDIOF_KEEPALIVEPING,
+		.options = WDIOF_KEEPALIVEPING | WDIOF_ALARMONLY,
 };
 
 static struct watchdog_device amt_wd_dev = {
-- 
1.7.4.4

