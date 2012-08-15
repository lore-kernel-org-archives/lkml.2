Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab2HOUJC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:09:02 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63062 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab2HOTwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 125/165] PM / Suspend: Off by one in pm_suspend()
Date: Wed, 15 Aug 2012 15:47:49 -0400
Message-ID: <1345060109-9187-126-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 528f7ce6e439edeac38f6b3f8561f1be129b5e91 upstream.

In enter_state() we use "state" as an offset for the pm_states[]
array.  The pm_states[] array only has PM_SUSPEND_MAX elements so
this test is off by one.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/power/suspend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 56e7dbb..7d4ae3b 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -297,7 +297,7 @@ int enter_state(suspend_state_t state)
  */
 int pm_suspend(suspend_state_t state)
 {
-	if (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX)
+	if (state > PM_SUSPEND_ON && state < PM_SUSPEND_MAX)
 		return enter_state(state);
 	return -EINVAL;
 }
-- 
1.7.12.rc2

