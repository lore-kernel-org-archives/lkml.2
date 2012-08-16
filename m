Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092Ab2HPQki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:40:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:36805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280Ab2HPQkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:40:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,778,1336374000"; 
   d="scan'208";a="202836911"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/4] mei: wd: add option WDIOF_SETTIMEOUT
Date: Thu, 16 Aug 2012 19:39:41 +0300
Message-Id: <1345135184-23915-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1345135184-23915-1-git-send-email-tomas.winkler@intel.com>
References: <1345135184-23915-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According watchdog-kernel-api.txt WDIOF_SETTIMEOUT
should be set if the driver supplies set_timeout function

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/wd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 3006cca..94f2c0a 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -341,7 +341,9 @@ static const struct watchdog_ops wd_ops = {
 };
 static const struct watchdog_info wd_info = {
 		.identity = INTEL_AMT_WATCHDOG_ID,
-		.options = WDIOF_KEEPALIVEPING | WDIOF_ALARMONLY,
+		.options = WDIOF_KEEPALIVEPING |
+			   WDIOF_SETTIMEOUT |
+			   WDIOF_ALARMONLY,
 };
 
 static struct watchdog_device amt_wd_dev = {
-- 
1.7.4.4

