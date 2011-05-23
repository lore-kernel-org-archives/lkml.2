Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1EWFLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:11:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33733 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1EWFLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:11:50 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] watchdog: fix rounding issues in get_sample_period()
Date: Sun, 22 May 2011 22:10:20 -0700
Message-Id: <1306127423-3347-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In get_sample_period(), softlockup_thresh is integer divided by 5 before
the multiplication by NSEC_PER_SEC. This results in softlockup_thresh
being rounded down to the nearest integer multiple of 5.

For example, a softlockup_thresh of 4 rounds down to 0.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/watchdog.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 14733d4..a06972d 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -110,7 +110,7 @@ static unsigned long get_sample_period(void)
 	 * increment before the hardlockup detector generates
 	 * a warning
 	 */
-	return softlockup_thresh / 5 * NSEC_PER_SEC;
+	return softlockup_thresh * (NSEC_PER_SEC / 5);
 }
 
 /* Commands for resetting the watchdog */
-- 
1.7.3.1

