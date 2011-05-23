Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab1EWLMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:12:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:41539 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab1EWLMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:12:39 -0400
Date: Mon, 23 May 2011 11:12:17 GMT
From: tip-bot for Mandeep Singh Baines <msb@chromium.org>
Message-ID: <tip-824c6b7f6294101f30e141117def224a56c203e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, msb@chromium.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, marcin.slusarz@gmail.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, msb@chromium.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        marcin.slusarz@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1306127423-3347-1-git-send-email-msb@chromium.org>
References: <1306127423-3347-1-git-send-email-msb@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] watchdog: Fix rounding bug in get_sample_period()
Git-Commit-ID: 824c6b7f6294101f30e141117def224a56c203e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 May 2011 11:12:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  824c6b7f6294101f30e141117def224a56c203e6
Gitweb:     http://git.kernel.org/tip/824c6b7f6294101f30e141117def224a56c203e6
Author:     Mandeep Singh Baines <msb@chromium.org>
AuthorDate: Sun, 22 May 2011 22:10:20 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 May 2011 11:58:58 +0200

watchdog: Fix rounding bug in get_sample_period()

In get_sample_period(), softlockup_thresh is integer divided by
5 before the multiplication by NSEC_PER_SEC. This results in
softlockup_thresh being rounded down to the nearest integer
multiple of 5.

For example, a softlockup_thresh of 4 rounds down to 0.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1306127423-3347-1-git-send-email-msb@chromium.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
