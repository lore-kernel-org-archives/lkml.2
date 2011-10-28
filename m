Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1J1Ik6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 04:40:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19902 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1J1Ik5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 04:40:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 28 Oct 2011 01:40:57 -0700
From: vbyravarasu@nvidia.com
To: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com, gregkh@suse.de
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        vbyravarasu@nvidia.com, pdeschrijver@nvidia.com
Subject: [PATCH v2] PM: fix runtime accounting calculation error
Date: Fri, 28 Oct 2011 14:15:02 +0530
Message-Id: <1319791502-17937-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: venu byravarasu <vbyravarasu@nvidia.com>

With delta type being int, its value is made zero
for all values of now > 0x80000000.
Hence fixing it.

Signed-off-by: venu byravarasu <vbyravarasu@nvidia.com>
---
changes since v1:
Removed max_num and its usage references.
..........

 drivers/base/power/runtime.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 1079e03..e8a5172 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -30,13 +30,10 @@ static int rpm_suspend(struct device *dev, int rpmflags);
 void update_pm_runtime_accounting(struct device *dev)
 {
 	unsigned long now = jiffies;
-	int delta;
+	unsigned long delta;
 
 	delta = now - dev->power.accounting_timestamp;
 
-	if (delta < 0)
-		delta = 0;
-
 	dev->power.accounting_timestamp = now;
 
 	if (dev->power.disable_depth > 0)
-- 
1.7.1.1

