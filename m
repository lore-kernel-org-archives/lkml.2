Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab1JJLE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:04:59 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:34744 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752674Ab1JJLE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:04:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd/db8500-prcmu: convert panic() to pr_crit()
Date: Mon, 10 Oct 2011 13:04:44 +0200
Message-ID: <1318244684-3049-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

panic() is too heavy for this, indeed the PRCMU is critical for
the system but not to the point that we should stop everything,
if we can still get a prompt or so.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Add-on patch in response to Sam's review comment on liberal
panic() usage.
---
 drivers/mfd/db8500-prcmu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index e996d11..a25ab9c 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1763,7 +1763,7 @@ retry:
 
 	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
 			msecs_to_jiffies(5000))) {
-		panic("prcmu: %s timed out (5 s) waiting for a reply.\n",
+		pr_crit("prcmu: %s timed out (5 s) waiting for a reply.\n",
 			__func__);
 		goto unlock_and_return;
 	}
@@ -1785,7 +1785,7 @@ retry:
 		if (wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
 				msecs_to_jiffies(5000)))
 			goto retry;
-		panic("prcmu: %s timed out (5 s) waiting for AC_SLEEP_ACK.\n",
+		pr_crit("prcmu: %s timed out (5 s) waiting for AC_SLEEP_ACK.\n",
 			__func__);
 	}
 
@@ -1811,7 +1811,7 @@ void prcmu_ac_sleep_req()
 
 	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
 			msecs_to_jiffies(5000))) {
-		panic("prcmu: %s timed out (5 s) waiting for a reply.\n",
+		pr_crit("prcmu: %s timed out (5 s) waiting for a reply.\n",
 			__func__);
 	}
 
-- 
1.7.3.2

