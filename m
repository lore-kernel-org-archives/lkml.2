Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab2FRJCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:02:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2FRJCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:02:42 -0400
Date: Mon, 18 Jun 2012 02:02:19 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-e227051b13956b8f71c0abecc41ad351e64671c8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154401.GA9633@redhat.com>
References: <20120615154401.GA9633@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes:
  Remove the unnecessary initialization in add_utask()
Git-Commit-ID: e227051b13956b8f71c0abecc41ad351e64671c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 02:02:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e227051b13956b8f71c0abecc41ad351e64671c8
Gitweb:     http://git.kernel.org/tip/e227051b13956b8f71c0abecc41ad351e64671c8
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:44:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:52 +0200

uprobes: Remove the unnecessary initialization in add_utask()

Trivial cleanup. No need to nullify ->active_uprobe after
kzalloc().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120615154401.GA9633@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index d1b2eeb..f935327 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1392,7 +1392,6 @@ static struct uprobe_task *add_utask(void)
 	if (unlikely(!utask))
 		return NULL;
 
-	utask->active_uprobe = NULL;
 	current->utask = utask;
 	return utask;
 }
