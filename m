Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab1DVHWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 03:22:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19609 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab1DVHWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 03:22:14 -0400
X-AuditID: cbfee61b-b7c7bae000000eb3-2a-4db12ca43fc2
Date: Fri, 22 Apr 2011 16:22:11 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] pm / core bugfix: report error return from suspend_enter
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Message-id: <1303456931-11657-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 22 Apr 2011 07:22:11.0838 (UTC)
 FILETIME=[FF4431E0:01CC00BD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of suspend-to-RAM returns 0 if there is an
error from suspend_enter() because suspend_devices_and_enter() ignores
the return value from suspend_enter(). This patch addresses this issue
and properly keep the error return from suspend_enter() and let
suspend_devices_and_enter relay the error return.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 kernel/power/suspend.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 2814c32..08515b4 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -224,7 +224,7 @@ int suspend_devices_and_enter(suspend_state_t state)
 	if (suspend_test(TEST_DEVICES))
 		goto Recover_platform;
 
-	suspend_enter(state);
+	error = suspend_enter(state);
 
  Resume_devices:
 	suspend_test_start();
-- 
1.7.1

