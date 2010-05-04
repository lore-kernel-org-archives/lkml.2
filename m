Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0EDIbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 04:31:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:43816 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab0EDIbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 04:31:20 -0400
Date: Tue, 4 May 2010 08:30:30 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, jason.wessel@windriver.com, will.deacon@arm.com,
       mahesh@linux.vnet.ibm.com, lethal@linux-sh.org, fweisbec@gmail.com,
       benh@kernel.crashing.org, tglx@linutronix.de, mingo@elte.hu,
       prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, will.deacon@arm.com,
       jason.wessel@windriver.com, mahesh@linux.vnet.ibm.com,
       lethal@linux-sh.org, fweisbec@gmail.com, benh@kernel.crashing.org,
       tglx@linutronix.de, prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20100503133942.GA5497@nowhere>
References: <20100503133942.GA5497@nowhere>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw_breakpoints: Fix percpu build failure
Message-ID: <tip-777d0411cd1e384115985dac5ccd42031e3eee2b@git.kernel.org>
Git-Commit-ID: 777d0411cd1e384115985dac5ccd42031e3eee2b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 08:30:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  777d0411cd1e384115985dac5ccd42031e3eee2b
Gitweb:     http://git.kernel.org/tip/777d0411cd1e384115985dac5ccd42031e3eee2b
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Mon, 3 May 2010 15:39:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 4 May 2010 08:39:36 +0200

hw_breakpoints: Fix percpu build failure

Fix this build error:

   kernel/hw_breakpoint.c:58:1: error: pasting "__pcpu_scope_" and "*" does not give a valid preprocessing token

It happens if CONFIG_DEBUG_FORCE_WEAK_PER_CPU, because we concatenate
someting with the name and we have the "*" in the name.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: K. Prasad <prasad@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
LKML-Reference: <20100503133942.GA5497@nowhere>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/hw_breakpoint.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 684b710..7a56b22 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -55,7 +55,7 @@
 static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned[TYPE_MAX]);
 
 /* Number of pinned task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, *nr_task_bp_pinned[TYPE_MAX]);
+static DEFINE_PER_CPU(unsigned int *, nr_task_bp_pinned[TYPE_MAX]);
 
 /* Number of non-pinned cpu/task breakpoints in a cpu */
 static DEFINE_PER_CPU(unsigned int, nr_bp_flexible[TYPE_MAX]);
