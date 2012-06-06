Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab2FFQDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:03:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40402 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab2FFQDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:03:19 -0400
Date: Wed, 6 Jun 2012 09:03:02 -0700
From: tip-bot for Arun Sharma <asharma@fb.com>
Message-ID: <tip-0b0d9cf6ec7bab91977da2d71c09157f110f7c2e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1334961696-19580-3-git-send-email-asharma@fb.com>
References: <1334961696-19580-3-git-send-email-asharma@fb.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Limit callchains to 127
Git-Commit-ID: 0b0d9cf6ec7bab91977da2d71c09157f110f7c2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:03:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b0d9cf6ec7bab91977da2d71c09157f110f7c2e
Gitweb:     http://git.kernel.org/tip/0b0d9cf6ec7bab91977da2d71c09157f110f7c2e
Author:     Arun Sharma <asharma@fb.com>
AuthorDate: Fri, 20 Apr 2012 15:41:34 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:08:00 +0200

perf: Limit callchains to 127

Stack depth of 255 seems excessive, given that copy_from_user_nmi()
could be slow.

Signed-off-by: Arun Sharma <asharma@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1334961696-19580-3-git-send-email-asharma@fb.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1817d40..45db49f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -555,7 +555,7 @@ enum perf_event_type {
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
-#define PERF_MAX_STACK_DEPTH		255
+#define PERF_MAX_STACK_DEPTH		127
 
 enum perf_callchain_context {
 	PERF_CONTEXT_HV			= (__u64)-32,
