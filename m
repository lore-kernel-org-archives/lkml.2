Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1AGPgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:36:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:40808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab1AGPgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:36:22 -0500
Date: Fri, 7 Jan 2011 15:36:05 GMT
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, yong.zhang0@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        yong.zhang0@gmail.com, mingo@elte.hu
In-Reply-To: <1294375425-31065-1-git-send-email-yong.zhang0@gmail.com>
References: <1294375425-31065-1-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Mark autogroup_init() __init
Message-ID: <tip-0ca0873555c0abe17b28c25b19f82857c0ddd2bc@git.kernel.org>
Git-Commit-ID: 0ca0873555c0abe17b28c25b19f82857c0ddd2bc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:36:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ca0873555c0abe17b28c25b19f82857c0ddd2bc
Gitweb:     http://git.kernel.org/tip/0ca0873555c0abe17b28c25b19f82857c0ddd2bc
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Fri, 7 Jan 2011 12:43:45 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 15:54:36 +0100

sched: Mark autogroup_init() __init

autogroup_init() is only called at boot time.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1294375425-31065-1-git-send-email-yong.zhang0@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_autogroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
index e011e53..32a723b 100644
--- a/kernel/sched_autogroup.c
+++ b/kernel/sched_autogroup.c
@@ -9,7 +9,7 @@ unsigned int __read_mostly sysctl_sched_autogroup_enabled = 1;
 static struct autogroup autogroup_default;
 static atomic_t autogroup_seq_nr;
 
-static void autogroup_init(struct task_struct *init_task)
+static void __init autogroup_init(struct task_struct *init_task)
 {
 	autogroup_default.tg = &root_task_group;
 	root_task_group.autogroup = &autogroup_default;
