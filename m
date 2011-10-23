Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab1JWQeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 12:34:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:35258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab1JWQeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 12:34:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="66236056"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tomas.winkler@intel.com, Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH] staging:mei: wd_ops and wd_info should be static
Date: Sun, 23 Oct 2011 18:30:39 +0200
Message-Id: <1319387439-5389-1-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

wd_ops and wd_info structures are local to wd.c so mark them static

Cc: Oren Weil <oren.jer.weil@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/staging/mei/wd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index ffca7ca..cb3f92d 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -331,14 +331,14 @@ static int mei_wd_ops_set_timeout(struct watchdog_device *wd_dev, unsigned int t
 /*
  * Watchdog Device structs
  */
-const struct watchdog_ops wd_ops = {
+static const struct watchdog_ops wd_ops = {
 		.owner = THIS_MODULE,
 		.start = mei_wd_ops_start,
 		.stop = mei_wd_ops_stop,
 		.ping = mei_wd_ops_ping,
 		.set_timeout = mei_wd_ops_set_timeout,
 };
-const struct watchdog_info wd_info = {
+static const struct watchdog_info wd_info = {
 		.identity = INTEL_AMT_WATCHDOG_ID,
 		.options = WDIOF_KEEPALIVEPING,
 };
-- 
1.7.5.4

