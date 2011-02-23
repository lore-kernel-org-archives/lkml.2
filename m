Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1BWMFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:05:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:56433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab1BWMFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:05:41 -0500
Date: Wed, 23 Feb 2011 12:05:18 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, yong.zhang0@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <1298185696-4403-2-git-send-email-yong.zhang0@gmail.com>
References: <1298185696-4403-2-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, autogroup, sysctl: Use proc_dointvec_minmax() instead
Message-ID: <tip-1747b21fecbfb63fbf6b9624e8b92707960d5a97@git.kernel.org>
Git-Commit-ID: 1747b21fecbfb63fbf6b9624e8b92707960d5a97
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:05:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1747b21fecbfb63fbf6b9624e8b92707960d5a97
Gitweb:     http://git.kernel.org/tip/1747b21fecbfb63fbf6b9624e8b92707960d5a97
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Sun, 20 Feb 2011 15:08:12 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:33:58 +0100

sched, autogroup, sysctl: Use proc_dointvec_minmax() instead

sched_autogroup_enabled has min/max value, proc_dointvec_minmax() is
be used for this case.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1298185696-4403-2-git-send-email-yong.zhang0@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index cb7c830..7b5eead 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -367,7 +367,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_autogroup_enabled,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
