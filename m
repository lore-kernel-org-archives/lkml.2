Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1KRXew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:34:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53347 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab1KRXev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:34:51 -0500
Date: Fri, 18 Nov 2011 15:34:29 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-ed13ec58bfe0d5dc95f748e6118432cb0fa283cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Enable raw event access to Intel offcore events
Git-Commit-ID: ed13ec58bfe0d5dc95f748e6118432cb0fa283cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:34:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed13ec58bfe0d5dc95f748e6118432cb0fa283cb
Gitweb:     http://git.kernel.org/tip/ed13ec58bfe0d5dc95f748e6118432cb0fa283cb
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 14 Nov 2011 10:03:25 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Nov 2011 13:03:44 +0100

perf/x86: Enable raw event access to Intel offcore events

Now that the core offcore support is fixed up (thanks Stephane) and we
have sane generic events utilizing them, re-enable the raw access to
the feature as well.

Note that it doesn't matter if you use event 0x1b7 or 0x1bb to specify
an offcore event, either one works and neither guarantees you'll end
up on a particular offcore MSR.

Based on original patch from: Vince Weaver <vweaver1@eecs.utk.edu>.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>.
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ff0e8d4..2bda212 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -312,12 +312,8 @@ int x86_setup_perfctr(struct perf_event *event)
 			return -EOPNOTSUPP;
 	}
 
-	/*
-	 * Do not allow config1 (extended registers) to propagate,
-	 * there's no sane user-space generalization yet:
-	 */
 	if (attr->type == PERF_TYPE_RAW)
-		return 0;
+		return x86_pmu_extra_regs(event->attr.config, event);
 
 	if (attr->type == PERF_TYPE_HW_CACHE)
 		return set_ext_hw_attr(hwc, event);
