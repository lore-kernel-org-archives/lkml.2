Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab0EYUsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:48:14 -0400
Received: from mx4.wp.pl ([212.77.101.8]:36617 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab0EYUsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:48:13 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 16:48:12 EDT
Date: Tue, 25 May 2010 23:49:12 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: hrtimer: avoid double seqlock
Message-ID: <20100525214912.GA1934@r2bh72.net.upc.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [4YM0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b9b134b..5c69e99 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -89,7 +89,7 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		xts = current_kernel_time();
+		xts = __current_kernel_time();
 		tom = wall_to_monotonic;
 	} while (read_seqretry(&xtime_lock, seq));
 
