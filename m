Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab2GZPRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:17:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38181 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2GZPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:17:31 -0400
Date: Thu, 26 Jul 2012 08:17:17 -0700
From: tip-bot for Jovi Zhang <bookjovi@gmail.com>
Message-ID: <tip-35d56ca9d401d9d0ac8d91e4db1485af5f38f6fd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        trivial@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        bookjovi@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        bookjovi@gmail.com
In-Reply-To: <CACV3sbKF=CX+2jWEWesfCA6rBoQ3wDM4-5ac9MuBtVbCtMRHdQ@mail.gmail.com>
References: <CACV3sbKF=CX+2jWEWesfCA6rBoQ3wDM4-5ac9MuBtVbCtMRHdQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix missing struct before structure name
Git-Commit-ID: 35d56ca9d401d9d0ac8d91e4db1485af5f38f6fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:17:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35d56ca9d401d9d0ac8d91e4db1485af5f38f6fd
Gitweb:     http://git.kernel.org/tip/35d56ca9d401d9d0ac8d91e4db1485af5f38f6fd
Author:     Jovi Zhang <bookjovi@gmail.com>
AuthorDate: Tue, 17 Jul 2012 10:14:41 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 15:04:34 +0200

perf/x86: Fix missing struct before structure name

When CONFIG_PERF_EVENTS disabled, there will have a compiliation
error, because missing struct before structure name.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Kosina <trivial@kernel.org>
Link: http://lkml.kernel.org/r/CACV3sbKF%3DCX%2B2jWEWesfCA6rBoQ3wDM4-5ac9MuBtVbCtMRHdQ@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index c78f14a..dab3935 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -234,7 +234,7 @@ extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
 extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
 extern void perf_check_microcode(void);
 #else
-static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
+static inline struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
 	*nr = 0;
 	return NULL;
