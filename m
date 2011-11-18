Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1KRXnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:43:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53499 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab1KRXnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:43:20 -0500
Date: Fri, 18 Nov 2011 15:42:57 -0800
From: tip-bot for Glauber Costa <glommer@parallels.com>
Message-ID: <tip-f4d6f6c2649c2c47261db4dcc3110d6f22202ea2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, glommer@parallels.com, pjt@google.com,
        tglx@linutronix.de, paul@paulmenage.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        glommer@parallels.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, paul@paulmenage.org, mingo@elte.hu
In-Reply-To: <1320182360-20043-2-git-send-email-glommer@parallels.com>
References: <1320182360-20043-2-git-send-email-glommer@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, trivial: Initialize root cgroup's sibling list
Git-Commit-ID: f4d6f6c2649c2c47261db4dcc3110d6f22202ea2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:43:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4d6f6c2649c2c47261db4dcc3110d6f22202ea2
Gitweb:     http://git.kernel.org/tip/f4d6f6c2649c2c47261db4dcc3110d6f22202ea2
Author:     Glauber Costa <glommer@parallels.com>
AuthorDate: Tue, 1 Nov 2011 19:19:07 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Nov 2011 08:48:22 +0100

sched, trivial: Initialize root cgroup's sibling list

Even though there are no siblings, the list should be
initialized to not contain bogus values.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Acked-by: Paul Turner <pjt@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1320182360-20043-2-git-send-email-glommer@parallels.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d9d79a4..0df6986 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8275,6 +8275,7 @@ void __init sched_init(void)
 #ifdef CONFIG_CGROUP_SCHED
 	list_add(&root_task_group.list, &task_groups);
 	INIT_LIST_HEAD(&root_task_group.children);
+	INIT_LIST_HEAD(&root_task_group.siblings);
 	autogroup_init(&init_task);
 #endif /* CONFIG_CGROUP_SCHED */
 
