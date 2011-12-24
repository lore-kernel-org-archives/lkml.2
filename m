Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1LXHdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 02:33:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56425 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab1LXHck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 02:32:40 -0500
Date: Fri, 23 Dec 2011 23:32:15 -0800
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-2e64694de21a812d637dcbea4471ad1f7897b049@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, robert.richter@amd.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1324646665-13334-1-git-send-email-robert.richter@amd.com>
References: <1324646665-13334-1-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Fix raw_spin_unlock_irqrestore() usage
Git-Commit-ID: 2e64694de21a812d637dcbea4471ad1f7897b049
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Dec 2011 23:32:21 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e64694de21a812d637dcbea4471ad1f7897b049
Gitweb:     http://git.kernel.org/tip/2e64694de21a812d637dcbea4471ad1f7897b049
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Fri, 23 Dec 2011 14:24:25 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 23 Dec 2011 17:57:01 +0100

perf/x86: Fix raw_spin_unlock_irqrestore() usage

Use raw_spin_unlock_irqrestore() as equivalent to
raw_spin_lock_irqsave().

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1324646665-13334-1-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 8d601b1..121f1be 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1169,7 +1169,7 @@ again:
 		 */
 		c = &unconstrained;
 	} else if (intel_try_alt_er(event, orig_idx)) {
-		raw_spin_unlock(&era->lock);
+		raw_spin_unlock_irqrestore(&era->lock, flags);
 		goto again;
 	}
 	raw_spin_unlock_irqrestore(&era->lock, flags);
