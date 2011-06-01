Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358Ab1FAMwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:52:41 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41018 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1FAMwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:52:40 -0400
From: Borislav Petkov <bp@amd64.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Andrew Worsley <amworsley@gmail.com>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: [PATCH v1.1] init, calibrate: Drop annoying printk
Date: Wed,  1 Jun 2011 14:52:24 +0200
Message-Id: <1306932744-24252-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <20110601062607.GC21247@aftab>
References: <20110601062607.GC21247@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Drop calibrate_delay_direct() KERN_DEBUG printk related to bogomips
calculation as it appears when booting every core on setups with
'ignore_loglevel' which dmesg people scan for possible issues. As the
message doesn't show very useful information to the widest audience of
kernel boot message gazers, it should be removed.

Introduced by d2b463135f84d15808163cd15638b108e323d3e7.

Cc: Andrew Worsley <amworsley@gmail.com>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 init/calibrate.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index cfd7000..2568d22 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -93,9 +93,6 @@ static unsigned long __cpuinit calibrate_delay_direct(void)
 		 * If the upper limit and lower limit of the timer_rate is
 		 * >= 12.5% apart, redo calibration.
 		 */
-		printk(KERN_DEBUG "calibrate_delay_direct() timer_rate_max=%lu "
-			    "timer_rate_min=%lu pre_start=%lu pre_end=%lu\n",
-			  timer_rate_max, timer_rate_min, pre_start, pre_end);
 		if (start >= post_end)
 			printk(KERN_NOTICE "calibrate_delay_direct() ignoring "
 					"timer_rate as we had a TSC wrap around"
-- 
1.7.4.rc2

