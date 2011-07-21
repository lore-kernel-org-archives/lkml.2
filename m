Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1GUTbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:31:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:50338 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab1GUTbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:31:41 -0400
Date: Thu, 21 Jul 2011 19:31:16 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Message-ID: <tip-9985c20f9e4aee6857c08246b273a3695a52b929@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1309421396-17438-4-git-send-email-ming.m.lin@intel.com>
References: <1309421396-17438-4-git-send-email-ming.m.lin@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove perf_event_attr::type check
Git-Commit-ID: 9985c20f9e4aee6857c08246b273a3695a52b929
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 19:31:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9985c20f9e4aee6857c08246b273a3695a52b929
Gitweb:     http://git.kernel.org/tip/9985c20f9e4aee6857c08246b273a3695a52b929
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Thu, 30 Jun 2011 08:09:55 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 20:41:55 +0200

perf: Remove perf_event_attr::type check

PMU type id can be allocated dynamically, so perf_event_attr::type check
when copying attribute from userspace to kernel is not valid.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1309421396-17438-4-git-send-email-ming.m.lin@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0567e32..b8785e2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5926,13 +5926,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (ret)
 		return -EFAULT;
 
-	/*
-	 * If the type exists, the corresponding creation will verify
-	 * the attr->config.
-	 */
-	if (attr->type >= PERF_TYPE_MAX)
-		return -EINVAL;
-
 	if (attr->__reserved_1)
 		return -EINVAL;
 
