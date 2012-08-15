Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab2HOTyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:54:33 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63191 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab2HOTxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:53:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: John Stultz <john.stultz@linaro.org>, <stable@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 111/165] timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond
Date: Wed, 15 Aug 2012 15:47:35 -0400
Message-ID: <1345060109-9187-112-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fad0c66c4bb836d57a5f125ecd38bed653ca863a upstream.
which resolves a bug the previous commit.

Commit 6b43ae8a61 (ntp: Fix leap-second hrtimer livelock) broke the
leapsecond update of CLOCK_MONOTONIC. The missing leapsecond update to
wall_to_monotonic causes discontinuities in CLOCK_MONOTONIC.

Adjust wall_to_monotonic when NTP inserted a leapsecond.

Reported-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Tested-by: Richard Cochran <richardcochran@gmail.com>
Cc: stable@kernel.org
Link: http://lkml.kernel.org/r/1338400497-12420-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/time/timekeeping.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index df1e939..f8d4877 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -759,6 +759,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
 		xtime.tv_sec++;
 		leap = second_overflow(xtime.tv_sec);
 		xtime.tv_sec += leap;
+		wall_to_monotonic.tv_sec -= leap;
 	}
 
 	/* Accumulate into raw time */
-- 
1.7.12.rc2

