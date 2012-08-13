Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2HMRKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:10:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33750 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2HMRKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:10:50 -0400
Date: Mon, 13 Aug 2012 10:10:32 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-cffa59baa5f1cf3e3e9e172697db48912471531c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, zheng.z.yan@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
In-Reply-To: <1339741902-8449-8-git-send-email-zheng.z.yan@intel.com>
References: <1339741902-8449-8-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86:
  Fix uncore_types_exit section mismatch
Git-Commit-ID: cffa59baa5f1cf3e3e9e172697db48912471531c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 10:10:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cffa59baa5f1cf3e3e9e172697db48912471531c
Gitweb:     http://git.kernel.org/tip/cffa59baa5f1cf3e3e9e172697db48912471531c
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 2 Aug 2012 12:55:27 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 19:01:03 +0200

perf, x86: Fix uncore_types_exit section mismatch

Fix the following section mismatch:

WARNING: arch/x86/kernel/cpu/built-in.o(.text+0x7ad9): Section mismatch in reference from the function uncore_types_exit() to the function .init.text:uncore_type_exit()

The function uncore_types_exit() references the function __init
uncore_type_exit().  This is often because uncore_types_exit lacks a
__init annotation or the annotation of uncore_type_exit is wrong.

caused by 14371cce03c2 ("perf: Add generic PCI uncore PMU device
support").

Cc: Zheng Yan <zheng.z.yan@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1339741902-8449-8-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 7563fda..a7ccd68 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2373,7 +2373,7 @@ static void __init uncore_type_exit(struct intel_uncore_type *type)
 	type->attr_groups[1] = NULL;
 }
 
-static void uncore_types_exit(struct intel_uncore_type **types)
+static void __init uncore_types_exit(struct intel_uncore_type **types)
 {
 	int i;
 	for (i = 0; types[i]; i++)
