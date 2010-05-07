Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab0EGSnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:43:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:46517 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757996Ab0EGSnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:43:42 -0400
Date: Fri, 7 May 2010 18:43:21 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1271190201-25705-7-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-7-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, x86: Use weight instead of cmask in for_each_event_constraint()
Message-ID: <tip-a1f2b70a942b8d858a0ab02567da3999b60a99b2@git.kernel.org>
Git-Commit-ID: a1f2b70a942b8d858a0ab02567da3999b60a99b2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 May 2010 18:43:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1f2b70a942b8d858a0ab02567da3999b60a99b2
Gitweb:     http://git.kernel.org/tip/a1f2b70a942b8d858a0ab02567da3999b60a99b2
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 13 Apr 2010 22:23:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 May 2010 11:31:01 +0200

perf, x86: Use weight instead of cmask in for_each_event_constraint()

There may exist constraints with a cmask set to zero. In this case
for_each_event_constraint() will not work properly. Now weight is used
instead of the cmask for loop exit detection. Weight is always a value
other than zero since the default contains the HWEIGHT from the
counter mask and in other cases a value of zero does not fit too.

This is in preparation of ibs event constraints that wont have a
cmask.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1271190201-25705-7-git-send-email-robert.richter@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4e218d7..4a3f1f2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -170,7 +170,7 @@ struct cpu_hw_events {
 	EVENT_CONSTRAINT(0, 0, 0)
 
 #define for_each_event_constraint(e, c)	\
-	for ((e) = (c); (e)->cmask; (e)++)
+	for ((e) = (c); (e)->weight; (e)++)
 
 union perf_capabilities {
 	struct {
