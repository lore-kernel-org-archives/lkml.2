Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab1GAPQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:16:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:33074 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab1GAPQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:16:21 -0400
Date: Fri, 1 Jul 2011 15:15:56 GMT
From: tip-bot for Vince Weaver <vweaver1@eecs.utk.edu>
Message-ID: <tip-04bffb83d17c1b93578564f18e02b6cb1c385b40@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        vweaver1@eecs.utk.edu, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        vweaver1@eecs.utk.edu, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1106101606000.14542@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1106101606000.14542@cl320.eecs.utk.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_event: Return -EINVAL for Offcore Response Events
Git-Commit-ID: 04bffb83d17c1b93578564f18e02b6cb1c385b40
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:15:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  04bffb83d17c1b93578564f18e02b6cb1c385b40
Gitweb:     http://git.kernel.org/tip/04bffb83d17c1b93578564f18e02b6cb1c385b40
Author:     Vince Weaver <vweaver1@eecs.utk.edu>
AuthorDate: Fri, 10 Jun 2011 16:07:52 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 10:27:09 +0200

perf_event: Return -EINVAL for Offcore Response Events

Return a proper error code when denying raw access to Offcore Response
events. Right now we return "0" which gives tools the false impression
that opening the event worked.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1106101606000.14542@cl320.eecs.utk.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3a0338b..c6bfa6b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -598,7 +598,7 @@ static int x86_setup_perfctr(struct perf_event *event)
 	 * there's no sane user-space generalization yet:
 	 */
 	if (attr->type == PERF_TYPE_RAW)
-		return 0;
+		return -EINVAL;
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, event);
