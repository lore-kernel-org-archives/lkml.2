Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637Ab2JLLbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:31:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55728 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab2JLLbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:31:50 -0400
Date: Fri, 12 Oct 2012 04:31:36 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-4v9ni51gu9c9a6o4hdhv5ecj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/numa] sched/numa: Make CONFIG_SCHED_NUMA configurable
Git-Commit-ID: 80dbd27b0bf14fc4359c59accf02e853826bf7e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 12 Oct 2012 04:31:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80dbd27b0bf14fc4359c59accf02e853826bf7e4
Gitweb:     http://git.kernel.org/tip/80dbd27b0bf14fc4359c59accf02e853826bf7e4
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 10 Oct 2012 19:01:34 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 12 Oct 2012 12:07:20 +0200

sched/numa: Make CONFIG_SCHED_NUMA configurable

Opt in to this new NUMA scheduling feature, because it does not cure cancer.

Requested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-4v9ni51gu9c9a6o4hdhv5ecj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 init/Kconfig |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 140645a..c0cdb9a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -692,8 +692,11 @@ config EMBEDDED_NUMA
 	bool
 
 config SCHED_NUMA
-	def_bool y
+	bool "Memory placement aware NUMA scheduler"
+	default n
 	depends on SMP && NUMA && MIGRATION && !EMBEDDED_NUMA
+	help
+	  This option adds support for automatic NUMA aware memory/task placement.
 
 menuconfig CGROUPS
 	boolean "Control Group support"
